resource "google_compute_firewall" "default" {
  name    = var.name
  network = "k8s-network"
  source_ranges = var.source_ranges
  source_tags = var.source_tags
  target_tags = var.target_tags
  allow {
    protocol = "tcp"
    ports    = var.tcp_ports
  }
  allow {
    protocol = "udp"
    ports    = var.udp_ports
  }
  allow {
    protocol = var.expro
  }
}
