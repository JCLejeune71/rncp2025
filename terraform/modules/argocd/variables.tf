variable "project_repo" {
  type = string
}

variable "project_repo_secret_key" {
  type = string
  sensitive = true
}

variable "profile" {
  type = string
}

variable "root_domain_name" {
  type = string
}

variable "argocd_server_host" {
  description = "Hostname for argocd (will be utilised in ingress if enabled)"
  type        = string
  default     = "argocd.fastops.ip-ddns.com"
}

variable "argocd_ingress_class" {
  description = "Ingress class to use for argocd"
  type        = string
  default     = "nginx"
}

variable "argocd_ingress_enabled" {
  description = "Enable/disable argocd ingress"
  type        = bool
  default     = true
}

variable "argocd_ingress_tls_acme_enabled" {
  description = "Enable/disable acme TLS for ingress"
  type        = string
  default     = "true"
}

variable "argocd_ingress_ssl_passthrough_enabled" {
  description = "Enable/disable SSL passthrough for ingresss"
  type        = string
  default     = "true"
}

variable "harbor_registry_url" {
  description = "URL for the Harbor registry"
  type        = string
  default     = "demo.goharbor.io"
}

variable "harbor_user" {
  description = "Username for the Harbor registry"
  type        = string
  sensitive   = true
}

variable "harbor_pwd" {
  description = "Password for the Harbor registry"
  type        = string
  sensitive   = true
}
