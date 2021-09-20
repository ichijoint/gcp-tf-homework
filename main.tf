terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.84.0"
    }
  }

  backend "gcs" {
    bucket = "homework-2-321920-state"
    prefix = "terraform/state"
  }
}


provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
  zone        = var.zone
}

output "bucket_name" {
  value = module.backend.bucket_name
}

resource "google_project_service" "enable_cloudbilling" {
  project = var.project
  service = "cloudbilling.googleapis.com"
}
resource "google_project_service" "enable_cloudresourcemanager" {
  project = var.project
  service = "cloudresourcemanager.googleapis.com"
}


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