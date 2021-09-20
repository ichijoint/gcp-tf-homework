# resource "google_compute_instance" "lamp_instance" {
#   name         = "terraform-instance"
#   machine_type = var.instance_type

#   boot_disk {
#     initialize_params {
#       image = var.instance_os
#     }
#   }

#   network_interface {
#     subnetwork = google_compute_subnetwork.lamp_subnetwork.self_link
#     # no access_config so instances have no public IP
#   }
#   tags = ["ssh"]
# }

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10 # 50 seconds

  http_health_check {
    request_path = "/"
    port         = "80"
  }
}

resource "google_compute_instance_group_manager" "lamp_mig" {
  name = "lamp-mig"

  base_instance_name = "lamp"
  zone               = "us-central1-a"

  version {
    name              = "lamp-mig"
    instance_template = google_compute_instance_template.instance_template.id
  }

  # target_pools = [google_compute_target_pool.instance_template.id]
  target_size = 2

  # named_port {
  #   name = "HTTP"
  #   port = 80
  # }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}

resource "google_compute_autoscaler" "lamp_austoscaler" {
  name   = "my-autoscaler"
  zone   = "us-central1-a"
  target = google_compute_instance_group_manager.lamp_mig.id

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

resource "google_compute_instance_template" "instance_template" {
  name_prefix = "tf-template-"
  region      = "us-central1"

  machine_type = var.instance_type

  disk {
    source_image = var.instance_os

  }

  network_interface {
    network = "default"
    # subnetwork = google_compute_subnetwork.lamp_subnetwork.self_link
    # no access_config so instances have no public IP
  }
  tags = ["ssh"]

  lifecycle {
    create_before_destroy = true
  }
}