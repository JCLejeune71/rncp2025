variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
}

variable "ami_type" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "instance_number" {
  type = number
}

variable "profile" {
  type = string
}

variable "vpc" {
  type = any
}

variable "private_subnets" {
  type = any
}

variable "sg_web_id" {
  type = any
}

variable "eks_admins_iam_role" {
  type = any
}
