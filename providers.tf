terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.84.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }

  backend "gcs" {
    bucket = "homework-2-321920-state"
    prefix = "terraform/state"
  }
}

provider "google" {
  #   credentials = file(var.credentials_file)
  project = var.project
  region  = var.region
  zone    = var.zone
}
provider "google-beta" {
  #   credentials = file(var.credentials_file)
  project = var.project
  region  = var.region
  zone    = var.zone
}
provider "random" {
}
provider "null" {
}