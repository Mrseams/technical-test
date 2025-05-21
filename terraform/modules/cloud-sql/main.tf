# create a Cloud SQL instance
# The Cloud SQL instance is created with PostgreSQL version 14 and a db-f1-micro tier.  
# The instance is created in the region specified by the region variable.

resource "google_sql_database_instance" "default" {
  name                = "sql-instance"
  database_version    = "POSTGRES_14"
  region              = var.region
  deletion_protection = false


  settings {
    tier = "db-f1-micro"
  }


}

resource "google_sql_database" "default" {
  name     = "sql-database"
  instance = google_sql_database_instance.default.name
}
