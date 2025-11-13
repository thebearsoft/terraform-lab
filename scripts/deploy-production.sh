#!/bin/bash

# Deploy production environment
# This script deploys all layers in the correct order for production

set -e

ENVIRONMENT="production"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Deploying Bearsoft.ai infrastructure to $ENVIRONMENT environment..."

# Function to deploy a layer
deploy_layer() {
    local layer=$1
    echo "Deploying $layer layer..."
    
    cd "$PROJECT_ROOT/$layer"
    
    # Initialize terraform with backend configuration
    terraform init -backend-config="$PROJECT_ROOT/environments/$ENVIRONMENT/backend.hcl"
    
    # Select or create workspace
    terraform workspace select $ENVIRONMENT || terraform workspace new $ENVIRONMENT
    
    # Plan with variable files
    terraform plan \
        -var-file="$PROJECT_ROOT/environments/$ENVIRONMENT/global.tfvars" \
        -var-file="$PROJECT_ROOT/environments/$ENVIRONMENT/$layer.tfvars" \
        -out="$layer.tfplan"
    
    # Apply
    terraform apply "$layer.tfplan"
    
    echo "$layer layer deployed successfully"
    cd "$PROJECT_ROOT"
}

# Deploy layers in order
deploy_layer "infrastructure"
deploy_layer "applications"
deploy_layer "kafka"

echo "All layers deployed successfully to $ENVIRONMENT!"
echo ""
echo "Next steps:"
echo "1. Configure kubectl: gcloud container clusters get-credentials bearsoft-production-gke --region us-central1"
echo "2. Access Kafka UI through the ingress or port-forward: kubectl port-forward -n kafka svc/kafka-ui 8080:8080"
echo "3. Create Kafka topics and configure your applications"