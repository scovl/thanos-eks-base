resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = var.role_eks
  version  = var.eks_version
  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler",
  ]

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = var.security_group_ids
  }

  tags = merge({
    Name        = var.cluster_name,
    Environment = var.environment, # Add environment tag for better traceability
    ManagedBy   = "Terraform"      # Add a managed by tag for clarity
  }, var.tags)

  encryption_config {
    provider {
      key_arn = var.encryption_config_kms_arn
    }
    resources = [
      "secrets" # Ensure that only sensitive data is encrypted
    ]
  }

  # Improved node root volume size, to provide enough disk space for larger deployments
  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr # Allow flexibility in configuring the CIDR block for services
  }

  # Adding default addons for a more secure cluster configuration
  addons {
    addon_name    = "vpc-cni"
    addon_version = "latest"
    resolve_conflicts = "OVERWRITE"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]
}

resource "aws_cloudwatch_log_group" "eks_logs" {
  name              = "/eks/cluster/${var.environment}"
  retention_in_days = 30 # Retain logs for 30 days
}

resource "aws_iam_policy_attachment" "eks_logs_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
  roles      = [aws_iam_role.eks_cluster_role.name]
}

