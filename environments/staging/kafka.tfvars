# Staging-specific Kafka configuration
# Sensitive variables should be set via environment variables

# Admin credentials (set via environment variables)
# export TF_VAR_kafka_admin_password="your-secure-kafka-password"
# export TF_VAR_schema_registry_password="your-secure-registry-password"

# Override global settings for staging environment
kafka_replicas = 1
zookeeper_replicas = 1

# Minimal resources for cost optimization
kafka_cpu_request = "100m"
kafka_memory_request = "256Mi"
kafka_cpu_limit = "300m"
kafka_memory_limit = "512Mi"
kafka_heap_size = 256

zookeeper_cpu_request = "50m"
zookeeper_memory_request = "128Mi"
zookeeper_cpu_limit = "200m"
zookeeper_memory_limit = "256Mi"

# Kafka Connect settings
enable_kafka_connect = true
kafka_connect_replicas = 1

# Schema Registry settings  
enable_schema_registry = true
schema_registry_replicas = 1

# Kafka UI settings
enable_kafka_ui = true

# Storage optimizations for staging
kafka_storage_size = 10
zookeeper_storage_size = 5