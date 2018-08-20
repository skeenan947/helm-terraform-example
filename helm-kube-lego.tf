variable "acme_email" {
  default = "support@fastcast.net"
}

variable "acme_url" {
  default = "https://acme-v01.api.letsencrypt.org/directory"
}

resource "helm_release" "kube-lego" {
  name  = "kube-lego"
  chart = "stable/kube-lego"

  values = [<<EOF
rbac:
  create: false
config:
  LEGO_EMAIL: ${var.acme_email}
  LEGO_URL: ${var.acme_url}
  LEGO_SECRET_NAME: lego-acme
EOF
  ]
}