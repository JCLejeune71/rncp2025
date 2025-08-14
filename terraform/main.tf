module "vault" {
  source            = "./modules/vault"
  hcp_client_id     = var.hcp_client_id
  hcp_client_secret = var.hcp_client_secret
  hcp_org_id        = var.hcp_org_id
  hcp_project_id    = var.hcp_project_id
  hcp_app_name      = var.hcp_app_name
  aws_accessKey_nom = var.aws_accessKey_nom
  aws_secretKey_nom = var.aws_secretKey_nom
  githug_ssh_nom    = var.githug_ssh_nom
  harbor_user_nom   = var.harbor_user_nom
  harbor_pwd_nom    = var.harbor_pwd_nom
}

module "networking" {
  source     = "./modules/networking"
  namespace  = var.namespace
  depends_on = [module.vault]
}


module "eks" {
  source              = "./modules/eks"
  ami_type            = var.ami_type
  instance_type       = var.instance_type
  instance_number     = var.instance_number
  vpc                 = module.networking.vpc
  private_subnets     = module.networking.vpc.private_subnets
  sg_web_id           = module.networking.sg_web_id
  region              = var.aws_region
  cluster_name        = var.cluster_name
  profile             = var.profile
  eks_admins_iam_role = module.eks.eks_admins_iam_role
  depends_on          = [module.networking]
}

# module "ebs" {
#   source            = "./modules/ebs"
#   namespace         = var.ebs_name_space
#   aws_region        = var.aws_region
#   volume_name       = var.ebs_volume_name
#   volume_type       = var.ebs_volume_type
#   size              = var.ebs_volume_size
#   cluster_name      = var.cluster_name
#   oidc_provider_arn = module.eks.cluster_oidc_provider_arn
#   node_group_name   = tostring(module.eks.node_group_name)
#   depends_on        = [module.eks]
# }

module "ingress" {
  source     = "./modules/ingresscontroller"
  depends_on = [module.eks]
}

module "argocd" {
  source                  = "./modules/argocd"
  project_repo            = var.project_repo
  project_repo_secret_key = module.vault.GitHub
  profile                 = var.profile
  root_domain_name        = var.root_domain_name
  harbor_user             = module.vault.harbor_user
  harbor_pwd              = module.vault.harbor_pwd
  depends_on              = [module.ingress]
}


module "prometheus" {
  source           = "./modules/prometheus"
  grafana_pwd      = var.grafana_pwd
  profile          = var.profile
  namespace        = var.namespace
  root_domain_name = var.root_domain_name
  depends_on       = [module.ingress]
}

module "velero" {
  source                  = "./modules/velero"
  cluster_name            = var.cluster_name
  aws_region              = var.aws_region
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  depends_on              = [module.argocd, module.prometheus]
}

