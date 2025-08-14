data "aws_s3_bucket" "existing" {
  count  = var.bucket_exists ? 1 : 0
  bucket = var.bucket_name
}

module "aws_s3_bucket" {
  count                                 = var.bucket_exists ? 0 : 1
  source                                = "terraform-aws-modules/s3-bucket/aws"
  version                               = "4.1.1"
  bucket                                = var.bucket_name
  acl                                   = "private"
  force_destroy                         = true
  control_object_ownership              = true
  object_ownership                      = "ObjectWriter"
  attach_policy                         = false
  attach_deny_insecure_transport_policy = false

  versioning = {
    enabled = true
  }
}

locals {
  bucket_arn = var.bucket_exists ? data.aws_s3_bucket.existing[0].arn : (
    length(module.aws_s3_bucket) > 0 ? module.aws_s3_bucket[0].s3_bucket_arn : null
  )
  openid_connect_provider_uri = replace(var.cluster_oidc_issuer_url, "https://", "")
  valid_bucket_name           = can(regex("^[a-z0-9.-]{3,63}$", var.bucket_name))
}

module "velero" {
  source                      = "terraform-module/velero/kubernetes"
  version                     = "1.2.1"
  namespace_deploy            = true
  app_deploy                  = true
  cluster_name                = var.cluster_name
  openid_connect_provider_uri = local.openid_connect_provider_uri
  bucket                      = var.bucket_name
  
  
  values = [
    templatefile("${path.module}/template/values.yaml", {
      bucket_name     = var.bucket_name
      velero_provider = var.velero_provider
      region          = var.aws_region
    })
  ]
  depends_on = [module.aws_s3_bucket,kubectl_manifest.velero_crds]
}

resource "kubectl_manifest" "velero_crds" {
  for_each = fileset("${path.module}/crds", "*.yaml")
  
  yaml_body = file("${path.module}/crds/${each.value}")
  server_side_apply = true
  depends_on = [ aws_iam_policy.project_velero_policy, 
                 aws_iam_role.project_velero_role, 
                 aws_iam_role_policy_attachment.project_velero_policy_attachment,
                 module.aws_s3_bucket
  ]
}
