
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id   = var.project
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "${var.network_name}-subnet"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
    },
    {
      subnet_name   = "${var.network_name}-subnet-01"
      subnet_ip     = "10.10.20.0/24"
      subnet_region = var.region
      purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
      role          = "ACTIVE"
    }
  ]

  routes = [
    {
      name              = "${var.network_name}-egress-inet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
    {
      name              = "${var.network_name}-ilb"
      description       = "route through ilb"
      destination_range = "10.10.20.0/24"
      next_hop_ilb      = google_compute_forwarding_rule.this.self_link
    },
  ]
}

resource "google_compute_health_check" "tcp_health_check" {
  project            = var.project
  name               = "${var.network_name}-hc"
  check_interval_sec = 1
  timeout_sec        = 1
  tcp_health_check {
    port = "80"
  }
}

resource "google_compute_forwarding_rule" "this" {
  project               = var.project
  name                  = "${var.network_name}-fw-role"
  network               = module.vpc.network_name
  subnetwork            = module.vpc.subnets["${var.region}/${var.network_name}-subnet-01"].id
  backend_service       = google_compute_region_backend_service.backend_service.self_link
  region                = var.region
  load_balancing_scheme = "INTERNAL"
  all_ports             = true
  provider = google-beta
}

resource "google_compute_region_backend_service" "backend_service" {
  project       = var.project
  name          = "${var.network_name}-backend"
  region        = var.region
  health_checks = [google_compute_health_check.tcp_health_check.self_link]
}

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 0.4"
  project = var.project
  name    = "my-cloud-router"
  network = module.vpc.network_name
  region  = var.region
  nats = [{
    name = "my-nat-gateway"
  }]
}