resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.7.1"  # Check for latest version
  namespace  = "ingress-nginx"
  create_namespace = true

  values = [
    file("${path.module}/template/values.yaml"),
    file("${path.module}/template/frontend.yaml")
  ]

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }
  
  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
    value = "nlb"
  }
}