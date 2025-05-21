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

}
