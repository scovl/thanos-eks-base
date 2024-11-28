resource "kubernetes_config_map" "aws-auth" {
  provider = kubernetes.test # Substitua "test" pelo nome do alias que você definiu no main.tf

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"

    labels = {
      "app.kubernetes.io/managed-by" = "Terraform"
      "terraform.io/module"          = "module.k8s_metrics_test" # Substitua "test" pelo ambiente correto
    }
  }

  data = {
    mapRoles = <<YAML
- rolearn: ${var.worker_role_arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
  - system:bootstrappers
  - system:nodes
- rolearn: ${var.sso_role}
  username: system:masters:{{EC2PrivateDNSName}}
  groups:
  - system:masters
- rolearn: ${var.code_build_role}
  username: system:build:{{EC2PrivateDNSName}}
  groups:
  - system:masters
- rolearn: ${var.worker_fargate_role_arn}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
  - system:bootstrappers
  - system:nodes
  - system:node-proxier
YAML
  }

  depends_on = [
    data.aws_eks_cluster.cluster,
    data.aws_eks_cluster_auth.cluster
  ]
}

