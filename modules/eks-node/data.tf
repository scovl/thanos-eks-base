data "aws_ssm_parameter" "eks_ami" {
  name = "/aws/service/eks/optimized-ami/${var.eks_version}/amazon-linux-2/recommended/image_id"
}

data "aws_ssm_parameter" "golden_ami" {
  name = "/url/to/goldenimage/${var.eks_version}/latest"
}

data "template_file" "user_data" {
  template = file("${path.module}/files/userdata.sh.tpl")
  vars = {
    cluster_name           = var.cluster_name
    cluster_endpoint       = var.cluster_endpoint
    cluster_ca_certificate = var.cluster_certificate_authority
    bootstrap_extra_args   = ""
    kubelet_extra_args     = ""
  }
}
