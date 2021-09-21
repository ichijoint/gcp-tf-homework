output "bucket_name" {
  value = module.startup.bucket_name
}
output "global-address" {
  value = google_compute_global_address.loadbalancer_address.address
}
output "lb_ext_ip" {
  value = google_compute_forwarding_rule.default.ip_address
}
output "startup-script-content" {
  value = module.startup.startup-script
  sensitive = true
}