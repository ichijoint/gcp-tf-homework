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

# variable "billing_account" {
#   description = "The ID of the billing account to associate this project with"
#   default = "01E9B9-208B76-F0CB90"
# }

# variable "activate_apis" {
#   description = "Service APIs to enable."
#   type        = list(string)
#   default     = ["compute.googleapis.com"]
# }

# module "project-factory" {
#   source                  = "terraform-google-modules/project-factory/google"
#   version = "~> 10.1"
#   random_project_id       = true
#   name                    = "simple-sample-project"
#   org_id                  = "0"
#   billing_account         = var.billing_account
#   default_service_account = "deprivilege"

#   usage_bucket_name    = "pf-test-1-usage-report-bucket"
#   usage_bucket_prefix  = "pf/test/1/integration"

#   activate_apis = var.activate_apis
# }