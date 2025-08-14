variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "prometheus_namespace" {
  type = string
  default     = "monitoring"
}

variable "profile" {
  type = string
}

variable "namespace" {
  type = string
}

variable "root_domain_name" {
  type = string
}

variable "grafana_pwd" {
  type = string
}

variable "grafana_ingress_class" {
  description = "Ingress class to use for grafana"
  type        = string
  default     = "nginx"
}

variable "grafana_ingress_enabled" {
  description = "Enable/disable grafana ingress"
  type        = bool
  default     = true
}

variable "grafana_ingress_tls_acme_enabled" {
  description = "Enable/disable acme TLS for ingress"
  type        = string
  default     = "true"
}

variable "grafana_ingress_ssl_passthrough_enabled" {
  description = "Enable/disable SSL passthrough for ingresss"
  type        = string
  default     = "true"
}

variable "grafana_ingress_tls_secret_name" {
  description = "Secret name for grafana TLS cert"
  type        = string
  default     = "grafana-tls-secret"
}
