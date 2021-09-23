output "bucket_name" {
    value = google_storage_bucket.script_bucket.name
}
output "startup-script" {
    value = google_storage_bucket_object.startup-lamp.media_link
}