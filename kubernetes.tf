module "control0" {
  source        = "./modules/instance-external"
  instance_name = "control0"
  instance_machine_type = "e2-standard-2"
  instance_zone = "${var.region}-a"
  instance_image = "ubuntu-1804-bionic-v20201201"
  subnet_name = "k8s-vpc"
  tags = ["k8scontrol"]
  startup_script = ""
  scopes = ["compute-rw","storage-rw","service-management","service-control","logging-write","monitoring"]
}

module "node0" {
  source        = "./modules/instance-external"
  instance_name = "node0"
  instance_machine_type = "e2-standard-2"
  instance_zone = "${var.region}-a"
  instance_image = "ubuntu-1804-bionic-v20201201"
  subnet_name = "k8s-vpc"
  tags = ["k8snode"]
  startup_script = ""
  scopes = ["compute-rw","storage-rw","service-management","service-control","logging-write","monitoring"]
}

module "node1" {
  source        = "./modules/instance-external"
  instance_name = "node1"
  instance_machine_type = "e2-standard-2"
  instance_zone = "${var.region}-a"
  instance_image = "ubuntu-1804-bionic-v20201201"
  subnet_name = "k8s-vpc"
  tags = ["k8snode"]
  startup_script = ""
  scopes = ["compute-rw","storage-rw","service-management","service-control","logging-write","monitoring"]
}

module "k8s-ip" {
  source        = "./modules/reserveip"
  name = "k8s-ip" 
}

module "k8s-vpc" {
  source        = "./modules/vpc"
  name = "k8s-vpc"
  iprange = "10.210.0.0/16"
  region = var.region
}

module "k8s-allow-ssh" {
  name        = "k8s-allow-ssh"
  source        = "./modules/firewall"
  source_ranges = var.source_ranges
  source_tags = []
  tcp_ports = ["22"]
  udp_ports = []
  target_tags = ["k8scontrol","k8snode"]
  expro = "icmp"
}

module "k8s-allow-external" {
  name        = "k8s-allow-external"
  source        = "./modules/firewall"
  source_ranges = ["0.0.0.0/0"]
  source_tags = []
  tcp_ports = [6443]
  udp_ports = []
  target_tags = ["k8scontrol"]
  expro = "icmp"
}

module "k8s-allow-internal" {
  name        = "k8s-allow-internal"
  source        = "./modules/firewall"
  source_ranges = ["10.210.0.0/16","10.200.0.0/16"]
  source_tags = []
  tcp_ports = []
  udp_ports = []
  target_tags = []
  expro = "ipip"
}

module "k8s-allow-healthcheck" {
  name        = "k8s-allow-healthcheck"
  source        = "./modules/firewall"
  source_ranges = ["209.85.152.0/22","209.85.204.0/22","35.191.0.0/16"]
  source_tags = []
  tcp_ports = []
  udp_ports = []
  target_tags = []
  expro = "icmp"
}

## Below resources are Load Balancer related

resource "google_compute_http_health_check" "k8s-healtcheck2" {
  name        = "k8s-healtcheck2"
  description = "K8s Health Check"
  request_path = "/health_check"
}

/*
resource "google_compute_target_pool" "default" {
  name = "k8s-target-pool2"

  instances = [
    "asia-east2-a/control0",
  ]

  health_checks = [
    google_compute_health_check.k8s-healtcheck2.name,
  ]
}
*/
