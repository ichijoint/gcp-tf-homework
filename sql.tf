
resource "google_sql_database" "database" {
  name     = "my-database"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_database_instance" "instance" {
    project = var.project
  region = var.region
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = false
}

resource "google_sql_user" "users" {
  name     = "me"
  instance = google_sql_database_instance.instance.name
  host     = "alex-kay"
  password = "changeme"
}