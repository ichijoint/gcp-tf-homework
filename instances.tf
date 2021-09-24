# instance template
resource "google_compute_instance_template" "instance_template" {
  name_prefix  = "mig-template-"
  provider     = google-beta
  machine_type = var.instance_type
  tags         = ["http-server", "ssh"]

  network_interface {
    network    = module.vpc.network_name
    subnetwork = module.vpc.subnets["${var.region}/subnet1"].id
  }
  disk {
    source_image = var.instance_os
    auto_delete  = true
    boot         = true
  }
  metadata = {
    ssh-keys = "${file(var.ssh_public_key)}"
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

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing_mig_hc.id
    initial_delay_sec = 300
  }
}

resource "google_compute_region_autoscaler" "lamp_austoscaler" {
  name   = "my-autoscaler"
  region = var.region
  target = google_compute_region_instance_group_manager.mig.id

  autoscaling_policy {
    max_replicas    = 2
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
