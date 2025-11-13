# Bearsoft.ai GCP Infrastructure

This Terraform infrastructure demonstrates a simplified 3-layer architecture for deploying applications on Google Cloud Platform:

1. **Infrastructure Layer** - Core GCP resources (GKE, VPC, IAM)
2. **Applications Layer** - Kubernetes applications and add-ons  
3. **Kafka Layer** - Apache Kafka cluster deployment on GKE

## Architecture Overview

```
infrastructure → applications → kafka
```

## Environment Structure

- **staging/** - Development environment configurations
- **production/** - Production environment configurations

## Quick Start

1. Configure GCP credentials
2. Initialize each layer with appropriate environment
3. Deploy in order: infrastructure → applications → kafka

## Prerequisites

- Terraform >= 1.0
- GCP project with required APIs enabled
- kubectl configured for GKE access