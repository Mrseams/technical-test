variable "project_id" {
  type    = string
  default = "numeric-dialect-460501-a1"
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "credentials" {
  type    = string
  default = "C:/Users/mr seams/AppData/Roaming/gcloud/application_default_credentials.json"
}

variable "db_name" {
  type    = string
  default = "sql-database"
}

variable "bucket_name" {
  type    = string
  default = "numeric-dialect-460501-a1-bucket"
}

variable "container_image" {
  type    = string
  default = "mrseams/php-fpm-server:v1.0.16"
}
