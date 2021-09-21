// # Create a secret for sql user
// resource "google_secret_manager_secret" "sql-user" {
//   provider = google-beta
//   secret_id   = "sql-user"
//   replication {
//     automatic = true
//   }
// }

// # Add the secret data for sql-user secret
// resource "google_secret_manager_secret_version" "sql-user" {
//   secret = google_secret_manager_secret.sql-user.id
//   secret_data = var.sql-user
// }

// # Create a secret for sql-password
// resource "google_secret_manager_secret" "sql-password" {
//   provider = google-beta
//   secret_id   = "sql-password"
//   replication {
//     automatic = true
//   }
// }

// # Add the secret data for sql-password secret
// resource "google_secret_manager_secret_version" "sql-password" {
//   secret = google_secret_manager_secret.sql-password.id
//   secret_data = var.sql-password
// }