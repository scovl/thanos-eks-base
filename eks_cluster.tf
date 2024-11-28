// cluster environment
module "k8s_metrics" {
  source                    = "./modules/eks"
  cluster_name              = "eks_metrics_${var.environment}"
  eks_version               = "1.21" # Updated to the latest EKS version
  subnet_ids                = var.subnet_ids[var.environment]
  endpoint_private_access   = true  # Enables private access to the cluster endpoint
  endpoint_public_access    = false # Best practice: disable public access to the endpoint for better security
  public_access_cidrs       = var.public_access_cidrs
  role_eks                  = var.role_eks
  encryption_config_kms_arn = var.encryption_kms_arn # KMS ARN for encrypting EKS data
  security_group_ids        = [aws_security_group.eks_cluster_metrics.id]
  tags                      = merge(var.tags, { "Environment" = var.environment }) # Adds environment tag for better traceability
}

// node general workload
module "k8s_metrics_node_general" {
  source                       = "./modules/eks-node"
  cluster_name                 = module.k8s_metrics.cluster_name
  eks_version                  = "1.21"
  cluster_endpoint             = module.k8s_metrics.cluster_endpoint
  cluster_certificate_autority = module.k8s_metrics.cluster_certificate_autority
  node_group_name              = "general"
  node_role_arn                = var.node_role_arn
  security_groups              = [aws_security_group.eks_cluster_metrics.id, module.k8s_metrics.cluster_security_group_id, aws_security_group.eks_node_metrics.id]
  subnet_ids                   = var.subnet_ids_nodes[var.environment]
  instance_type                = "m5.xlarge" # Instance type selected for general-purpose workload
  disk_size                    = 100
  labels = {
    workload    = "general"
    environment = var.environment # Adds environment label for better identification
  }
  capacity_type = "ON_DEMAND"
  desired_size  = 4
  min_size      = 3                                            # Adjusted min_size to improve scalability
  max_size      = 6                                            # Adjusted max_size to allow better scaling
  tags          = merge(var.tags, { "NodeGroup" = "general" }) # Adds node group tag for better resource categorization
  depends_on = [
    module.k8s_metrics,
    kubernetes_config_map.aws_auth
  ]
}

// node workload thanos query
module "k8s_metrics_node_thanos_query_shared" {
  source                       = "./modules/eks-node"
  cluster_name                 = module.k8s_metrics.cluster_name
  eks_version                  = "1.21"
  cluster_endpoint             = module.k8s_metrics.cluster_endpoint
  cluster_certificate_autority = module.k8s_metrics.cluster_certificate_autority
  node_group_name              = "thanos-query-shared"
  node_role_arn                = var.node_role_arn
  security_groups              = [aws_security_group.eks_cluster_metrics.id, module.k8s_metrics.cluster_security_group_id, aws_security_group.eks_node_metrics.id]
  subnet_ids                   = var.subnet_ids_nodes[var.environment]
  instance_type                = "m5.xlarge" # Instance type for query processing workload
  disk_size                    = 150         # Increased disk size to better support the workload
  labels = {
    workload    = "thanos-query-shared"
    environment = var.environment
  }
  capacity_type = "ON_DEMAND"
  desired_size  = 6
  min_size      = 4
  max_size      = 20
  tags          = merge(var.tags, { "NodeGroup" = "thanos-query-shared" })
  depends_on = [
    module.k8s_metrics,
    kubernetes_config_map.aws_auth
  ]
}

// node workload thanos receive shared AZ-A
module "k8s_metrics_node_thanos_receive_shared_az_a" {
  source                       = "./modules/eks-node"
  cluster_name                 = module.k8s_metrics.cluster_name
  eks_version                  = "1.21"
  cluster_endpoint             = module.k8s_metrics.cluster_endpoint
  cluster_certificate_autority = module.k8s_metrics.cluster_certificate_autority
  node_group_name              = "thanos-receive-shared-az-a"
  node_role_arn                = var.node_role_arn
  security_groups              = [aws_security_group.eks_cluster_metrics.id, module.k8s_metrics.cluster_security_group_id, aws_security_group.eks_node_metrics.id]
  subnet_ids                   = var.subnet_ids_nodes["${var.environment}-a"]
  instance_type                = "m5.2xlarge" # Instance type for high-performance workload
  disk_size                    = 750          # Increased disk size to support intensive I/O operations
  labels = {
    workload    = "thanos-receive-shared"
    environment = var.environment
  }
  capacity_type = "ON_DEMAND"
  desired_size  = 10 # Adjusted desired_size to optimize resource allocation
  min_size      = 8
  max_size      = 100
  tags          = merge(var.tags, { "NodeGroup" = "thanos-receive-shared-az-a" })
  depends_on = [
    module.k8s_metrics,
    kubernetes_config_map.aws_auth
  ]
}

// node workload thanos receive shared AZ-B
module "k8s_metrics_node_thanos_receive_shared_az_b" {
  source                       = "./modules/eks-node"
  cluster_name                 = module.k8s_metrics.cluster_name
  eks_version                  = "1.21"
  cluster_endpoint             = module.k8s_metrics.cluster_endpoint
  cluster_certificate_autority = module.k8s_metrics.cluster_certificate_autority
  node_group_name              = "thanos-receive-shared-az-b"
  node_role_arn                = var.node_role_arn
  security_groups              = [aws_security_group.eks_cluster_metrics.id, module.k8s_metrics.cluster_security_group_id, aws_security_group.eks_node_metrics.id]
  subnet_ids                   = var.subnet_ids_nodes["${var.environment}-b"]
  instance_type                = "m5.2xlarge"
  disk_size                    = 750
  labels = {
    workload    = "thanos-receive-shared"
    environment = var.environment
  }
  capacity_type = "ON_DEMAND"
  desired_size  = 10
  min_size      = 8
  max_size      = 100
  tags          = merge(var.tags, { "NodeGroup" = "thanos-receive-shared-az-b" })
  depends_on = [
    module.k8s_metrics,
    kubernetes_config_map.aws_auth
  ]
}

// node workload thanos receive shared AZ-C
module "k8s_metrics_node_thanos_receive_shared_az_c" {
  source                       = "./modules/eks-node"
  cluster_name                 = module.k8s_metrics.cluster_name
  eks_version                  = "1.21"
  cluster_endpoint             = module.k8s_metrics.cluster_endpoint
  cluster_certificate_autority = module.k8s_metrics.cluster_certificate_autority
  node_group_name              = "thanos-receive-shared-az-c"
  node_role_arn                = var.node_role_arn
  security_groups              = [aws_security_group.eks_cluster_metrics.id, module.k8s_metrics.cluster_security_group_id, aws_security_group.eks_node_metrics.id]
  subnet_ids                   = var.subnet_ids_nodes["${var.environment}-c"]
  instance_type                = "m5.2xlarge"
  disk_size                    = 750
  labels = {
    workload    = "thanos-receive-shared"
    environment = var.environment
  }
  capacity_type = "ON_DEMAND"
  desired_size  = 10
  min_size      = 8
  max_size      = 100
  tags          = merge(var.tags, { "NodeGroup" = "thanos-receive-shared-az-c" })
  depends_on = [
    module.k8s_metrics,
    kubernetes_config_map.aws_auth
  ]
}

// node workload monitoring
module "k8s_metrics_node_monitoring_shared" {
  source                       = "./modules/eks-node"
  cluster_name                 = module.k8s_metrics.cluster_name
  eks_version                  = "1.21"
  cluster_endpoint             = module.k8s_metrics.cluster_endpoint
  cluster_certificate_autority = module.k8s_metrics.cluster_certificate_autority
  node_group_name              = "monitoring"
  node_role_arn                = var.node_role_arn
  security_groups              = [aws_security_group.eks_cluster_metrics.id, module.k8s_metrics.cluster_security_group_id, aws_security_group.eks_node_metrics.id]
  subnet_ids                   = var.subnet_ids_nodes[var.environment]
  instance_type                = "r5.2xlarge" # Instance type for workloads with high memory usage
  disk_size                    = 500          # Increased disk size for monitoring data storage
  labels = {
    workload    = "monitoring"
    environment = var.environment
  }
  capacity_type = "ON_DEMAND"
  desired_size  = 3
  min_size      = 2
  max_size      = 6 # Increased max_size to allow higher scalability
  tags          = merge(var.tags, { "NodeGroup" = "monitoring" })
  depends_on = [
    module.k8s_metrics,
    kubernetes_config_map.aws_auth
  ]
}

// node workload grafana
module "k8s_metrics_node_grafana_shared" {
  source                       = "./modules/eks-node"
  cluster_name                 = module.k8s_metrics.cluster_name
  eks_version                  = "1.21"
  cluster_endpoint             = module.k8s_metrics.cluster_endpoint
  cluster_certificate_autority = module.k8s_metrics.cluster_certificate_autority
  node_group_name              = "grafana"
  node_role_arn                = var.node_role_arn
  security_groups              = [aws_security_group.eks_cluster_metrics.id, module.k8s_metrics.cluster_security_group_id, aws_security_group.eks_node_metrics.id]
  subnet_ids                   = var.subnet_ids_nodes[var.environment]
  instance_type                = "t3a.large" # Instance type for lightweight workloads like Grafana
  disk_size                    = 50          # Increased disk size to handle larger data volumes
  labels = {
    workload    = "grafana"
    environment = var.environment
  }
  capacity_type = "ON_DEMAND"
  desired_size  = 3
  min_size      = 2
  max_size      = 5 # Adjusted max_size to allow scaling when needed
  tags          = merge(var.tags, { "NodeGroup" = "grafana" })
  depends_on = [
    module.k8s_metrics,
    kubernetes_config_map.aws_auth
  ]
}
