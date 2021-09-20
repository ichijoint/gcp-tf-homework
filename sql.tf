resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database" "database" {
  name     = "my-database"
  instance = google_sql_database_instance.instance.name
}

resource "google_sql_database_instance" "instance" {
  name   = "my-database-instance"
  region = var.region
  settings {
    tier = "db-f1-micro"
  }
  deletion_protection = true
}

resource "google_sql_user" "users" {
  name     = "me"
  instance = google_sql_database_instance.instance.name
  host     = var.user_ip
  password = "changeme"
}