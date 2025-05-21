variable "project_id" {
  type      = string
  sensitive = true
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "credentials" {
  type      = string
  sensitive = true
  default   = "C:/Users/mr seams/AppData/Roaming/gcloud/application_default_credentials.json"
}

variable "db_name" {
  type    = string
  default = "sql-database"
}

variable "bucket_name" {
  type      = string
  sensitive = true
}

variable "container_image" {
  type      = string
  sensitive = true
}
