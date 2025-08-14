resource "helm_release" "ebs_csi_driver" {
  name       = "aws-ebs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
  chart      = "aws-ebs-csi-driver"
  namespace  = "kube-system"

  set {
    name  = "controller.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "ebs-csi-controller-sa"
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.ebs_csi_irsa.iam_role_arn
  }
}

resource "kubernetes_namespace" "app_namespace" {
  metadata {
    name = var.namespace  
  }
}

data "aws_instances" "workers" {
  filter {
    name   = "tag:eks:cluster-name"
    values = [var.cluster_name]
  }
  filter {
    name   = "instance-state-name"
    values = ["running"]
  }
  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]  # Must match EBS volume AZ
  }
}

locals {
  worker_instance_id = length(data.aws_instances.workers.ids) > 0 ? data.aws_instances.workers.ids[0] : null
}

resource "aws_volume_attachment" "ebs_attach" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.db-backend_volume.id
  instance_id = data.aws_instances.workers.ids[0] # Automatically picks the right instance
  
}

resource "aws_ebs_volume" "db-backend_volume" {
  availability_zone = "us-east-1a"
  size              = var.size
  type              = var.volume_type
  encrypted         = false
  lifecycle {
    #prevent_destroy = true 
  }
  tags = {
    Name = var.volume_name
  }
  depends_on = [kubernetes_namespace.app_namespace]
}

resource "kubernetes_persistent_volume" "db-backend-pv" {
  metadata {
    name = "db-backend-pv"
  }
  spec {
    capacity = {
      storage = var.size
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    storage_class_name = "gp2"
    node_affinity {
      required {
        node_selector_term {
          match_expressions {
            key = "topology.kubernetes.io/zone"
            operator = "In"
            values = ["us-east-1a"]
          }
        }
      }
    }
    persistent_volume_source {
      aws_elastic_block_store {
        volume_id = aws_ebs_volume.db-backend_volume.id
      }
    }
  }
  depends_on = [ helm_release.ebs_csi_driver, aws_volume_attachment.ebs_attach ]
}

resource "kubernetes_persistent_volume_claim" "db-backend-pvc" {
  metadata {
    name = "db-backend-pvc"
    namespace = var.namespace # Or an existing namespace you have access to
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = var.size
      }
    }
    #volume_name = kubernetes_persistent_volume.db-backend-pv.metadata[0].name
    volume_name = "db-backend-pv"
    storage_class_name = "gp2" # Use your cluster's default storage class
  }
  depends_on = [ kubernetes_persistent_volume.db-backend-pv ]
}

