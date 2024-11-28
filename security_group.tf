// Security group for cluster and nodes
resource "aws_security_group" "eks_cluster_metrics" {
  name        = "eks_cluster_metrics_${var.environment}"
  description = "Security Group for EKS cluster"
  vpc_id      = var.vpc_id[var.environment]

  tags = {
    Name = "eks_cluster_metrics_${var.environment}"
  }
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  description       = "Allow egress for EKS cluster"
  protocol          = "-1"
  security_group_id = aws_security_group.eks_cluster_metrics.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "cluster_https_worker_ingress" {
  description              = "Allow HTTPS ingress for communication between cluster and worker nodes"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_cluster_metrics.id
  source_security_group_id = aws_security_group.eks_node_metrics.id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "core_dns_tcp_subnets_private" {
  description       = "Allow core DNS over TCP from private subnets"
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_cluster_metrics.id
  cidr_blocks       = var.cidr_blocks[var.environment]
  from_port         = 53
  to_port           = 53
  type              = "ingress"
}

resource "aws_security_group_rule" "core_dns_udp_subnets_private" {
  description       = "Allow core DNS over UDP from private subnets"
  protocol          = "udp"
  security_group_id = aws_security_group.eks_cluster_metrics.id
  cidr_blocks       = var.cidr_blocks[var.environment]
  from_port         = 53
  to_port           = 53
  type              = "ingress"
}

resource "aws_security_group_rule" "sg_default_https_allow_cluster" {
  description              = "Allow HTTPS from VPC default SG to cluster"
  protocol                 = "tcp"
  security_group_id        = var.sg_vpc_default[var.environment]
  source_security_group_id = aws_security_group.eks_node_metrics.id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group" "eks_node_metrics" {
  name        = "eks_node_metrics_${var.environment}"
  description = "Security Group for EKS node"
  vpc_id      = var.vpc_id[var.environment]

  tags = {
    Name = "eks_node_metrics_${var.environment}"
  }
}

resource "aws_security_group_rule" "workers_egress_internet" {
  description       = "Allow nodes egress to the Internet"
  protocol          = "-1"
  security_group_id = aws_security_group.eks_node_metrics.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "workers_ingress_cluster_kubelet" {
  description              = "Allow workers Kubelets to receive communication from the cluster control plane"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node_metrics.id
  source_security_group_id = aws_security_group.eks_cluster_metrics.id
  from_port                = 10250
  to_port                  = 10250
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster_https" {
  description              = "Allow pods running extension API servers on port 443 to receive communication from the cluster control plane"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node_metrics.id
  source_security_group_id = aws_security_group.eks_cluster_metrics.id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_https_subnets_private" {
  description       = "Allow workers ingress HTTPS from private subnets"
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_node_metrics.id
  cidr_blocks       = var.cidr_blocks[var.environment]
  from_port         = 443
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "workers_self" {
  description       = "Allow inter-node communication"
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.eks_node_metrics.id
  from_port         = 0
  to_port           = 0
  type              = "ingress"
}

resource "aws_security_group_rule" "workers_control_plane" {
  description              = "Allow recommended traffic from the control plane"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node_metrics.id
  source_security_group_id = aws_security_group.eks_cluster_metrics.id
  from_port                = 1025
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_primary_ingress_workers" {
  description              = "Allow pods running on workers to send communication to cluster primary security group (e.g., Fargate pods)"
  protocol                 = "tcp"
  security_group_id        = aws_security_group.eks_node_metrics.id
  source_security_group_id = aws_security_group.eks_cluster_metrics.id
  from_port                = 10250
  to_port                  = 10250
  type                     = "ingress"
}

resource "aws_security_group_rule" "sg_default_https_allow_node" {
  description              = "Allow HTTPS from VPC default SG to nodes"
  protocol                 = "tcp"
  security_group_id        = var.sg_vpc_default[var.environment]
  source_security_group_id = aws_security_group.eks_cluster_metrics.id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}
