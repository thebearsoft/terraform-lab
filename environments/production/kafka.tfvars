# Production-specific Kafka configuration
# Sensitive variables should be set via environment variables

# Admin credentials (set via environment variables)
# export TF_VAR_kafka_admin_password="your-secure-kafka-password"
# export TF_VAR_schema_registry_password="your-secure-registry-password"

# Production-grade Kafka cluster
kafka_replicas = 3
zookeeper_replicas = 3

# High-performance resources
kafka_cpu_request = "1000m"
kafka_memory_request = "2Gi"
kafka_cpu_limit = "2000m"
kafka_memory_limit = "4Gi"
kafka_heap_size = 2048

zookeeper_cpu_request = "500m"
zookeeper_memory_request = "1Gi"
zookeeper_cpu_limit = "1000m"
zookeeper_memory_limit = "2Gi"

# Production Kafka Connect settings
enable_kafka_connect = true
kafka_connect_replicas = 3
kafka_connect_cpu_request = "500m"
kafka_connect_memory_request = "1Gi"
kafka_connect_cpu_limit = "1000m"
kafka_connect_memory_limit = "2Gi"
kafka_connect_min_replicas = 2
kafka_connect_max_replicas = 10

# Production Schema Registry settings  
enable_schema_registry = true
schema_registry_replicas = 2
schema_registry_cpu_request = "500m"
schema_registry_memory_request = "1Gi"
schema_registry_cpu_limit = "1000m"
schema_registry_memory_limit = "2Gi"

# Kafka UI settings
enable_kafka_ui = true
kafka_ui_cpu_request = "200m"
kafka_ui_memory_request = "512Mi"
kafka_ui_cpu_limit = "500m"
kafka_ui_memory_limit = "1Gi"

# High-performance storage for production
kafka_storage_size = 100
zookeeper_storage_size = 50