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

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {}
}

# External DNS configuration
variable "enable_external_dns" {
  description = "Whether to enable External DNS"
  type        = bool
  default     = true
}

variable "external_dns_namespace" {
  description = "Kubernetes namespace for External DNS"
  type        = string
  default     = "external-dns"
}

variable "external_dns_service_account" {
  description = "Service account name for External DNS"
  type        = string
  default     = "external-dns"
}

variable "external_dns_version" {
  description = "External DNS Helm chart version"
  type        = string
  default     = "1.14.3"
}

# NGINX Ingress Controller configuration
variable "enable_nginx_ingress" {
  description = "Whether to enable NGINX Ingress Controller"
  type        = bool
  default     = true
}

variable "nginx_ingress_namespace" {
  description = "Kubernetes namespace for NGINX Ingress"
  type        = string
  default     = "ingress-nginx"
}

variable "nginx_ingress_version" {
  description = "NGINX Ingress Helm chart version"
  type        = string
  default     = "4.8.3"
}

# Cluster Autoscaler configuration
variable "enable_cluster_autoscaler" {
  description = "Whether to enable Cluster Autoscaler"
  type        = bool
  default     = true
}

variable "cluster_autoscaler_namespace" {
  description = "Kubernetes namespace for Cluster Autoscaler"
  type        = string
  default     = "kube-system"
}

variable "cluster_autoscaler_service_account" {
  description = "Service account name for Cluster Autoscaler"
  type        = string
  default     = "cluster-autoscaler"
}

variable "cluster_autoscaler_version" {
  description = "Cluster Autoscaler Helm chart version"
  type        = string
  default     = "9.29.0"
}

# KEDA configuration
variable "enable_keda" {
  description = "Whether to enable KEDA"
  type        = bool
  default     = true
}

variable "keda_namespace" {
  description = "Kubernetes namespace for KEDA"
  type        = string
  default     = "keda"
}

variable "keda_version" {
  description = "KEDA Helm chart version"
  type        = string
  default     = "2.12.0"
}

# Fluentd configuration
variable "enable_fluentd" {
  description = "Whether to enable Fluentd for logging"
  type        = bool
  default     = true
}

variable "fluentd_namespace" {
  description = "Kubernetes namespace for Fluentd"
  type        = string
  default     = "kube-system"
}

variable "fluentd_service_account" {
  description = "Service account name for Fluentd"
  type        = string
  default     = "fluentd"
}

variable "fluentd_version" {
  description = "Fluentd Helm chart version"
  type        = string
  default     = "6.2.3"
}