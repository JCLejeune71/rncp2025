variable "namespace" {
  description = "Namespace"
  default     = "fastapi"
  type        = string
}

variable "ami_type" {
  description = "AMI Image type for the EKS server"
  default     = "AL2_x86_64"
  type        = string
}

variable "instance_type" {
  description = "Instance type for the EC2 instances"
  default     = "t3.medium"
  type        = string
}

variable "instance_number" {
  description = "Number of EC2 instances for the EKS server"
  default     = 2
  type        = number
}

variable "ebs_name_space" {
  description = "Namespace for EBS"
  default     = "dev"
  type        = string

}

variable "ebs_volume_name" {
  description = "EBS Volume name"
  default     = "ebs_volume_pg"
  type        = string
}

variable "ebs_volume_type" {
  description = "EBS Volume type"
  default     = "gp2"
  type        = string
}

variable "ebs_volume_size" {
  description = "EBS Volume size in Gi"
  default     = "1"
  type        = number
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "profile" {
  description = "environment"
  default     = "dev"
  type        = string
}

variable "cluster_name" {
  description = "Cluster Name"
  default     = "fastapi-eks"
  type        = string
}

variable "root_domain_name" {
  description = "Root domaine name"
  default     = "fastops.ip-ddns.com"
  type        = string
}

variable "grafana_pwd" {
  type        = string
  description = "grafana admin pass"
  sensitive   = true
}

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
  description = "Application Name"
  type        = string
}

variable "aws_accessKey_nom" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secretKey_nom" {
  description = "AWS Secret Key"
  type        = string
}
variable "githug_ssh_nom" {
  description = "SSH Github variable name in Hashicorp Vault"
  type        = string
  sensitive   = true
}

variable "project_repo" {
  description = "GitHub repo for the application to be deployed by ArgoCD"
  default     = "git@github.com:JCLejeune71/rncp2025.git"
  type        = string
  sensitive   = true
}

variable "harbor_user_nom" {
  description = "nom du secret Key pour la connexion avec Harbor"
  type        = string
}

variable "harbor_pwd_nom" {
  description = "nom du secret Key pour la connexion avec Harbor"
  type        = string
}