# Global shared variables for staging environment
# Values that are common across all layers

# Core Configuration
cluster_name     = "bearsoft-staging-gke"
project_id       = "bearsoft-demo"
region           = "us-central1"
environment_name = "staging"

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
subnet_cidr    = "10.0.0.0/24"
services_cidr  = "10.1.0.0/16"
pod_cidr      = "10.2.0.0/16"

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

# Storage Configuration
enable_filestore     = true
filestore_tier       = "BASIC_HDD"
filestore_capacity_gb = 1024
enable_filestore_csi_driver = true

# Node Pool Configuration - Core
core_node_pool_name         = "core-pool"
core_node_pool_machine_type = "e2-small"
core_node_pool_node_count   = 1
core_node_pool_min_nodes    = 1
core_node_pool_max_nodes    = 2
core_node_pool_disk_size    = 50
core_node_pool_disk_type    = "pd-standard"

# Node Pool Configuration - Worker
worker_node_pool_name         = "worker-pool"
worker_node_pool_machine_type = "e2-small"
worker_node_pool_node_count   = 1
worker_node_pool_min_nodes    = 0
worker_node_pool_max_nodes    = 3
worker_node_pool_disk_size    = 50
worker_node_pool_disk_type    = "pd-standard"
worker_node_pool_preemptible  = true

# Kafka Configuration
enable_kafka           = true
kafka_namespace        = "kafka"
kafka_version          = "3.6.0"
strimzi_operator_version = "0.38.0"
kafka_ui_version       = "0.7.5"

# Kafka Cluster Configuration (staging optimized)
kafka_replicas     = 1
kafka_storage_size = 20
zookeeper_replicas = 1
zookeeper_storage_size = 10

# Kafka Resources (staging optimized)
kafka_cpu_request        = "200m"
kafka_memory_request     = "512Mi"
kafka_cpu_limit          = "500m"
kafka_memory_limit       = "1Gi"
kafka_heap_size          = 512

zookeeper_cpu_request    = "100m"
zookeeper_memory_request = "256Mi"
zookeeper_cpu_limit      = "300m"
zookeeper_memory_limit   = "512Mi"

# Kafka Connect Resources
enable_kafka_connect         = true
kafka_connect_replicas       = 1
kafka_connect_cpu_request    = "100m"
kafka_connect_memory_request = "256Mi"
kafka_connect_cpu_limit      = "300m"
kafka_connect_memory_limit   = "512Mi"
kafka_connect_min_replicas   = 1
kafka_connect_max_replicas   = 3

# Schema Registry Resources
enable_schema_registry         = true
schema_registry_replicas       = 1
schema_registry_cpu_request    = "100m"
schema_registry_memory_request = "256Mi"
schema_registry_cpu_limit      = "300m"
schema_registry_memory_limit   = "512Mi"

# Kafka UI Resources
enable_kafka_ui         = true
kafka_ui_cpu_request    = "100m"
kafka_ui_memory_request = "256Mi"
kafka_ui_cpu_limit      = "200m"
kafka_ui_memory_limit   = "512Mi"

# Kafka Admin
kafka_admin_user = "admin"
schema_registry_user = "registry-user"

# Storage
enable_filestore_pv = true
ingress_enabled     = true

# Common Tags
common_tags = {
  Environment = "staging"
  Project     = "bearsoft-demo"
  ManagedBy   = "terraform"
  Company     = "bearsoft"
}