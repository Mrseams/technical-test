output "instance_name" {
  value = google_sql_database_instance.default.name
}

output "database_name" {
  value = google_sql_database.default.name
}
