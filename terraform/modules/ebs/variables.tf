variable "aws_region" {
  description = "AWS région"
  type        = string
}

variable "volume_type" {
  description = "EBS Volume type "
  type        = string
}

variable "volume_name" {
  description = "EBS Volume name"
  type        = string
}

variable "size" {
  description = "EBS Size"
  type        = number
}

variable "namespace" {
  description = "EBS Namespace"
  type        = string
}

variable "cluster_name" {
  description = "Cluster Name"
  type        = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider arn"
  type        = string
}

variable "node_group_name" {
  description = "Node Group Name"
  type        = string
}
