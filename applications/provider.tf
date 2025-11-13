data "terraform_remote_state" "infrastructure" {
  backend = "gcs"
  config = {
    bucket = var.terraform_state_bucket
    prefix = "infrastructure"
  }
  workspace = terraform.workspace
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host  = "https://${data.terraform_remote_state.infrastructure.outputs.cluster_endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(
    data.terraform_remote_state.infrastructure.outputs.cluster_ca_certificate
  )
}

provider "helm" {
  kubernetes {
    host  = "https://${data.terraform_remote_state.infrastructure.outputs.cluster_endpoint}"
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(
      data.terraform_remote_state.infrastructure.outputs.cluster_ca_certificate
    )
  }
}