variable "hcp_client_id" {
  description = "vault id"
  type        = string
  sensitive   = true
}

variable "hcp_client_secret" {
  description = "vault secret"
  type        = string
  sensitive   = true
}
variable "hcp_org_id" {
  description = "vault secret"
  type        = string
}
variable "hcp_project_id" {
  description = "vault secret"
  type        = string
}
variable "hcp_app_name" {
  description = "nom de l'application"
  type        = string
}

variable "aws_accessKey_nom" {
  description = "nom de l'accessKey d'aws"
  type        = string
}

variable "aws_secretKey_nom" {
  description = "nom de l'secret Key d'aws"
  type        = string
}
variable "githug_ssh_nom" {
  description = "nom du secret Key pour la connexion avec GitHub"
  type        = string
}

variable "harbor_user_nom" {
  description = "nom du secret Key pour la connexion avec Harbor"
  type        = string
}

variable "harbor_pwd_nom" {
  description = "nom du secret Key pour la connexion avec Harbor"
  type        = string
}

variable "project_repo" {
  description = "depot git du chart helm pour le projet"
  default     = "git@github.com:FastPapy/fastops.git"
  type        = string
}
