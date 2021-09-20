# output "instance_inner_ip" {
#   value = google_compute_instance.lamp_instance.network_interface.0.network_ip
# }
output "bucket_name" {
  value = module.backend.bucket_name
}