resource "aws_eks_node_group" "node_group" {
  cluster_name    = var.cluster_name
  node_group_name = format("%s-node-group", "${var.cluster_name}-${var.node_group_name}")
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.subnet_ids
  capacity_type   = var.capacity_type
  force_update_version = true

  launch_template {
    id      = aws_launch_template.eks_node_group.id
    version = aws_launch_template.eks_node_group.latest_version
  }

  scaling_config {
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable_percentage = var.max_unavailable_percentage
    max_unavailable = 1
  }

  labels = var.labels

  tags = merge({
    Name        = format("%s-node-group", "${var.cluster_name}-${var.node_group_name}")
    Environment = var.environment # Add environment tag for better traceability
    ManagedBy   = "Terraform"      # Add a managed by tag for clarity
  }, var.tags)
}
