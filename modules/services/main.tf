 resource "google_project_service" "compute" {
     project = var.project
   service = "compute.googleapis.com"
   disable_dependent_services = false
   disable_on_destroy = false
 }

 resource "google_project_service" "cloudresourcemanager" {
     project = var.project
   service = "cloudresourcemanager.googleapis.com"
   disable_dependent_services = false
   disable_on_destroy = false
   depends_on = [
     google_project_service.compute
   ]
 }

resource "google_project_service" "sqladmin" {
     project = var.project
   service = "sqladmin.googleapis.com"
   disable_dependent_services = false
   disable_on_destroy = false
   depends_on = [ google_project_service.cloudresourcemanager ]
 }

 resource "google_project_service" "secretmanager" {
     project = var.project
   service = "secretmanager.googleapis.com"
   disable_dependent_services = false
   disable_on_destroy = false
   depends_on = [ google_project_service.cloudresourcemanager ]
 }
