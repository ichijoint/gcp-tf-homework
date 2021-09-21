# Internal HTTP load balancer with a managed instance group backend

# VPC
resource "google_compute_network" "ilb_network" {
  name                    = "l7-ilb-network"
  provider                = google-beta
  auto_create_subnetworks = false
}

# proxy-only subnet
resource "google_compute_subnetwork" "proxy_subnet" {
  name          = "l7-ilb-proxy-subnet"
  provider      = google-beta
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
  role          = "ACTIVE"
  network       = google_compute_network.ilb_network.id
}

# backed subnet
resource "google_compute_subnetwork" "ilb_subnet" {
  name          = "l7-ilb-subnet"
  provider      = google-beta
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.ilb_network.id
}

# forwarding rule
resource "google_compute_forwarding_rule" "google_compute_forwarding_rule" {
  name                  = "l7-ilb-forwarding-rule"
  provider              = google-beta
  region                = var.region
  depends_on            = [google_compute_subnetwork.proxy_subnet]
  ip_protocol           = "TCP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  port_range            = "80"
  target                = google_compute_region_target_http_proxy.default.id
  network               = google_compute_network.ilb_network.id
  subnetwork            = google_compute_subnetwork.ilb_subnet.id
  network_tier          = "PREMIUM"
}

# http proxy
resource "google_compute_region_target_http_proxy" "default" {
  name     = "l7-ilb-target-http-proxy"
  provider = google-beta
  region   = var.region
  url_map  = google_compute_region_url_map.default.id
}

# url map
resource "google_compute_region_url_map" "default" {
  name            = "l7-ilb-regional-url-map"
  provider        = google-beta
  region          = var.region
  default_service = google_compute_region_backend_service.default.id
}

# backend service
resource "google_compute_region_backend_service" "default" {
  name                  = "l7-ilb-backend-subnet"
  provider              = google-beta
  region                = var.region
  protocol              = "HTTP"
  load_balancing_scheme = "INTERNAL_MANAGED"
  timeout_sec           = 10
  health_checks         = [google_compute_region_health_check.default.id]
  backend {
    group           = google_compute_region_instance_group_manager.mig.instance_group
    balancing_mode  = "UTILIZATION"
    capacity_scaler = 1.0
  }
}

# health check
resource "google_compute_region_health_check" "default" {
  name     = "l7-ilb-hc"
  provider = google-beta
  region   = var.region
  http_health_check {
    port_specification = "USE_SERVING_PORT"
  }
}

# allow all access from IAP and health check ranges
resource "google_compute_firewall" "fw-iap" {
  name          = "l7-ilb-fw-allow-iap-hc"
  provider      = google-beta
  direction     = "INGRESS"
  network       = google_compute_network.ilb_network.id
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16", "35.235.240.0/20"]
  allow {
    protocol = "tcp"
  }
}

resource "google_compute_firewall" "allow-ssh-from-user" {
  name    = "allow-user-ssh"
  network = google_compute_network.ilb_network.name
  # provider = "google.shared-network"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

# allow http from proxy subnet to backends
resource "google_compute_firewall" "fw-ilb-to-backends" {
  name          = "l7-ilb-fw-allow-ilb-to-backends"
  provider      = google-beta
  direction     = "INGRESS"
  network       = google_compute_network.ilb_network.id
  source_ranges = ["10.0.0.0/24"]
  target_tags   = ["http-server"]
  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }
}

resource "google_compute_forwarding_rule" "default" {
  provider        = google-beta
  name            = "website-forwarding-rule"
  region          = var.region
  port_range      = 80
  backend_service = google_compute_region_backend_service.backend.id
}
resource "google_compute_region_backend_service" "backend" {
  provider              = google-beta
  name                  = "website-backend"
  region                = var.region
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_region_health_check.hc.id]
}
resource "google_compute_region_health_check" "hc" {
  provider           = google-beta
  name               = "check-website-backend"
  check_interval_sec = 1
  timeout_sec        = 1
  region             = var.region

  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_global_address" "loadbalancer_address" {
  name = "global-lb-ip"
}

