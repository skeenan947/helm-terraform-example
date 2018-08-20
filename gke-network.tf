variable "gke_subnet" {
  type = "string"
  default = "10.180.0.0/16"
}
variable "gke_services_subnet" {
  type = "string"
  default = "10.181.0.0/20"
}
variable "gke_pods_subnet" {
  type = "string"
  default = "10.182.0.0/16"
}
resource "google_compute_network" "gke" {
  name                    = "${var.cluster_name}"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "gke_subnet" {
  name          = "${var.cluster_name}-alias"
  ip_cidr_range = "${var.gke_subnet}"
  region        = "us-west1"
  network       = "${google_compute_network.gke.self_link}"
  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = "${var.gke_services_subnet}"
  }
  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = "${var.gke_pods_subnet}"
  }
}
