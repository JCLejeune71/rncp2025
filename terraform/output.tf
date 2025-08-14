output "EKS_K8S_CONNECT" {
value = "aws eks update-kubeconfig --region ${var.aws_region} --name ${var.cluster_name}"
}
