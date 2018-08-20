resource "google_container_cluster" "primary" {
  name               = "${var.cluster_name}"
  zone               = "us-west1-b"
  initial_node_count = 3
  min_master_version = "1.10.6-gke.1"
  node_version = "1.10.6-gke.1"
  network = "${google_compute_network.gke.self_link}"
  subnetwork = "${google_compute_subnetwork.gke_subnet.self_link}"

  ip_allocation_policy {
    cluster_secondary_range_name = "gke-pods"
    services_secondary_range_name = "gke-services"
  }
  node_config {
    machine_type = "g1-small"
    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/ndev.clouddns.readwrite"
    ]

    labels {
      build = "${var.cluster_name}"
    }
  }
  // Use legacy ABAC until these issues are resolved: 
  //   https://github.com/mcuadros/terraform-provider-helm/issues/56
  //   https://github.com/terraform-providers/terraform-provider-kubernetes/pull/73
  enable_legacy_abac = true
  
  // Log in and apply RBAC config
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${var.cluster_name} --zone ${google_container_cluster.primary.zone}"
  }
  provisioner "local-exec" {
    command = "kubectl apply -f k8scfg"
  }
  // Wait for the GCE LB controller to cleanup the resources.
  provisioner "local-exec" {
    when    = "destroy"
    command = "sleep 90"
  }
}