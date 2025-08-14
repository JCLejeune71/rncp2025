output "argo_pwd" {
    value = local.argocd_admin_password
}
output "argo_ssh" {
    value = var.project_repo_secret_key
}

output "argocd_admin_password" {
  value     = local.argocd_admin_password
  sensitive = true
}

