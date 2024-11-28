# Centralized security group rules using locals
locals {
  security_group_rules = {
    # Cluster security group rules
    cluster_egress_internet = {
      description       = "Allow egress for EKS cluster"
      protocol          = "-1"
      security_group_id = aws_security_group.eks_cluster_metrics.id
      cidr_blocks       = var.allowed_cidr_blocks
      from_port         = 0
      to_port           = 0
      type              = "egress"
    }
    cluster_https_worker_ingress = {
      description              = "Allow HTTPS ingress for communication between cluster and worker nodes"
      protocol                 = "tcp"
      security_group_id        = aws_security_group.eks_cluster_metrics.id
      source_security_group_id = aws_security_group.eks_node_metrics.id
      from_port                = 443
      to_port                  = 443
      type                     = "ingress"
    }
    core_dns_tcp_subnets_private = {
      description       = "Allow core DNS over TCP from private subnets"
      protocol          = "tcp"
      security_group_id = aws_security_group.eks_cluster_metrics.id
      cidr_blocks       = var.cidr_blocks[var.environment]
      from_port         = 53
      to_port           = 53
      type              = "ingress"
    }
    core_dns_udp_subnets_private = {
      description       = "Allow core DNS over UDP from private subnets"
      protocol          = "udp"
      security_group_id = aws_security_group.eks_cluster_metrics.id
      cidr_blocks       = var.cidr_blocks[var.environment]
      from_port         = 53
      to_port           = 53
      type              = "ingress"
    }
    # Node security group rules
    workers_egress_internet = {
      description       = "Allow nodes egress to the Internet"
      protocol          = "-1"
      security_group_id = aws_security_group.eks_node_metrics.id
      cidr_blocks       = var.allowed_cidr_blocks
      from_port         = 0
      to_port           = 0
      type              = "egress"
    }
    workers_self = {
      description       = "Allow inter-node communication"
      protocol          = "-1"
      self              = true
      security_group_id = aws_security_group.eks_node_metrics.id
      from_port         = 0
      to_port           = 0
      type              = "ingress"
    }
    workers_control_plane = {
      description              = "Allow recommended traffic from the control plane"
      protocol                 = "tcp"
      security_group_id        = aws_security_group.eks_node_metrics.id
      source_security_group_id = aws_security_group.eks_cluster_metrics.id
      from_port                = 1025
      to_port                  = 65535
      type                     = "ingress"
    }
  }
}

# Define security group rules dynamically
resource "aws_security_group_rule" "eks_security_rules" {
  for_each = local.security_group_rules

  description       = each.value.description
  protocol          = each.value.protocol
  security_group_id = each.value.security_group_id
  cidr_blocks       = try(each.value.cidr_blocks, null)
  source_security_group_id = try(each.value.source_security_group_id, null)
  self              = try(each.value.self, null)
  from_port         = each.value.from_port
  to_port           = each.value.to_port
  type              = each.value.type
}

# Cluster security group
resource "aws_security_group" "eks_cluster_metrics" {
  name        = "eks_cluster_metrics_${var.environment}"
  description = "Security Group for EKS cluster"
  vpc_id      = var.vpc_id[var.environment]

  tags = {
    Name = "eks_cluster_metrics_${var.environment}"
  }
}

# Node security group
resource "aws_security_group" "eks_node_metrics" {
  name        = "eks_node_metrics_${var.environment}"
  description = "Security Group for EKS node"
  vpc_id      = var.vpc_id[var.environment]

  tags = {
    Name = "eks_node_metrics_${var.environment}"
  }
}

