resource "google_compute_instance" "lamp_instance" {
  name         = "terraform-instance"
  machine_type = var.instance_type

  boot_disk {
    initialize_params {
      image = var.instance_os
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.lamp_subnetwork.self_link
    # no access_config so instances have no public IP
  }
  tags = ["ssh"]
}