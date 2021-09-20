output "bucket_name" {
    value = google_storage_bucket.script_bucket.name
}
output "startup-script-link" {
    value = google_storage_bucket_object.startup-lamp.media_link
}