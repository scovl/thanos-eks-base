module "k8s_metrics" {
  source                    = "./modules/eks"
  environment               = var.environment
  cluster_name              = "eks_metrics_${var.environment}"
  eks_version               = "1.30" # Updated to the latest stable EKS version
  subnet_ids                = var.subnet_ids[var.environment]
  endpoint_private_access   = true  # Enable private access to the cluster endpoint
  endpoint_public_access    = false # Disable public access to improve security
  public_access_cidrs       = var.public_access_cidrs
  role_eks                  = var.role_eks
  encryption_config_kms_arn = var.encryption_kms_arn # KMS key for encrypting sensitive data
  security_group_ids        = [aws_security_group.eks_cluster_metrics.id]
  tags                      = merge(var.tags, { "Environment" = var.environment }) # Add an environment tag for better traceability
}

# Centralized definition of node groups
locals {
  node_groups = {
    general = {
      instance_type = "m5.xlarge"
      labels        = { workload = "general", environment = var.environment }
      desired_size  = 4
      min_size      = 3
      max_size      = 6
    }
    thanos_query_shared = {
      instance_type = "m5.xlarge"
      labels        = { workload = "thanos-query-shared", environment = var.environment }
      desired_size  = 6
      min_size      = 4
      max_size      = 20
    }
    thanos_receive_shared_az_a = {
      instance_type = "m5.2xlarge"
      labels        = { workload = "thanos-receive-shared", environment = var.environment }
      desired_size  = 10
      min_size      = 8
      max_size      = 100
      subnet_key    = "${var.environment}-a"
    }
    thanos_receive_shared_az_b = {
      instance_type = "m5.2xlarge"
      labels        = { workload = "thanos-receive-shared", environment = var.environment }
      desired_size  = 10
      min_size      = 8
      max_size      = 100
      subnet_key    = "${var.environment}-b"
    }
    thanos_receive_shared_az_c = {
      instance_type = "m5.2xlarge"
      labels        = { workload = "thanos-receive-shared", environment = var.environment }
      desired_size  = 10
      min_size      = 8
      max_size      = 100
      subnet_key    = "${var.environment}-c"
    }
    monitoring = {
      instance_type = "r5.2xlarge"
      labels        = { workload = "monitoring", environment = var.environment }
      desired_size  = 3
      min_size      = 2
      max_size      = 6
    }
    grafana = {
      instance_type = "t3a.large"
      labels        = { workload = "grafana", environment = var.environment }
      desired_size  = 3
      min_size      = 2
      max_size      = 5
    }
  }
}

module "k8s_metrics_node_groups" {
  for_each                    = local.node_groups

  source                       = "./modules/eks-node"
  cluster_name                 = module.k8s_metrics.cluster_name
  eks_version                  = "1.30"
  cluster_endpoint             = module.k8s_metrics.cluster_endpoint
  cluster_certificate_authority = module.k8s_metrics.cluster_certificate_authority
  node_group_name              = each.key
  node_role_arn                = var.node_role_arn
  security_groups              = [aws_security_group.eks_cluster_metrics.id, module.k8s_metrics.cluster_security_group_id, aws_security_group.eks_node_metrics.id]
  subnet_ids                   = try(var.subnet_ids_nodes[each.value.subnet_key], var.subnet_ids_nodes[var.environment])
  instance_type                = each.value.instance_type
  disk_size                    = each.value.disk_size
  labels                       = each.value.labels
  capacity_type                = "ON_DEMAND"
  desired_size                 = each.value.desired_size
  min_size                     = each.value.min_size
  max_size                     = each.value.max_size
  tags                         = merge(var.tags, { "NodeGroup" = each.key })

  environment                  = var.environment
  node_group_role              = "DefaultNodeGroupRole"
  max_unavailable_percentage   = 20  # Passe o valor necessário para esta variável

  depends_on = [
    module.k8s_metrics,
    kubernetes_config_map.aws_auth
  ]
}

