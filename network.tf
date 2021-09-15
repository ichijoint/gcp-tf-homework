
resource "google_compute_network" "vpc_network" {
  name                    = "terraform-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "lamp_subnetwork" {
  name          = "terraform-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = var.region
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_firewall" "allow-ssh-from-user" {
  name     = "allow-user-ssh"
  network  = google_compute_network.vpc_network.name
  # provider = "google.shared-network"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["${var.user_ip}"]
  target_tags   = ["ssh"]
}
