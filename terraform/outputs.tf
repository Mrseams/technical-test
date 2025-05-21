output "cloud_sql_instance_name" {
  description = "The name of the Cloud SQL instance"
  value       = module.cloud-sql.instance_name
}

output "cloud_sql_database_name" {
  description = "The name of the Cloud SQL database"
  value       = module.cloud-sql.database_name
}

# output "storage_bucket_name" {
#   description = "The name of the Cloud Storage bucket"
#   value       = module.cloud-storage.bucket_name
# }


output "cloud_run_service_url" {
  description = "The URL of the Cloud Run service"
  value       = module.cloud-run.url
}
