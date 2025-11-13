data "terraform_remote_state" "infrastructure" {
  backend = "gcs"
  config = {
    bucket = var.terraform_state_bucket
    prefix = "infrastructure"
  }
  workspace = terraform.workspace
}

data "google_client_config" "default" {}
data "google_project" "current" {}

locals {
  cluster_name     = data.terraform_remote_state.infrastructure.outputs.cluster_name
  project_id       = data.google_project.current.project_id
  kafka_name       = "kafka"
  kafka_namespace  = var.kafka_namespace
  
  tags = merge(var.common_tags, {
    Blueprint = local.cluster_name
  })
}

# Service Account for Kafka
resource "google_service_account" "kafka" {
  count = var.enable_kafka ? 1 : 0
  
  account_id   = "kafka"
  display_name = "Kafka Service Account"
  description  = "Service account for Kafka components"
}

# IAM bindings for Kafka service account
resource "google_project_iam_member" "kafka" {
  count = var.enable_kafka ? 1 : 0
  
  project = local.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.kafka[0].email}"
}

resource "google_storage_bucket_iam_member" "kafka_logs" {
  count = var.enable_kafka ? 1 : 0
  
  bucket = data.terraform_remote_state.infrastructure.outputs.logs_bucket_name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.kafka[0].email}"
}

# Workload Identity binding
resource "google_service_account_iam_member" "kafka_workload_identity" {
  count = var.enable_kafka ? 1 : 0
  
  service_account_id = google_service_account.kafka[0].name
  role              = "roles/iam.workloadIdentityUser"
  member            = "serviceAccount:${local.project_id}.svc.id.goog[${var.kafka_namespace}/kafka]"
}

# Kubernetes namespace for Kafka
resource "kubernetes_namespace" "kafka" {
  count = var.enable_kafka ? 1 : 0
  
  metadata {
    name = local.kafka_namespace
  }
}

# Kubernetes service account for Kafka
resource "kubernetes_service_account" "kafka" {
  count = var.enable_kafka ? 1 : 0
  
  metadata {
    name      = "kafka"
    namespace = var.kafka_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.kafka[0].email
    }
  }
  
  depends_on = [kubernetes_namespace.kafka]
}

# Persistent Volume for Kafka data using Filestore
resource "kubernetes_persistent_volume" "kafka_data" {
  count = var.enable_kafka && var.enable_filestore_pv ? 1 : 0
  
  metadata {
    name = "kafka-data-pv"
  }
  
  spec {
    capacity = {
      storage = "200Gi"
    }
    
    access_modes       = ["ReadWriteMany"]
    storage_class_name = "filestore-csi"
    
    persistent_volume_source {
      csi {
        driver        = "filestore.csi.storage.gke.io"
        volume_handle = "${var.region}/${data.terraform_remote_state.infrastructure.outputs.filestore_file_share_name}/${data.terraform_remote_state.infrastructure.outputs.filestore_ip_address}"
        
        volume_attributes = {
          ip    = data.terraform_remote_state.infrastructure.outputs.filestore_ip_address
          share = data.terraform_remote_state.infrastructure.outputs.filestore_file_share_name
        }
      }
    }
  }
}

# Persistent Volume Claim for Kafka data
resource "kubernetes_persistent_volume_claim" "kafka_data" {
  count = var.enable_kafka && var.enable_filestore_pv ? 1 : 0
  
  metadata {
    name      = "kafka-data-pvc"
    namespace = var.kafka_namespace
  }
  
  spec {
    access_modes = ["ReadWriteMany"]
    
    resources {
      requests = {
        storage = "200Gi"
      }
    }
    
    volume_name        = kubernetes_persistent_volume.kafka_data[0].metadata[0].name
    storage_class_name = "filestore-csi"
  }
  
  depends_on = [kubernetes_namespace.kafka]
}

# Secret for Kafka admin credentials
resource "kubernetes_secret" "kafka_admin" {
  count = var.enable_kafka ? 1 : 0
  
  metadata {
    name      = "kafka-admin-secret"
    namespace = var.kafka_namespace
  }
  
  data = {
    admin-user     = var.kafka_admin_user
    admin-password = var.kafka_admin_password
  }
  
  type = "Opaque"
  
  depends_on = [kubernetes_namespace.kafka]
}

# Secret for Schema Registry
resource "kubernetes_secret" "schema_registry" {
  count = var.enable_kafka ? 1 : 0
  
  metadata {
    name      = "schema-registry-secret"
    namespace = var.kafka_namespace
  }
  
  data = {
    registry-user     = var.schema_registry_user
    registry-password = var.schema_registry_password
  }
  
  type = "Opaque"
  
  depends_on = [kubernetes_namespace.kafka]
}

# Helm release for Apache Kafka using Strimzi operator
resource "helm_release" "strimzi_operator" {
  count = var.enable_kafka ? 1 : 0
  
  name       = "strimzi-kafka-operator"
  repository = "https://strimzi.io/charts/"
  chart      = "strimzi-kafka-operator"
  namespace  = var.kafka_namespace
  version    = var.strimzi_operator_version
  
  depends_on = [kubernetes_namespace.kafka]
}

# Kafka cluster using Strimzi
resource "kubernetes_manifest" "kafka_cluster" {
  count = var.enable_kafka ? 1 : 0
  
  manifest = {
    apiVersion = "kafka.strimzi.io/v1beta2"
    kind       = "Kafka"
    
    metadata = {
      name      = "kafka-cluster"
      namespace = var.kafka_namespace
    }
    
    spec = {
      kafka = {
        version = var.kafka_version
        replicas = var.kafka_replicas
        
        listeners = [
          {
            name = "plain"
            port = 9092
            type = "internal"
            tls  = false
          },
          {
            name = "tls"
            port = 9093
            type = "internal"
            tls  = true
          }
        ]
        
        config = {
          "offsets.topic.replication.factor" = min(var.kafka_replicas, 3)
          "transaction.state.log.replication.factor" = min(var.kafka_replicas, 3)
          "transaction.state.log.min.isr" = min(var.kafka_replicas, 2)
          "default.replication.factor" = min(var.kafka_replicas, 3)
          "min.insync.replicas" = min(var.kafka_replicas, 2)
          "inter.broker.protocol.version" = var.kafka_version
        }
        
        storage = {
          type = "persistent-claim"
          size = "${var.kafka_storage_size}Gi"
          class = "standard-rwo"
        }
        
        resources = {
          requests = {
            memory = var.kafka_memory_request
            cpu    = var.kafka_cpu_request
          }
          limits = {
            memory = var.kafka_memory_limit
            cpu    = var.kafka_cpu_limit
          }
        }
        
        jvmOptions = {
          "-Xmx" = "${var.kafka_heap_size}m"
          "-Xms" = "${var.kafka_heap_size}m"
        }
        
        metricsConfig = {
          type = "jmxPrometheusExporter"
          valueFrom = {
            configMapKeyRef = {
              name = "kafka-metrics"
              key  = "kafka-metrics-config.yml"
            }
          }
        }
      }
      
      zookeeper = {
        replicas = var.zookeeper_replicas
        
        storage = {
          type = "persistent-claim"
          size = "${var.zookeeper_storage_size}Gi"
          class = "standard-rwo"
        }
        
        resources = {
          requests = {
            memory = var.zookeeper_memory_request
            cpu    = var.zookeeper_cpu_request
          }
          limits = {
            memory = var.zookeeper_memory_limit
            cpu    = var.zookeeper_cpu_limit
          }
        }
        
        metricsConfig = {
          type = "jmxPrometheusExporter"
          valueFrom = {
            configMapKeyRef = {
              name = "kafka-metrics"
              key  = "zookeeper-metrics-config.yml"
            }
          }
        }
      }
      
      entityOperator = {
        topicOperator = {}
        userOperator = {}
      }
    }
  }
  
  depends_on = [
    helm_release.strimzi_operator,
    kubernetes_config_map.kafka_metrics
  ]
}

# ConfigMap for Kafka metrics
resource "kubernetes_config_map" "kafka_metrics" {
  count = var.enable_kafka ? 1 : 0
  
  metadata {
    name      = "kafka-metrics"
    namespace = var.kafka_namespace
  }
  
  data = {
    "kafka-metrics-config.yml" = file("${path.module}/helm-values/kafka-metrics-config.yml")
    "zookeeper-metrics-config.yml" = file("${path.module}/helm-values/zookeeper-metrics-config.yml")
  }
  
  depends_on = [kubernetes_namespace.kafka]
}

# Kafka Connect cluster
resource "kubernetes_manifest" "kafka_connect" {
  count = var.enable_kafka && var.enable_kafka_connect ? 1 : 0
  
  manifest = {
    apiVersion = "kafka.strimzi.io/v1beta2"
    kind       = "KafkaConnect"
    
    metadata = {
      name      = "kafka-connect"
      namespace = var.kafka_namespace
      annotations = {
        "strimzi.io/use-connector-resources" = "true"
      }
    }
    
    spec = {
      version = var.kafka_version
      replicas = var.kafka_connect_replicas
      
      bootstrapServers = "kafka-cluster-kafka-bootstrap:9093"
      
      tls = {
        trustedCertificates = [
          {
            secretName = "kafka-cluster-cluster-ca-cert"
            certificate = "ca.crt"
          }
        ]
      }
      
      config = {
        "group.id" = "connect-cluster"
        "offset.storage.topic" = "connect-cluster-offsets"
        "config.storage.topic" = "connect-cluster-configs"
        "status.storage.topic" = "connect-cluster-status"
        "config.storage.replication.factor" = min(var.kafka_replicas, 3)
        "offset.storage.replication.factor" = min(var.kafka_replicas, 3)
        "status.storage.replication.factor" = min(var.kafka_replicas, 3)
      }
      
      resources = {
        requests = {
          memory = var.kafka_connect_memory_request
          cpu    = var.kafka_connect_cpu_request
        }
        limits = {
          memory = var.kafka_connect_memory_limit
          cpu    = var.kafka_connect_cpu_limit
        }
      }
    }
  }
  
  depends_on = [kubernetes_manifest.kafka_cluster]
}

# Schema Registry using Confluent Helm chart
resource "helm_release" "schema_registry" {
  count = var.enable_kafka && var.enable_schema_registry ? 1 : 0
  
  name       = "schema-registry"
  repository = "https://confluentinc.github.io/cp-helm-charts/"
  chart      = "cp-schema-registry"
  namespace  = var.kafka_namespace
  version    = var.schema_registry_version
  
  values = [
    templatefile("${path.module}/helm-values/schema-registry-values.yaml", {
      kafka_bootstrap_servers = "kafka-cluster-kafka-bootstrap:9092"
      replicas               = var.schema_registry_replicas
      cpu_request            = var.schema_registry_cpu_request
      memory_request         = var.schema_registry_memory_request
      cpu_limit              = var.schema_registry_cpu_limit
      memory_limit           = var.schema_registry_memory_limit
    })
  ]
  
  depends_on = [kubernetes_manifest.kafka_cluster]
}

# Kafka UI for management and monitoring
resource "helm_release" "kafka_ui" {
  count = var.enable_kafka && var.enable_kafka_ui ? 1 : 0
  
  name       = "kafka-ui"
  repository = "https://provectus.github.io/kafka-ui"
  chart      = "kafka-ui"
  namespace  = var.kafka_namespace
  version    = var.kafka_ui_version
  
  values = [
    templatefile("${path.module}/helm-values/kafka-ui-values.yaml", {
      kafka_bootstrap_servers    = "kafka-cluster-kafka-bootstrap:9092"
      schema_registry_url       = var.enable_schema_registry ? "http://schema-registry:8081" : ""
      kafka_connect_url         = var.enable_kafka_connect ? "http://kafka-connect-api:8083" : ""
      ingress_enabled           = var.ingress_enabled
      admin_user                = var.kafka_admin_user
      admin_password            = var.kafka_admin_password
      cpu_request               = var.kafka_ui_cpu_request
      memory_request            = var.kafka_ui_memory_request
      cpu_limit                 = var.kafka_ui_cpu_limit
      memory_limit              = var.kafka_ui_memory_limit
    })
  ]
  
  depends_on = [
    kubernetes_manifest.kafka_cluster,
    helm_release.schema_registry,
    kubernetes_manifest.kafka_connect
  ]
}

# KEDA ScaledObject for Kafka Connect autoscaling
resource "kubernetes_manifest" "keda_scaled_object" {
  count = var.enable_kafka && var.enable_keda && var.enable_kafka_connect ? 1 : 0
  
  manifest = {
    apiVersion = "keda.sh/v1alpha1"
    kind       = "ScaledObject"
    
    metadata = {
      name      = "kafka-connect-scaler"
      namespace = var.kafka_namespace
    }
    
    spec = {
      scaleTargetRef = {
        name = "kafka-connect"
      }
      
      minReplicaCount = var.kafka_connect_min_replicas
      maxReplicaCount = var.kafka_connect_max_replicas
      
      triggers = [
        {
          type = "kafka"
          metadata = {
            bootstrapServers = "kafka-cluster-kafka-bootstrap:9092"
            consumerGroup    = "connect-cluster"
            topic            = "connect-cluster-offsets"
            lagThreshold     = "10"
          }
        }
      ]
    }
  }
  
  depends_on = [kubernetes_manifest.kafka_connect]
}