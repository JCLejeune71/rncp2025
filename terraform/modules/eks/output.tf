output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "eks_admins_iam_role" {
  value = module.eks_admins_iam_role
}

output "cluster_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}
output "cluster_oidc_provider_arn" {
  value = module.eks.oidc_provider_arn 
}

output "node_group_name" {
  value = keys(module.eks.eks_managed_node_groups)[0]
}

output "cluster_name" {
  value = module.eks.cluster_name
  
}

output "cluster_id" {
  value = module.eks.cluster_id
}