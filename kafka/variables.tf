variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "terraform_state_bucket" {
  description = "GCS bucket for terraform state"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

# Kafka configuration
variable "enable_kafka" {
  description = "Whether to enable Kafka deployment"
  type        = bool
  default     = true
}

variable "kafka_namespace" {
  description = "Kubernetes namespace for Kafka"
  type        = string
  default     = "kafka"
}

variable "kafka_version" {
  description = "Kafka version"
  type        = string
  default     = "3.6.0"
}

variable "strimzi_operator_version" {
  description = "Strimzi Kafka operator Helm chart version"
  type        = string
  default     = "0.38.0"
}

# Kafka cluster configuration
variable "kafka_replicas" {
  description = "Number of Kafka broker replicas"
  type        = number
  default     = 3
}

variable "kafka_storage_size" {
  description = "Storage size per Kafka broker in GB"
  type        = number
  default     = 50
}

variable "kafka_cpu_request" {
  description = "Kafka broker CPU request"
  type        = string
  default     = "200m"
}

variable "kafka_memory_request" {
  description = "Kafka broker memory request"
  type        = string
  default     = "512Mi"
}

variable "kafka_cpu_limit" {
  description = "Kafka broker CPU limit"
  type        = string
  default     = "1000m"
}

variable "kafka_memory_limit" {
  description = "Kafka broker memory limit"
  type        = string
  default     = "1Gi"
}

variable "kafka_heap_size" {
  description = "Kafka broker heap size in MB"
  type        = number
  default     = 768
}

# Zookeeper configuration
variable "zookeeper_replicas" {
  description = "Number of Zookeeper replicas"
  type        = number
  default     = 3
}

variable "zookeeper_storage_size" {
  description = "Storage size per Zookeeper node in GB"
  type        = number
  default     = 10
}

variable "zookeeper_cpu_request" {
  description = "Zookeeper CPU request"
  type        = string
  default     = "100m"
}

variable "zookeeper_memory_request" {
  description = "Zookeeper memory request"
  type        = string
  default     = "256Mi"
}

variable "zookeeper_cpu_limit" {
  description = "Zookeeper CPU limit"
  type        = string
  default     = "500m"
}

variable "zookeeper_memory_limit" {
  description = "Zookeeper memory limit"
  type        = string
  default     = "512Mi"
}

# Kafka Connect configuration
variable "enable_kafka_connect" {
  description = "Whether to enable Kafka Connect"
  type        = bool
  default     = true
}

variable "kafka_connect_replicas" {
  description = "Number of Kafka Connect replicas"
  type        = number
  default     = 2
}

variable "kafka_connect_cpu_request" {
  description = "Kafka Connect CPU request"
  type        = string
  default     = "200m"
}

variable "kafka_connect_memory_request" {
  description = "Kafka Connect memory request"
  type        = string
  default     = "512Mi"
}

variable "kafka_connect_cpu_limit" {
  description = "Kafka Connect CPU limit"
  type        = string
  default     = "1000m"
}

variable "kafka_connect_memory_limit" {
  description = "Kafka Connect memory limit"
  type        = string
  default     = "1Gi"
}

variable "kafka_connect_min_replicas" {
  description = "Minimum replicas for Kafka Connect autoscaling"
  type        = number
  default     = 1
}

variable "kafka_connect_max_replicas" {
  description = "Maximum replicas for Kafka Connect autoscaling"
  type        = number
  default     = 5
}

# Schema Registry configuration
variable "enable_schema_registry" {
  description = "Whether to enable Schema Registry"
  type        = bool
  default     = true
}

variable "schema_registry_version" {
  description = "Schema Registry Helm chart version"
  type        = string
  default     = "0.6.2"
}

variable "schema_registry_replicas" {
  description = "Number of Schema Registry replicas"
  type        = number
  default     = 1
}

variable "schema_registry_cpu_request" {
  description = "Schema Registry CPU request"
  type        = string
  default     = "100m"
}

variable "schema_registry_memory_request" {
  description = "Schema Registry memory request"
  type        = string
  default     = "256Mi"
}

variable "schema_registry_cpu_limit" {
  description = "Schema Registry CPU limit"
  type        = string
  default     = "500m"
}

variable "schema_registry_memory_limit" {
  description = "Schema Registry memory limit"
  type        = string
  default     = "512Mi"
}

variable "schema_registry_user" {
  description = "Schema Registry username"
  type        = string
  default     = "registry-user"
}

variable "schema_registry_password" {
  description = "Schema Registry password"
  type        = string
  sensitive   = true
}

# Kafka UI configuration
variable "enable_kafka_ui" {
  description = "Whether to enable Kafka UI"
  type        = bool
  default     = true
}

variable "kafka_ui_version" {
  description = "Kafka UI Helm chart version"
  type        = string
  default     = "0.7.5"
}

variable "kafka_ui_cpu_request" {
  description = "Kafka UI CPU request"
  type        = string
  default     = "100m"
}

variable "kafka_ui_memory_request" {
  description = "Kafka UI memory request"
  type        = string
  default     = "256Mi"
}

variable "kafka_ui_cpu_limit" {
  description = "Kafka UI CPU limit"
  type        = string
  default     = "500m"
}

variable "kafka_ui_memory_limit" {
  description = "Kafka UI memory limit"
  type        = string
  default     = "512Mi"
}

variable "kafka_admin_user" {
  description = "Kafka admin username"
  type        = string
  default     = "admin"
}

variable "kafka_admin_password" {
  description = "Kafka admin password"
  type        = string
  sensitive   = true
}

# Storage configuration
variable "enable_filestore_pv" {
  description = "Whether to enable Filestore persistent volume for Kafka data"
  type        = bool
  default     = true
}

# Ingress configuration
variable "ingress_enabled" {
  description = "Whether to enable ingress for Kafka UI"
  type        = bool
  default     = true
}

# KEDA configuration
variable "enable_keda" {
  description = "Whether to enable KEDA autoscaling"
  type        = bool
  default     = true
}