module "cert_manager" {
  source        = "terraform-iaac/cert-manager/kubernetes"

  cluster_issuer_email                   = "F4st0ps@gmail.com"
  cluster_issuer_name                    = "letsencrypt-${var.profile}"
  cluster_issuer_private_key_secret_name = "letsencrypt-${var.profile}"
  cluster_issuer_server                  = "https://acme-v02.api.letsencrypt.org/directory"
  namespace_name = var.cert_manager_namespace
  create_namespace = true

  solvers = [
    {
      http01 = {
        ingress = {
          class = "nginx"
        }
      }
    }
  ]
}

