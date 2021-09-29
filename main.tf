module "services" {
  project = var.project
  source  = "./modules/services"
}

module "startup" {
  source  = "./modules/startup"
  project = var.project
  script  = var.script
}

module "sql" {
  source       = "./modules/sql"
  sql-user     = var.sql-user
  sql-password = var.sql-password
  project      = var.project
  region       = var.region
}

resource "random_id" "name_suffix" {
  byte_length = 4
}
