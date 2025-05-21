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
  required_version = ">= 1.3.0"
}


#variables
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "numeric-dialect-460501-a1"
}

variable "region" {
  description = "The GCP region"
  type        = string
  default     = "us-central1"
}

variable "credentials" {
  description = "The GCP credentials file path"
  type        = string
  default     = "C:/Users/mr seams/AppData/Roaming/gcloud/application_default_credentials.json"
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


# create a Cloud SQL instance
# The Cloud SQL instance is created with PostgreSQL version 14 and a db-f1-micro tier.  
# The instance is created in the region specified by the region variable.

resource "google_sql_database_instance" "default" {
  name             = "sql-instance"
  database_version = "POSTGRES_14"
  region           = var.region

  settings {
    tier = "db-f1-micro"
  }
}

resource "google_sql_database" "default" {
  name     = "sql-database"
  instance = google_sql_database_instance.default.name
}



## Create a Cloud Storage bucket
# The Cloud Storage bucket is created with a name based on the project ID and the region specified by the region variable.
# The bucket is set to force destroy, meaning it can be deleted even if it contains objects.
resource "google_storage_bucket" "default" {
  name          = "${var.project_id}-bucket"
  location      = var.region
  force_destroy = true
}



## Create a Cloud Run service
# The Cloud Run service is created with a name based on the project ID and the region specified by the region variable.
# The service uses a container image from Google Container Registry (GCR) and is set to receive 100% of the traffic.
# The latest revision of the service is used.

resource "google_cloud_run_service" "default" {
  name     = "cloudrun-service"
  location = var.region

  template {
    spec {
      containers {
        image = "mrseams/php-fpm-server:v1.0.16"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }


  depends_on = [google_project_service.cloud_run_api]
}


### setting cloud load balancer
# Resources: https://cloud.google.com/blog/topics/developers-practitioners/serverless-load-balancing-terraform-hard-way?hl=en

# Create a network endpoint group (NEG) for the Cloud Run service
# Create a backend service
# Create a URL map
# Create a target HTTP proxy
# Create a global forwarding rule


##!to do later

