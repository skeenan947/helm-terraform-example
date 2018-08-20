# Static IP for Traefik
resource "google_compute_address" "traefik" {
  name = "traefik"
}

resource "helm_release" "traefik" {
  name = "traefik"
  chart = "stable/traefik"
  values = [
    "${file("helm/traefik.yaml")}",
    <<EOF
loadBalancerIP: ${google_compute_address.traefik.address}
service:
  annotations:
    external-dns.alpha.kubernetes.io/target: ${google_compute_address.traefik.address}
dashboard:
  domain: traefik.ops.fastcast.net
  enabled: true
  ingress:
    annotations:
      external-dns.alpha.kubernetes.io/target: ${google_compute_address.traefik.address}
      kubernetes.io/ingress.class: traefik
EOF
  ]
}

resource "helm_release" "external-dns" {
  name = "external-dns"
  chart = "stable/external-dns"
  values = [
    "${file("helm/external-dns.yaml")}"
  ]
}

resource "helm_release" "chartmuseum" {
  name = "charts"
  chart = "stable/chartmuseum"
  values = [
    "${file("helm/chartmuseum.yaml")}",
    <<EOF
ingress:
  annotations:
    kubernetes.io/ingress.class: traefik
    external-dns.alpha.kubernetes.io/target: ${google_compute_address.traefik.address}
EOF
  ]
}

resource "helm_release" "video-api" {
  name = "video-api"
  chart = "skvid/video-api"
  values = [
    "${file("helm/video-api.yaml")}",
    <<EOF
ingress:
  annotations:
    kubernetes.io/ingress.class: traefik
    external-dns.alpha.kubernetes.io/target: ${google_compute_address.traefik.address}
EOF
  ]
}

