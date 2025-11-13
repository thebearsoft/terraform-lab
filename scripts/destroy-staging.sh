#!/bin/bash

# Destroy staging environment
# This script destroys all layers in reverse order for staging

set -e

ENVIRONMENT="staging"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

echo "Destroying Bearsoft.ai infrastructure in $ENVIRONMENT environment..."

# Function to destroy a layer
destroy_layer() {
    local layer=$1
    echo "Destroying $layer layer..."
    
    cd "$PROJECT_ROOT/$layer"
    
    # Initialize terraform with backend configuration
    terraform init -backend-config="$PROJECT_ROOT/environments/$ENVIRONMENT/backend.hcl"
    
    # Select workspace
    terraform workspace select $ENVIRONMENT
    
    # Destroy with variable files
    terraform destroy \
        -var-file="$PROJECT_ROOT/environments/$ENVIRONMENT/global.tfvars" \
        -var-file="$PROJECT_ROOT/environments/$ENVIRONMENT/$layer.tfvars" \
        -auto-approve
    
    echo "$layer layer destroyed successfully"
    cd "$PROJECT_ROOT"
}

# Destroy layers in reverse order
destroy_layer "kafka"
destroy_layer "applications"
destroy_layer "infrastructure"

echo "All layers destroyed successfully in $ENVIRONMENT!"