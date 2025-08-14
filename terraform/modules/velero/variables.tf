variable "velero_namespace" {
  type = string
  default     = "velero"
}

variable "velero_provider" {
  type = string
  default     = "aws"
}

variable "bucket_name" {
  type = string
  default     = "velerobackup-s3"
}

variable "cluster_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "cluster_oidc_issuer_url" {
  type = string
}
variable "bucket_exists" {
  type = bool
  default = false
}
