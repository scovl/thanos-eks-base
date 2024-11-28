output "cluster_name" {
  value = aws_eks_cluster.cluster.name
  description = "The name of the EKS cluster."
}

output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
  description = "The endpoint URL of the EKS cluster."
}

output "cluster_certificate_authority" {
  value = aws_eks_cluster.cluster.certificate_authority[0].data
  description = "The certificate authority data for the EKS cluster."
}

output "cluster_security_group_id" {
  value = aws_eks_cluster.cluster.vpc_config.cluster_security_group_id
  description = "The security group ID of the EKS cluster."
}
