



# resource "google_project_service" "enable_cloudbilling" {
#   project = var.project
#   service = "cloudbilling.googleapis.com"
# }
# resource "google_project_service" "enable_cloudresourcemanager" {
#   project = var.project
#   service = "cloudresourcemanager.googleapis.com"
# }


# data "google_billing_account" "acct" {
#   display_name = "My Billing Account"
#   open         = true
# }

# module "project-factory" {
#   source  = "terraform-google-modules/project-factory/google"
#   version = "~> 10.1"

#   name                 = "pf-test-1"
#   random_project_id    = true
#   org_id               = "0"
#   usage_bucket_name    = "pf-test-1-usage-report-bucket"
#   usage_bucket_prefix  = "pf/test/1/integration"
#   billing_account      = "01E9B9-208B76-F0CB90"
#   # svpc_host_project_id = "shared_vpc_host_name"

#   activate_apis = ["cloudbilling.googleapis.com"]

#   # shared_vpc_subnets = [
#   #   "projects/base-project-196723/regions/us-east1/subnetworks/default",
#   #   "projects/base-project-196723/regions/us-central1/subnetworks/default",
#   #   "projects/base-project-196723/regions/us-central1/subnetworks/subnet-1",
#   # ]
# }




module "backend" {
  source = "./modules/backend"
}

module "startup" {
  source  = "./modules/startup"
  project = var.project
  script  = var.script
}