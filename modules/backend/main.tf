resource "google_storage_bucket" "backend_bucket" {
    name = "gcp-tf-homework-state"
    versioning {
        enabled = true
    }
    provisioner "local-exec" {
      command = "echo BUCKET CREATED"
    }
}