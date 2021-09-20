
resource "google_storage_bucket" "script_bucket" {
    name = "${var.project}_${var.script}"
    force_destroy = true
}

resource "google_storage_bucket_object" "startup-lamp" {
  name   = var.script
  source = "./modules/backend/${var.script}"
  bucket = google_storage_bucket.script_bucket.name
}