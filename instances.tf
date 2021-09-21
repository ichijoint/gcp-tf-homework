# instance template
resource "google_compute_instance_template" "instance_template" {
  name         = "l7-ilb-mig-template-${random_id.name_suffix.hex}"
  provider     = google-beta
  machine_type = var.instance_type
  tags         = ["http-server", "ssh"]

  network_interface {
    network    = google_compute_network.ilb_network.id
    subnetwork = google_compute_subnetwork.ilb_subnet.id
    access_config {
      # add external ip to fetch packages
    }
  }
  disk {
    source_image = var.instance_os
    auto_delete  = true
    boot         = true
  }

  metadata_startup_script = module.startup.startup-script

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_health_check" "autohealing_mig_hc" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}

# MIG
resource "google_compute_region_instance_group_manager" "mig" {
  name     = "l7-ilb-mig1"
  provider = google-beta
  region   = var.region
  version {
    instance_template = google_compute_instance_template.instance_template.id
    name              = "primary"
  }
  base_instance_name = "vm"
  target_size        = var.mig_size
}

# SSH key
// resource "google_compute_project_metadata" "my_ssh_key" {
//   metadata = {
//     ssh-keys = <<EOF
//       dev:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILg6UtHDNyMNAh0GjaytsJdrUxjtLy3APXqZfNZhvCeT dev
//       foo:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILg6UtHDNyMNAh0GjaytsJdrUxjtLy3APXqZfNZhvCeT bar
//     EOF
//   }
// }



# resource "google_compute_instance_group_manager" "lamp_mig" {
#   name = "lamp-mig"

#   base_instance_name = "lamp"
#   zone               = "us-central1-a"

#   version {
#     name              = "lamp-mig"
#     instance_template = google_compute_instance_template.instance_template.id
#   }

#   # target_pools = [google_compute_target_pool.instance_template.id]
#   target_size = 2

#   # named_port {
#   #   name = "HTTP"
#   #   port = 80
#   # }

#   auto_healing_policies {
#     health_check      = google_compute_health_check.autohealing.id
#     initial_delay_sec = 300
#   }
# }

# resource "google_compute_autoscaler" "lamp_austoscaler" {
#   name   = "my-autoscaler"
#   zone   = "us-central1-a"
#   target = google_compute_instance_group_manager.lamp_mig.id

#   autoscaling_policy {
#     max_replicas    = 2
#     min_replicas    = 2
#     cooldown_period = 60

#     cpu_utilization {
#       target = 0.5
#     }
#   }
# }
