module "services" {
  project = var.project
  source  = "./modules/services"
}

module "backend" {
  source = "./modules/backend"
  depends_on = [
    module.services
  ]
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
