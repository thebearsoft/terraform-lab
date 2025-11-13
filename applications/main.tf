data "terraform_remote_state" "infrastructure" {
  backend = "gcs"
  config = {
    bucket = var.terraform_state_bucket
    prefix = "infrastructure"
  }
  workspace = terraform.workspace
}

data "google_client_config" "default" {}

locals {
  cluster_name = data.terraform_remote_state.infrastructure.outputs.cluster_name
}

# External DNS Service Account  
resource "google_service_account" "external_dns" {
  account_id   = "external-dns"
  display_name = "External DNS Service Account"
  description  = "Service account for External DNS"
}

resource "google_project_iam_member" "external_dns" {
  for_each = toset([
    "roles/dns.admin"
  ])
  
  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.external_dns.email}"
}

resource "google_service_account_iam_member" "external_dns_workload_identity" {
  service_account_id = google_service_account.external_dns.name
  role              = "roles/iam.workloadIdentityUser"
  member            = "serviceAccount:${var.project_id}.svc.id.goog[${var.external_dns_namespace}/${var.external_dns_service_account}]"
}

resource "kubernetes_namespace" "external_dns" {
  count = var.enable_external_dns ? 1 : 0
  
  metadata {
    name = var.external_dns_namespace
  }
}

resource "kubernetes_service_account" "external_dns" {
  count = var.enable_external_dns ? 1 : 0
  
  metadata {
    name      = var.external_dns_service_account
    namespace = var.external_dns_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.external_dns.email
    }
  }
  
  depends_on = [kubernetes_namespace.external_dns]
}

resource "helm_release" "external_dns" {
  count = var.enable_external_dns ? 1 : 0
  
  name       = "external-dns"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = var.external_dns_namespace
  version    = var.external_dns_version
  
  set {
    name  = "provider"
    value = "google"
  }
  
  set {
    name  = "google.project"
    value = var.project_id
  }
  
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  
  set {
    name  = "serviceAccount.name"
    value = var.external_dns_service_account
  }
  
  depends_on = [
    kubernetes_service_account.external_dns
  ]
}

# NGINX Ingress Controller
resource "helm_release" "nginx_ingress" {
  count = var.enable_nginx_ingress ? 1 : 0
  
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = var.nginx_ingress_namespace
  version    = var.nginx_ingress_version
  create_namespace = true
  
  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
  
  set {
    name  = "controller.service.annotations.cloud\\.google\\.com/load-balancer-type"
    value = "External"
  }
  
  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }
  
  set {
    name  = "controller.podAnnotations.prometheus\\.io/scrape"
    value = "true"
  }
  
  set {
    name  = "controller.podAnnotations.prometheus\\.io/port"
    value = "10254"
  }
}

# Cluster Autoscaler
resource "google_service_account" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  
  account_id   = "cluster-autoscaler"
  display_name = "Cluster Autoscaler Service Account"
  description  = "Service account for Cluster Autoscaler"
}

resource "google_project_iam_member" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.cluster_autoscaler[0].email}"
}

resource "google_service_account_iam_member" "cluster_autoscaler_workload_identity" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  
  service_account_id = google_service_account.cluster_autoscaler[0].name
  role              = "roles/iam.workloadIdentityUser"
  member            = "serviceAccount:${var.project_id}.svc.id.goog[${var.cluster_autoscaler_namespace}/${var.cluster_autoscaler_service_account}]"
}

resource "kubernetes_namespace" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  
  metadata {
    name = var.cluster_autoscaler_namespace
  }
}

resource "kubernetes_service_account" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  
  metadata {
    name      = var.cluster_autoscaler_service_account
    namespace = var.cluster_autoscaler_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.cluster_autoscaler[0].email
    }
  }
  
  depends_on = [kubernetes_namespace.cluster_autoscaler]
}

resource "helm_release" "cluster_autoscaler" {
  count = var.enable_cluster_autoscaler ? 1 : 0
  
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = var.cluster_autoscaler_namespace
  version    = var.cluster_autoscaler_version
  
  set {
    name  = "autoDiscovery.clusterName"
    value = local.cluster_name
  }
  
  set {
    name  = "cloudProvider"
    value = "gce"
  }
  
  set {
    name  = "rbac.serviceAccount.create"
    value = "false"
  }
  
  set {
    name  = "rbac.serviceAccount.name"
    value = var.cluster_autoscaler_service_account
  }
  
  depends_on = [
    kubernetes_service_account.cluster_autoscaler
  ]
}

# KEDA - Kubernetes Event-driven Autoscaling
resource "kubernetes_namespace" "keda" {
  count = var.enable_keda ? 1 : 0
  
  metadata {
    name = var.keda_namespace
  }
}

resource "helm_release" "keda" {
  count = var.enable_keda ? 1 : 0
  
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  namespace  = var.keda_namespace
  version    = var.keda_version
  
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  
  set {
    name  = "metricsServer.enabled"
    value = "true"
  }
  
  depends_on = [kubernetes_namespace.keda]
}

# Google Cloud Logging (Fluent Bit equivalent)
resource "google_service_account" "fluentd" {
  count = var.enable_fluentd ? 1 : 0
  
  account_id   = "fluentd"
  display_name = "Fluentd Service Account"
  description  = "Service account for Fluentd logging"
}

resource "google_project_iam_member" "fluentd" {
  count = var.enable_fluentd ? 1 : 0
  
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.fluentd[0].email}"
}

resource "google_service_account_iam_member" "fluentd_workload_identity" {
  count = var.enable_fluentd ? 1 : 0
  
  service_account_id = google_service_account.fluentd[0].name
  role              = "roles/iam.workloadIdentityUser"
  member            = "serviceAccount:${var.project_id}.svc.id.goog[${var.fluentd_namespace}/${var.fluentd_service_account}]"
}

resource "kubernetes_namespace" "fluentd" {
  count = var.enable_fluentd && var.fluentd_namespace != "kube-system" ? 1 : 0
  
  metadata {
    name = var.fluentd_namespace
  }
}

resource "kubernetes_service_account" "fluentd" {
  count = var.enable_fluentd ? 1 : 0
  
  metadata {
    name      = var.fluentd_service_account
    namespace = var.fluentd_namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.fluentd[0].email
    }
  }
  
  depends_on = [kubernetes_namespace.fluentd]
}

resource "helm_release" "fluentd" {
  count = var.enable_fluentd ? 1 : 0
  
  name       = "fluentd"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "fluentd"
  namespace  = var.fluentd_namespace
  version    = var.fluentd_version
  
  set {
    name  = "forwarder.enabled"
    value = "true"
  }
  
  set {
    name  = "aggregator.enabled"
    value = "false"
  }
  
  set {
    name  = "forwarder.serviceAccount.create"
    value = "false"
  }
  
  set {
    name  = "forwarder.serviceAccount.name"
    value = var.fluentd_service_account
  }
  
  depends_on = [
    kubernetes_service_account.fluentd
  ]
}