
variable "project" {
    type = string
}
output "bucket_name" {
    value = google_storage_bucket.backend_bucket.name
}