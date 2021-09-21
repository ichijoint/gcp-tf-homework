
// resource "google_project_service" "cloudresourcemanager" {
//   project = var.project
//   service = "cloudresourcemanager.googleapis.com"
//   disable_on_destroy = false
// }

// resource "google_project_service" "secretmanager" {
//   project = var.project
//   service = "secretmanager.googleapis.com"
//   disable_on_destroy = false
//   depends_on = [ google_project_service.cloudresourcemanager ]
// }

module "backend" {
  source = "./modules/backend"
}

module "startup" {
  source  = "./modules/startup"
  project = var.project
  script  = var.script
}

// module "secrets" {
//   source       = "./modules/secrets"
//   sql-user     = var.sql-user
//   sql-password = var.sql-password
//   depends_on = [ google_project_service.secretmanager ]
// }

resource "random_id" "name_suffix" {
  byte_length = 4
}
