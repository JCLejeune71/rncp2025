module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.32"

  cluster_endpoint_public_access  = true # Change to false for production use
  cluster_endpoint_private_access = true

  create_kms_key              = false # Change to true for production
  create_cloudwatch_log_group = false # Change to true for production
  cluster_encryption_config   = {}

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = var.vpc.vpc_id
  subnet_ids = var.private_subnets

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type       = "${var.ami_type}"
    instance_types = ["${var.instance_type}"]
    sg_private_ids = ["${var.sg_web_id}"]
  }

  eks_managed_node_groups = {
    workers = {
      name         = "worker-nodes"
      min_size     = 1
      max_size     = 3
      desired_size = "${var.instance_number}"

      instance_types = ["${var.instance_type}"]
      capacity_type  = "SPOT"
    }
  }

  enable_cluster_creator_admin_permissions = true

  tags = {
    env       = var.profile
    terraform = "true"
    type      = "fastapi-eks"
  }
}
