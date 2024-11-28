# Apenas um recurso data para "aws_eks_cluster"
data "aws_eks_cluster" "cluster" {
  name = module.k8s_metrics.cluster_name
}

# Apenas um recurso data para "aws_eks_cluster_auth"
data "aws_eks_cluster_auth" "cluster" {
  name = data.aws_eks_cluster.cluster.name
}

