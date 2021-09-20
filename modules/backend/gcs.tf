resource "google_storage_bucket" "backend_bucket" {
    name = "${var.project}_storage"
    versioning {
        enabled = true
    }
}