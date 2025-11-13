data "google_client_config" "default" {}
data "google_project" "current" {}

locals {
  name   = var.cluster_name
  region = var.region
  
  tags = merge(var.common_tags, {
    Blueprint = local.name
  })
}

# GKE Cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region
  
  # Remove default node pool
  remove_default_node_pool = true
  initial_node_count       = 1
  
  # Network configuration
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
  
  # Enable necessary APIs
  addons_config {
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
    gcp_filestore_csi_driver_config {
      enabled = var.enable_filestore_csi_driver
    }
  }
  
  # Workload Identity
  workload_identity_config {
    workload_pool = "${data.google_project.current.project_id}.svc.id.goog"
  }
  
  # Network policy
  network_policy {
    enabled = true
  }
  
  # Enable monitoring
  monitoring_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
  
  # Enable logging
  logging_config {
    enable_components = ["SYSTEM_COMPONENTS", "WORKLOADS"]
  }
}

# Core Node Pool
resource "google_container_node_pool" "core_nodes" {
  name       = var.core_node_pool_name
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.core_node_pool_node_count

  node_config {
    preemptible  = false
    machine_type = var.core_node_pool_machine_type

    # Google Cloud Service Account
    service_account = google_service_account.gke_node.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      WorkerType    = "ON_DEMAND"
      NodePoolType  = "core"
    }

    tags = ["gke-node"]
    
    # Disk configuration
    disk_size_gb = var.core_node_pool_disk_size
    disk_type    = var.core_node_pool_disk_type
    
    # Workload Identity
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  autoscaling {
    min_node_count = var.core_node_pool_min_nodes
    max_node_count = var.core_node_pool_max_nodes
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

# Worker Node Pool
resource "google_container_node_pool" "worker_nodes" {
  name       = var.worker_node_pool_name
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.worker_node_pool_node_count

  node_config {
    preemptible  = var.worker_node_pool_preemptible
    machine_type = var.worker_node_pool_machine_type

    service_account = google_service_account.gke_node.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      WorkerType   = var.worker_node_pool_preemptible ? "SPOT" : "ON_DEMAND"
      NodePoolType = "worker"
    }

    tags = ["gke-node"]
    
    disk_size_gb = var.worker_node_pool_disk_size
    disk_type    = var.worker_node_pool_disk_type
    
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }

  autoscaling {
    min_node_count = var.worker_node_pool_min_nodes
    max_node_count = var.worker_node_pool_max_nodes
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}

# VPC Network
resource "google_compute_network" "vpc" {
  name                    = "${var.cluster_name}-vpc"
  auto_create_subnetworks = false
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.cluster_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.name

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = var.services_cidr
  }

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = var.pod_cidr
  }
}

# Cloud Router
resource "google_compute_router" "router" {
  name    = "${var.cluster_name}-router"
  region  = var.region
  network = google_compute_network.vpc.id
}

# NAT Gateway
resource "google_compute_router_nat" "nat" {
  name                               = "${var.cluster_name}-nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# Firewall rule for GKE nodes
resource "google_compute_firewall" "gke_nodes" {
  name    = "${var.cluster_name}-gke-nodes"
  network = google_compute_network.vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22", "80", "443", "8080", "10250"]
  }

  source_ranges = ["10.0.0.0/8"]
  target_tags   = ["gke-node"]
}

# Service Account for GKE nodes
resource "google_service_account" "gke_node" {
  account_id   = "${var.cluster_name}-gke-node"
  display_name = "GKE Node Service Account"
  description  = "Service account for GKE nodes in ${var.cluster_name} cluster"
}

# IAM bindings for GKE node service account
resource "google_project_iam_member" "gke_node_service_account" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/stackdriver.resourceMetadata.writer"
  ])
  
  project = data.google_project.current.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.gke_node.email}"
}

# Cloud Storage bucket for logs
resource "google_storage_bucket" "logs" {
  name     = "${var.cluster_name}-logs-${random_id.bucket_suffix.hex}"
  location = var.region

  # Lifecycle to manage old logs
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }

  # Prevent accidental deletion
  lifecycle {
    prevent_destroy = false
  }
}

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# Filestore instance for shared storage
resource "google_filestore_instance" "airflow" {
  count = var.enable_filestore ? 1 : 0
  
  name     = "${var.cluster_name}-filestore"
  location = var.region
  tier     = var.filestore_tier

  file_shares {
    capacity_gb = var.filestore_capacity_gb
    name        = "airflow"
  }

  networks {
    network = google_compute_network.vpc.name
    modes   = ["MODE_IPV4"]
  }
}

# Cloud Monitoring workspace
resource "google_monitoring_workspace" "workspace" {
  count = var.enable_cloud_monitoring ? 1 : 0
  depends_on = [google_container_cluster.primary]
}