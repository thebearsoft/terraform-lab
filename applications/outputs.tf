# Service Account outputs
output "external_dns_service_account_email" {
  description = "External DNS service account email"
  value       = var.enable_external_dns ? google_service_account.external_dns.email : null
}

output "cluster_autoscaler_service_account_email" {
  description = "Cluster Autoscaler service account email"  
  value       = var.enable_cluster_autoscaler ? google_service_account.cluster_autoscaler[0].email : null
}

output "fluentd_service_account_email" {
  description = "Fluentd service account email"
  value       = var.enable_fluentd ? google_service_account.fluentd[0].email : null
}

# Load Balancer IP
output "nginx_ingress_load_balancer_ip" {
  description = "NGINX Ingress Controller Load Balancer IP"
  value       = var.enable_nginx_ingress ? data.kubernetes_service.nginx_ingress[0].status[0].load_balancer[0].ingress[0].ip : null
}

data "kubernetes_service" "nginx_ingress" {
  count = var.enable_nginx_ingress ? 1 : 0
  
  metadata {
    name      = "nginx-ingress-ingress-nginx-controller"
    namespace = var.nginx_ingress_namespace
  }
  
  depends_on = [helm_release.nginx_ingress]
}