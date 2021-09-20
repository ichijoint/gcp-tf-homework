
module "backend" {
  source = "./modules/backend"
}

module "startup" {
  source  = "./modules/startup"
  project = var.project
  script  = var.script
}

resource "random_id" "name_suffix" {
  byte_length = 4
}