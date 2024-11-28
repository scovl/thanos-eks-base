data "tls_certificate" "eks" {
  url = aws_eks_cluster.cluster.identity[0].oidc.issuer
  # Corrected the indexing pattern for oidc issuer
}
