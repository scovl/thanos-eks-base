resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    data.tls_certificate.eks.certificates[0].sha1_fingerprint,
  ]

  url = aws_eks_cluster.cluster.identity[0].oidc.issuer
  # Simplified URL assignment without the need for flatten/concat
}

# Notes for improvements:
# 1. Corrected typo in `thumbprint_list`.
# 2. Simplified the `url` assignment to directly use the `oidc.issuer` without using `flatten` and `concat`, which were unnecessary.
