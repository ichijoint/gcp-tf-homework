resource "google_compute_instance_group" "webservers" {
  name        = "terraform-webservers"
  description = "Terraform test instance group"

  instances = [
    google_compute_instance_from_template.test.id,
    google_compute_instance_from_template.test2.id,
  ]

  named_port {
    name = "http"
    port = "8080"
  }

  named_port {
    name = "https"
    port = "8443"
  }

  zone = var.zone
}

resource "google_compute_instance_template" "tpl" {
  name         = "template"
  machine_type = var.instance_type

  disk {
    source_image = var.instance_os
    auto_delete  = true
    disk_size_gb = 20
    boot         = true
  }

  network_interface {
    // network = "default"
    subnetwork = google_compute_subnetwork.ilb_subnet.id
  }

  metadata = {
    foo = "bar"
  }

  can_ip_forward = true
}

resource "google_compute_instance_from_template" "test" {
  name = "instance-from-template"
  zone = var.zone

  source_instance_template = google_compute_instance_template.tpl.id

  // Override fields from instance template
  //   can_ip_forward = false
  labels = {
    my_key = "my_value"
  }
}

resource "google_compute_instance_from_template" "test2" {
  name = "instance-from-template2"
  zone = var.zone

  source_instance_template = google_compute_instance_template.tpl.id

  // Override fields from instance template
  //   can_ip_forward = false
  labels = {
    my_key = "my_value"
  }
}