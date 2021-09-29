// # Read the secret data of sql-username
// data "google_secret_manager_secret_version" "sql-user" {
//   provider = google-beta
//   secret   = "sql-user"
//   version  = "1"
// }

// # Read the secret data of sql-password
// data "google_secret_manager_secret_version" "sql-password" {
//   provider = google-beta
//   secret   = "sql-password"
//   version  = "1"
// }

// # outputs

// output "sql-user" {
//   value = data.google_secret_manager_secret_version.sql-user.secret_data
// }

// # Read the secret data of local-admin-password
// output "sql-password" {
//   value = data.google_secret_manager_secret_version.sql-password.secret_data
// }