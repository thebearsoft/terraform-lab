# Global shared variables for production environment
# Values that are common across all layers

# Core Configuration
cluster_name     = "bearsoft-production-gke"
project_id       = "bearsoft-demo"
region           = "us-central1"
environment_name = "production"

# Backend Configuration
terraform_state_bucket = "bearsoft-terraform-state"

# Feature Flags
enable_external_dns        = true
enable_nginx_ingress       = true
enable_cluster_autoscaler  = true
enable_keda               = true
enable_fluentd            = true
enable_cloud_monitoring   = true

# Network Configuration
subnet_cidr    = "10.10.0.0/24"
services_cidr  = "10.11.0.0/16"
pod_cidr      = "10.12.0.0/16"

# Service Account Names
external_dns_service_account      = "external-dns"
cluster_autoscaler_service_account = "cluster-autoscaler"
fluentd_service_account           = "fluentd"

# Namespace Configuration
external_dns_namespace      = "external-dns"
nginx_ingress_namespace     = "ingress-nginx"
cluster_autoscaler_namespace = "kube-system"
keda_namespace              = "keda"
fluentd_namespace           = "kube-system"

# Helm Chart Versions
external_dns_version       = "1.14.3"
nginx_ingress_version      = "4.8.3"
cluster_autoscaler_version = "9.29.0"
keda_version              = "2.12.0"
fluentd_version           = "6.2.3"

# Storage Configuration (production scale)
enable_filestore     = true
filestore_tier       = "BASIC_SSD"
filestore_capacity_gb = 2048
enable_filestore_csi_driver = true

# Node Pool Configuration - Core (production scale)
core_node_pool_name         = "core-pool"
core_node_pool_machine_type = "e2-medium"
core_node_pool_node_count   = 2
core_node_pool_min_nodes    = 2
core_node_pool_max_nodes    = 5
core_node_pool_disk_size    = 100
core_node_pool_disk_type    = "pd-ssd"

# Node Pool Configuration - Worker (production scale)
worker_node_pool_name         = "worker-pool"
worker_node_pool_machine_type = "e2-standard-4"
worker_node_pool_node_count   = 3
worker_node_pool_min_nodes    = 1
worker_node_pool_max_nodes    = 20
worker_node_pool_disk_size    = 100
worker_node_pool_disk_type    = "pd-ssd"
worker_node_pool_preemptible  = false

# Kafka Configuration
enable_kafka           = true
kafka_namespace        = "kafka"
kafka_version          = "3.6.0"
strimzi_operator_version = "0.38.0"
kafka_ui_version       = "0.7.5"

# Kafka Cluster Configuration (production scale)
kafka_replicas     = 3
kafka_storage_size = 100
zookeeper_replicas = 3
zookeeper_storage_size = 50

# Kafka Resources (production scale)
kafka_cpu_request        = "1000m"
kafka_memory_request     = "2Gi"
kafka_cpu_limit          = "2000m"
kafka_memory_limit       = "4Gi"
kafka_heap_size          = 2048

zookeeper_cpu_request    = "500m"
zookeeper_memory_request = "1Gi"
zookeeper_cpu_limit      = "1000m"
zookeeper_memory_limit   = "2Gi"

# Kafka Connect Resources
enable_kafka_connect         = true
kafka_connect_replicas       = 3
kafka_connect_cpu_request    = "500m"
kafka_connect_memory_request = "1Gi"
kafka_connect_cpu_limit      = "1000m"
kafka_connect_memory_limit   = "2Gi"
kafka_connect_min_replicas   = 2
kafka_connect_max_replicas   = 10

# Schema Registry Resources
enable_schema_registry         = true
schema_registry_replicas       = 2
schema_registry_cpu_request    = "500m"
schema_registry_memory_request = "1Gi"
schema_registry_cpu_limit      = "1000m"
schema_registry_memory_limit   = "2Gi"

# Kafka UI Resources
enable_kafka_ui         = true
kafka_ui_cpu_request    = "200m"
kafka_ui_memory_request = "512Mi"
kafka_ui_cpu_limit      = "500m"
kafka_ui_memory_limit   = "1Gi"

# Kafka Admin
kafka_admin_user = "admin"
schema_registry_user = "registry-user"

# Storage
enable_filestore_pv = true
ingress_enabled    = true

# Common Tags
common_tags = {
  Environment = "production"
  Project     = "bearsoft-demo"
  ManagedBy   = "terraform"
  Company     = "bearsoft"
}