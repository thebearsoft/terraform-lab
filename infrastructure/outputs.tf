# Cluster outputs
output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.primary.name
}

output "cluster_endpoint" {
  description = "GKE cluster endpoint"
  value       = google_container_cluster.primary.endpoint
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "GKE cluster CA certificate"
  value       = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "cluster_location" {
  description = "GKE cluster location"
  value       = google_container_cluster.primary.location
}

# Network outputs
output "network_name" {
  description = "VPC network name"
  value       = google_compute_network.vpc.name
}

output "network_self_link" {
  description = "VPC network self link"
  value       = google_compute_network.vpc.self_link
}

output "subnet_name" {
  description = "Subnet name"
  value       = google_compute_subnetwork.subnet.name
}

output "subnet_self_link" {
  description = "Subnet self link"
  value       = google_compute_subnetwork.subnet.self_link
}

# Service Account outputs
output "gke_node_service_account_email" {
  description = "GKE node service account email"
  value       = google_service_account.gke_node.email
}

# Storage outputs
output "logs_bucket_name" {
  description = "Cloud Storage bucket for logs"
  value       = google_storage_bucket.logs.name
}

output "logs_bucket_url" {
  description = "Cloud Storage bucket URL"
  value       = google_storage_bucket.logs.url
}

output "filestore_ip_address" {
  description = "Filestore instance IP address"
  value       = var.enable_filestore ? google_filestore_instance.airflow[0].networks[0].ip_addresses[0] : null
}

output "filestore_file_share_name" {
  description = "Filestore file share name"
  value       = var.enable_filestore ? google_filestore_instance.airflow[0].file_shares[0].name : null
}

# Project information
output "project_id" {
  description = "GCP project ID"
  value       = data.google_project.current.project_id
}