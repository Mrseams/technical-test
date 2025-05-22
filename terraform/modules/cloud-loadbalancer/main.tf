
# This module creates a Google Cloud Load Balancer for a Cloud Run service.
# It sets up a global address, a managed SSL certificate, and a backend service for the Cloud Run service.
# It also creates a URL map, a target HTTPS proxy, and a global forwarding rule for the load balancer.
# The module uses the google-beta provider to access beta features of Google Cloud.
#link: https://cloud.google.com/blog/topics/developers-practitioners/serverless-load-balancing-terraform-hard-way?hl=en



#google_compute_global_address
# This resource creates a global address for the load balancer.
# It assigns a static IP address to the load balancer, which can be used for routing traffic.
# The address is created in the global scope, meaning it can be used across multiple regions.

resource "google_compute_global_address" "default" {
  name = "${var.name}-address"
}


#google_compute_managed_ssl_certificate
# This resource creates a managed SSL certificate for the load balancer.
# The certificate is managed by Google Cloud, meaning it will automatically renew and update the certificate as needed.
# The certificate is associated with the load balancer and is used to secure traffic to the load balancer.
# The managed certificate is created with the specified domain name, which is used to validate the certificate.
resource "google_compute_managed_ssl_certificate" "default" {
  provider = google-beta

  name = "${var.name}-cert"
  managed {
    domains = ["${var.domain}"]
  }
}



#google_compute_region_network_endpoint_group
# This resource creates a network endpoint group (NEG) for the Cloud Run service.
resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  provider              = google-beta
  name                  = "${var.name}-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.cloud_run_name
  }
}


#google_compute_backend_service
# This resource creates a backend service for the load balancer.
# The backend service is associated with the network endpoint group (NEG) created above.
# The backend service defines the protocol, port, and timeout settings for the load balancer.
# The backend service is used to route traffic to the Cloud Run service.
resource "google_compute_backend_service" "default" {
  name = "${var.name}-backend"

  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_neg.id
  }
}



#google_compute_url_map
# This resource creates a URL map for the load balancer.
# The URL map defines how traffic is routed to the backend service based on the request URL.
# The URL map is used to route traffic to the appropriate backend service based on the request path.
resource "google_compute_url_map" "default" {
  name = "${var.name}-urlmap"

  default_service = google_compute_backend_service.default.id
}


#google_compute_target_https_proxy
# This resource creates a target HTTPS proxy for the load balancer.
# The target HTTPS proxy is used to route traffic to the backend service based on the URL map.
resource "google_compute_target_https_proxy" "default" {
  name = "${var.name}-https-proxy"

  url_map = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.default.id
  ]
}


#google_compute_global_forwarding_rule
# This resource creates a global forwarding rule for the load balancer.
# The global forwarding rule is used to route traffic to the target HTTPS proxy based on the IP address and port.
resource "google_compute_global_forwarding_rule" "default" {
  name = "${var.name}-lb"

  target     = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_address = google_compute_global_address.default.address
}


resource "google_compute_url_map" "https_redirect-url-map" {
  name = "${var.name}-https-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

resource "google_compute_target_http_proxy" "https_redirect-proxy" {
  name    = "${var.name}-http-proxy"
  url_map = google_compute_url_map.https_redirect.id
}



resource "google_compute_url_map" "https_redirect" {
  name = "${var.name}-https-redirect"

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

