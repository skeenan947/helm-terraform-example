variable "helm_version" {
  default = "v2.9.1"
}

provider "helm" {
  tiller_image = "gcr.io/kubernetes-helm/tiller:${var.helm_version}"
  
  kubernetes {
    host     = "${google_container_cluster.primary.endpoint}"
    token                  = "${data.google_client_config.current.access_token}"
    client_certificate     = "${base64decode(google_container_cluster.primary.master_auth.0.client_certificate)}"
    client_key             = "${base64decode(google_container_cluster.primary.master_auth.0.client_key)}"
    cluster_ca_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}"
  }
  # No RBAC til helm is fixed
  #service_account = "tiller"
}

resource "helm_repository" "skvid" {
    name = "skvid"
    url  = "http://charts.video.skeenan.net"
}