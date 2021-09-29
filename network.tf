
module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id   = var.project
  network_name = var.network_name
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name   = "subnet1"
      subnet_ip     = "10.10.10.0/24"
      subnet_region = var.region
      purpose       = "PRIVATE"
    }
    # ,
    # {
    #   subnet_name   = "subnet-ilb"
    #   subnet_ip     = "10.10.20.0/24"
    #   subnet_region = var.region
    #   purpose       = "INTERNAL_HTTPS_LOAD_BALANCER"
    #   role          = "ACTIVE"
    # }
  ]

  routes = [
    {
      name              = "route-egress-inet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
    {
      name              = "route-ilb"
      description       = "route through lb"
      destination_range = "10.0.0.0/20"
      next_hop_ilb      = google_compute_global_forwarding_rule.global_forwarding_rule.self_link
    },
  ]
}


resource "google_compute_health_check" "healthcheck" {
  name               = "lamp-healthcheck"
  timeout_sec        = 1
  check_interval_sec = 1

  http_health_check {
    port = 80
  }
}

resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name       = "lamp-global-forwarding-rule"
  project    = var.project
  target     = google_compute_target_http_proxy.target_http_proxy.self_link
  port_range = "80"
}
# used by one or more global forwarding rule to route incoming HTTP requests to a URL map
resource "google_compute_target_http_proxy" "target_http_proxy" {
  name    = "lamp-proxy"
  project = var.project
  url_map = google_compute_url_map.url_map.self_link
}
# defines a group of virtual machines that will serve traffic for load balancing
resource "google_compute_backend_service" "backend_service" {
  name                  = "lamp-backend-service"
  project               = var.project
  port_name             = "http"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = ["${google_compute_health_check.healthcheck.self_link}"]
  backend {
    group                 = google_compute_instance_group_manager.mig.instance_group
    balancing_mode        = "RATE"
    max_rate_per_instance = 100
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "lamp-load-balancer"
  project         = var.project
  default_service = google_compute_backend_service.backend_service.self_link
}
# resource "google_compute_forwarding_rule" "internal_load_balancer" {
#   project               = var.project
#   name                  = "ilb-fw-role"
#   network               = module.vpc.network_name
#   subnetwork            = module.vpc.subnets["${var.region}/subnet1"].id
#   backend_service       = google_compute_region_backend_service.backend_service.self_link
#   region                = var.region
#   load_balancing_scheme = "INTERNAL"
#   all_ports             = true
#   allow_global_access   = true
#   provider              = google-beta
# }

# resource "google_compute_region_backend_service" "backend_service" {
#   project                         = var.project
#   name                            = "ilb-backend"
#   region                          = var.region
#   health_checks                   = [google_compute_health_check.tcp_health_check.self_link]
#   session_affinity                = "CLIENT_IP"
#   connection_draining_timeout_sec = 10
# }

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