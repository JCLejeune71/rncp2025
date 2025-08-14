resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = var.prometheus_namespace
  create_namespace = true
  version          = "45.7.1"
  values = [
    templatefile("${path.module}/template/values.yaml", {
      grafana_host                            = "grafana.${var.root_domain_name}"
      grafana_pwd                             = var.grafana_pwd
      grafana_ingress_enabled                 = var.grafana_ingress_enabled
      grafana_ingress_tls_acme_enabled        = var.grafana_ingress_tls_acme_enabled
      grafana_ingress_ssl_passthrough_enabled = var.grafana_ingress_ssl_passthrough_enabled
      grafana_ingress_class                   = var.grafana_ingress_class
      grafana_ingress_tls_secret_name         = var.grafana_ingress_tls_secret_name
      profile                                 = var.profile
    })
  ]
  timeout = 2000
  
  set {
    name  = "podSecurityPolicy.enabled"
    value = true
  }

  set {
    name  = "server.persistentVolume.enabled"
    value = false
  }

  set {
    name = "server\\.resources"
    value = yamlencode({
      limits = {
        cpu    = "200m"
        memory = "50Mi"
      }
      requests = {
        cpu    = "100m"
        memory = "30Mi"
      }
    })
  }
}
