# This Terraform configuration sets up a GCP project with a Cloud SQL instance, a Cloud Storage bucket, and a Cloud Run service.
# It uses the Google provider to manage resources in GCP.
# The configuration includes:
# - A Google Cloud project
# - A Cloud SQL instance with PostgreSQL
# - A Cloud Storage bucket
# - A Cloud Run service


terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.8.0"
    }
  }


  backend "gcs" {
    bucket = "state-manager-bucket"
    prefix = "volume/terraform.tfstate"
  }

  required_version = ">= 1.3.0"
}




#provider
# The provider block configures the Google Cloud provider with the project ID and region.
# It uses the project ID and region variables defined above.
provider "google" {
  region      = var.region
  project     = var.project_id
  credentials = file(var.credentials)
}


# Enable the required APIs for the project
# The google_project_service resource enables the Cloud SQL and Cloud Run APIs for the project.
resource "google_project_service" "cloud_run_api" {
  service = "run.googleapis.com"
}

module "cloud-sql" {
  source     = "./modules/cloud-sql"
  region     = var.region
  db_name    = var.db_name
  project_id = var.project_id
}

module "cloud-storage" {
  source      = "./modules/cloud-storage"
  region      = var.region
  bucket_name = var.bucket_name
  project_id  = var.project_id
}


module "cloud-run" {
  source     = "./modules/cloud-run"
  region     = var.region
  image      = var.container_image
  project_id = var.project_id

  depends_on = [
    google_project_service.cloud_run_api
  ]
}




### setting cloud load balancer
# Resources: https://cloud.google.com/blog/topics/developers-practitioners/serverless-load-balancing-terraform-hard-way?hl=en

# Create a network endpoint group (NEG) for the Cloud Run service
# Create a backend service
# Create a URL map
# Create a target HTTP proxy
# Create a global forwarding rule


##!to do later

