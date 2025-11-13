output "kafka_namespace" {
  description = "Kafka namespace"
  value       = var.enable_kafka ? kubernetes_namespace.kafka[0].metadata[0].name : null
}

output "kafka_cluster_name" {
  description = "Kafka cluster name"
  value       = var.enable_kafka ? "kafka-cluster" : null
}

output "kafka_bootstrap_servers" {
  description = "Kafka bootstrap servers"
  value       = var.enable_kafka ? "kafka-cluster-kafka-bootstrap:9092" : null
}

output "kafka_bootstrap_servers_tls" {
  description = "Kafka bootstrap servers with TLS"
  value       = var.enable_kafka ? "kafka-cluster-kafka-bootstrap:9093" : null
}

output "schema_registry_url" {
  description = "Schema Registry URL"
  value       = var.enable_kafka && var.enable_schema_registry ? "http://schema-registry:8081" : null
}

output "kafka_connect_url" {
  description = "Kafka Connect URL"
  value       = var.enable_kafka && var.enable_kafka_connect ? "http://kafka-connect-api:8083" : null
}

output "kafka_ui_service_name" {
  description = "Kafka UI service name"
  value       = var.enable_kafka && var.enable_kafka_ui ? "kafka-ui" : null
}

output "kafka_ui_port" {
  description = "Kafka UI port"
  value       = var.enable_kafka && var.enable_kafka_ui ? 8080 : null
}

output "kafka_service_account_email" {
  description = "Kafka service account email"
  value       = var.enable_kafka ? google_service_account.kafka[0].email : null
}