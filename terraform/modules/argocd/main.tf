resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  version          = "6.9.0"
  create_namespace = true
  timeout          = 600

  values = [
    templatefile("${path.module}/template/server_values.yaml", {
      argocd_server_host                     = "argocd.${var.root_domain_name}"
      argocd_ingress_enabled                 = var.argocd_ingress_enabled
      argocd_ingress_tls_acme_enabled        = var.argocd_ingress_tls_acme_enabled
      argocd_ingress_ssl_passthrough_enabled = var.argocd_ingress_ssl_passthrough_enabled
      argocd_ingress_class                   = var.argocd_ingress_class
      profile                                = var.profile
    }),
    templatefile("${path.module}/template/repository_values.yaml", {
      project_repo_secret_key = var.project_repo_secret_key
      project_repo            = var.project_repo
      harbor_registry_url     = var.harbor_registry_url
      harbor_user             = var.harbor_user
      harbor_pwd              = var.harbor_pwd
    })
  ]
}

resource "helm_release" "argocd-apps" {
  name         = "argocd-apps"
  repository   = "https://argoproj.github.io/argo-helm"
  chart        = "argocd-apps"
  namespace    = "argocd"
  version      = "1.2.0"
  force_update = true

  values = [
    templatefile("${path.module}/template/application_values.yaml", {
      project_repo = var.project_repo
    })
  ]
  depends_on = [
    helm_release.argocd,
  ]
}

data "kubernetes_secret" "argocd_initial_admin" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = "argocd"
  }
  depends_on = [
    helm_release.argocd
  ]
}

locals {
  argocd_admin_password = try(base64decode(data.kubernetes_secret.argocd_initial_admin.data["password"]), null)
}

# Harbor credentials for to allow ArgoCD to pull images from Harbor
resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
  lifecycle {
    ignore_changes = all
  }
}


resource "kubernetes_secret" "harbor_creds" {
  metadata {
    name      = "harbor-creds"
    namespace = "dev"
    annotations = {
      "argocd.argoproj.io/secret-type" = "repository"
    }
    labels = {
      "argocd.argoproj.io/secret-type" = "repository"
    }

  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.harbor_registry_url}" = {
          username = var.harbor_user
          password = var.harbor_pwd
          auth     = base64encode("${var.harbor_user}:${var.harbor_pwd}")
        }
      }
    })
  }
  # depends_on = [kubernetes_namespace.dev] 
}

# Service Account for Harbor Puller to pull images from Harbor
resource "kubernetes_service_account" "harbor_puller" {
  metadata {
    name      = "harbor-puller"
    namespace = "dev"
  }

  automount_service_account_token = true

  secret {
    name = "harbor-creds"
  }
  depends_on = [ kubernetes_secret.harbor_creds ]
}

data "kubernetes_service" "argocd_server" {
  metadata {
    name      = "argocd-server"
    namespace = "argocd"
  }
  depends_on = [helm_release.argocd]
}
