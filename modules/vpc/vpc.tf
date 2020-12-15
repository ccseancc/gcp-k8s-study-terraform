resource "google_compute_subnetwork" "main" {
  name          = var.name
  ip_cidr_range = var.iprange
  region        = var.region
  network       = google_compute_network.custom-k8s.id
}

resource "google_compute_network" "custom-k8s" {
  name                    = "k8s-network"
  auto_create_subnetworks = false
}
