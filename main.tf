
module "backend" {
  source = "./modules/backend"
}

module "startup" {
  source  = "./modules/startup"
  project = var.project
  script  = var.script
}

module "secrets" {
  source       = "./modules/secrets"
  sql-user     = var.sql-user
  sql-password = var.sql-password
}

resource "random_id" "name_suffix" {
  byte_length = 4
}
