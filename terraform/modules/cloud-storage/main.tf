## Create a Cloud Storage bucket
# The Cloud Storage bucket is created with a name based on the project ID and the region specified by the region variable.
# The bucket is set to force destroy, meaning it can be deleted even if it contains objects.
resource "google_storage_bucket" "default" {
  name          = "${var.project_id}-bucket"
  location      = var.region
  force_destroy = true
}
