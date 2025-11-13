# Bearsoft.ai GCP Infrastructure Deployment Guide

This repository contains a simplified 3-layer Terraform architecture for deploying applications on Google Cloud Platform, inspired by enterprise-grade patterns.

## Architecture Overview

The infrastructure is organized into three distinct layers:

### 1. Infrastructure Layer
- **GKE Cluster**: Managed Kubernetes cluster with autoscaling node pools
- **Networking**: VPC, subnets, firewall rules, NAT gateway
- **Storage**: Cloud Storage buckets, optional Filestore for shared storage
- **IAM**: Service accounts and role bindings
- **Monitoring**: Cloud Monitoring workspace (optional)

### 2. Applications Layer
- **External DNS**: Automatic DNS record management
- **NGINX Ingress Controller**: Load balancing and ingress
- **Cluster Autoscaler**: Node pool scaling based on demand
- **KEDA**: Event-driven pod autoscaling
- **Fluentd**: Log collection and forwarding to Cloud Logging

### 3. Kafka Layer
- **Apache Kafka**: Distributed event streaming platform
- **Zookeeper**: Coordination service for Kafka cluster
- **Kafka Connect**: Data integration framework
- **Schema Registry**: Schema management for Kafka topics
- **Kafka UI**: Management interface for monitoring and administration

## Prerequisites

1. **GCP Project**: Active GCP project with billing enabled
2. **APIs Enabled**: Required GCP APIs (see setup section)
3. **Authentication**: GCP credentials configured
4. **Terraform**: Version >= 1.0
5. **kubectl**: For cluster access

## GCP APIs Required

```bash
gcloud services enable container.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable file.googleapis.com
gcloud services enable dns.googleapis.com
gcloud services enable logging.googleapis.com
gcloud services enable monitoring.googleapis.com
```

## Quick Start

### 1. Setup GCP Authentication

```bash
# Authenticate with GCP
gcloud auth login
gcloud auth application-default login

# Set your project
gcloud config set project YOUR_PROJECT_ID
```

### 2. Create State Bucket

```bash
# Create terraform state bucket
gsutil mb gs://bearsoft-terraform-state
gsutil versioning set on gs://bearsoft-terraform-state
```

### 3. Configure Variables

Update the following files with your specific values:

**environments/staging/global.tfvars:**
```hcl
project_id = "your-gcp-project-id"
terraform_state_bucket = "your-terraform-state-bucket"
```

**environments/staging/kafka.tfvars:**
```hcl
kafka_admin_password = "your-secure-admin-password"
schema_registry_password = "your-registry-password"
```

### 4. Deploy Staging Environment

```bash
# Set sensitive variables
export TF_VAR_kafka_admin_password="your-secure-password"
export TF_VAR_schema_registry_password="your-registry-password"

# Deploy all layers
./scripts/deploy-staging.sh
```

### 5. Access Your Infrastructure

```bash
# Configure kubectl
gcloud container clusters get-credentials bearsoft-staging-gke --region us-central1

# Access Kafka UI (if ingress is not configured)
kubectl port-forward -n kafka svc/kafka-ui 8080:8080

# Access Kafka UI at: http://localhost:8080
# Username: admin
# Password: [your configured password]
```

## Manual Deployment

If you prefer to deploy layers individually:

### Infrastructure Layer

```bash
cd infrastructure

# Initialize
terraform init -backend-config="../environments/staging/backend.hcl"
terraform workspace select staging || terraform workspace new staging

# Plan and apply
terraform plan -var-file="../environments/staging/global.tfvars" -var-file="../environments/staging/infrastructure.tfvars"
terraform apply
```

### Applications Layer

```bash
cd applications

# Initialize  
terraform init -backend-config="../environments/staging/backend.hcl"
terraform workspace select staging || terraform workspace new staging

# Plan and apply
terraform plan -var-file="../environments/staging/global.tfvars" -var-file="../environments/staging/applications.tfvars"
terraform apply
```

### Kafka Layer

```bash
cd kafka

# Set sensitive variables
export TF_VAR_kafka_admin_password="your-secure-password"
export TF_VAR_schema_registry_password="your-registry-password"

# Initialize
terraform init -backend-config="../environments/staging/backend.hcl"
terraform workspace select staging || terraform workspace new staging

# Plan and apply
terraform plan -var-file="../environments/staging/global.tfvars" -var-file="../environments/staging/kafka.tfvars"
terraform apply
```

## Production Deployment

For production deployment:

1. Update `environments/production/global.tfvars` with production values
2. Set production-specific secrets in `environments/production/kafka.tfvars"
3. Run `./scripts/deploy-production.sh`

## Environment Differences

### Staging
- Smaller, cost-optimized resources
- Preemptible worker nodes
- Basic HDD Filestore
- Micro database instances
- Minimal resource requests/limits

### Production
- Production-scale resources
- Non-preemptible nodes for stability
- SSD-based Filestore
- High-availability database
- Higher resource allocations
- Enhanced monitoring

## Variable Injection Pattern

The infrastructure follows a 2-tier variable injection pattern:

1. **global.tfvars**: Common variables across all layers
2. **[layer].tfvars**: Layer-specific overrides

This approach ensures:
- **DRY Principle**: No duplicate variable definitions
- **Environment Separation**: Clear staging vs production differences
- **Layer Isolation**: Each layer can have specific configurations
- **Secret Management**: Sensitive values via environment variables

## State Management

- **Backend**: Google Cloud Storage with versioning
- **Workspaces**: Separate terraform workspaces per environment
- **Remote State**: Layers reference each other via `terraform_remote_state`

## Scaling and Customization

### Horizontal Scaling
- Modify node pool `min_nodes`/`max_nodes` in global.tfvars
- Adjust Kafka `replicas` for brokers and connect workers
- Configure KEDA scaling parameters

### Vertical Scaling
- Update `machine_type` for node pools
- Modify resource `requests`/`limits` for Kafka components
- Adjust persistent volume sizes for Kafka storage

### Adding Components
- Add new applications in the applications layer
- Extend Kafka with custom connectors and plugins
- Integrate additional GCP services

## Monitoring and Observability

The infrastructure includes:

- **GKE Monitoring**: Built-in cluster and workload monitoring
- **Cloud Logging**: Centralized log collection via Fluentd
- **Kafka Metrics**: Broker, topic, and consumer group metrics
- **Resource Monitoring**: CPU, memory, and disk usage tracking

Access monitoring:
```bash
# View logs
gcloud logging read "resource.type=gke_container"

# Access Cloud Monitoring
# Visit: https://console.cloud.google.com/monitoring
```

## Security Considerations

- **Workload Identity**: Secure pod-to-GCP service authentication
- **Network Policies**: Kubernetes network isolation
- **Private Clusters**: Nodes in private subnets
- **IAM Principle of Least Privilege**: Minimal required permissions
- **Secret Management**: Kubernetes secrets for sensitive data

## Troubleshooting

### Common Issues

1. **Permission Errors**
   ```bash
   gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
     --member="user:your-email@domain.com" \
     --role="roles/editor"
   ```

2. **State Lock Issues**
   ```bash
   terraform force-unlock LOCK_ID
   ```

3. **Resource Quota Limits**
   ```bash
   gcloud compute project-info describe --project=YOUR_PROJECT_ID
   ```

4. **Kafka Connectivity Issues**
   - Check Kafka broker status and logs
   - Verify Zookeeper connectivity
   - Confirm service discovery and networking

### Useful Commands

```bash
# Check cluster status
kubectl get nodes
kubectl get pods --all-namespaces

# View Kafka logs
kubectl logs -n kafka statefulset/kafka-broker
kubectl logs -n kafka deployment/kafka-connect

# Check Kafka topics
kubectl exec -n kafka kafka-broker-0 -- kafka-topics --list --bootstrap-server localhost:9092

# Check ingress
kubectl get ingress -n kafka
```

## Cleanup

To destroy the infrastructure:

```bash
# Staging
./scripts/destroy-staging.sh

# Production  
./scripts/destroy-production.sh

# Manual cleanup if needed
gcloud container clusters delete bearsoft-staging-gke --region us-central1
gsutil rm -r gs://bearsoft-terraform-state
```

## Cost Optimization

### Staging Environment
- Uses `e2-small` instances with preemptible workers
- Minimal resource allocations
- Basic storage tiers
- Auto-scaling to zero when idle

### Production Environment  
- Balanced performance and cost
- Right-sized instances for workload
- SSD storage for performance
- Reserved instances for predictable workloads

Estimated monthly costs (USD):
- **Staging**: $50-100
- **Production**: $200-500

(Costs vary based on usage patterns and resource consumption)

## Support and Contributing

This infrastructure is designed as a demo/starting point. For production use:

1. Review security configurations
2. Implement backup strategies
3. Set up monitoring alerts
4. Configure disaster recovery
5. Establish change management processes

For questions or improvements, please review the code and adapt to your specific requirements.