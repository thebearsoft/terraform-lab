# Common variables
variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

# Network configuration
variable "subnet_cidr" {
  description = "CIDR block for the subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "services_cidr" {
  description = "CIDR block for services"
  type        = string
  default     = "10.1.0.0/16"
}

variable "pod_cidr" {
  description = "CIDR block for pods"
  type        = string
  default     = "10.2.0.0/16"
}

# Core node pool configuration
variable "core_node_pool_name" {
  description = "Name of the core node pool"
  type        = string
  default     = "core-pool"
}

variable "core_node_pool_machine_type" {
  description = "Machine type for core node pool"
  type        = string
  default     = "e2-medium"
}

variable "core_node_pool_node_count" {
  description = "Initial number of nodes in core pool"
  type        = number
  default     = 1
}

variable "core_node_pool_min_nodes" {
  description = "Minimum number of nodes in core pool"
  type        = number
  default     = 1
}

variable "core_node_pool_max_nodes" {
  description = "Maximum number of nodes in core pool"
  type        = number
  default     = 3
}

variable "core_node_pool_disk_size" {
  description = "Disk size for core node pool (GB)"
  type        = number
  default     = 100
}

variable "core_node_pool_disk_type" {
  description = "Disk type for core node pool"
  type        = string
  default     = "pd-standard"
}

# Worker node pool configuration
variable "worker_node_pool_name" {
  description = "Name of the worker node pool"
  type        = string
  default     = "worker-pool"
}

variable "worker_node_pool_machine_type" {
  description = "Machine type for worker node pool"
  type        = string
  default     = "e2-medium"
}

variable "worker_node_pool_node_count" {
  description = "Initial number of nodes in worker pool"
  type        = number
  default     = 1
}

variable "worker_node_pool_min_nodes" {
  description = "Minimum number of nodes in worker pool"
  type        = number
  default     = 0
}

variable "worker_node_pool_max_nodes" {
  description = "Maximum number of nodes in worker pool"
  type        = number
  default     = 10
}

variable "worker_node_pool_disk_size" {
  description = "Disk size for worker node pool (GB)"
  type        = number
  default     = 100
}

variable "worker_node_pool_disk_type" {
  description = "Disk type for worker node pool"
  type        = string
  default     = "pd-standard"
}

variable "worker_node_pool_preemptible" {
  description = "Whether worker nodes should be preemptible"
  type        = bool
  default     = true
}

# Storage configuration
variable "enable_filestore" {
  description = "Whether to create Filestore instance"
  type        = bool
  default     = true
}

variable "filestore_tier" {
  description = "Filestore tier"
  type        = string
  default     = "BASIC_HDD"
}

variable "filestore_capacity_gb" {
  description = "Filestore capacity in GB"
  type        = number
  default     = 1024
}

variable "enable_filestore_csi_driver" {
  description = "Whether to enable Filestore CSI driver"
  type        = bool
  default     = true
}

# Monitoring
variable "enable_cloud_monitoring" {
  description = "Whether to enable Cloud Monitoring workspace"
  type        = bool
  default     = true
}