resource "aws_launch_template" "eks_node_group" {
  name                   = format("%s-node-group", "${var.cluster_name}-${var.node_group_name}")
  update_default_version = true

  image_id      = data.aws_ssm_parameter.eks_ami.value
  instance_type = var.instance_type
  user_data     = base64encode(data.template_file.user_data.rendered)

  network_interfaces {
    associate_public_ip_address = var.associate_public_ip_address
    delete_on_termination       = true
    security_groups             = var.security_groups
  }

  monitoring {
    enabled = true
  }

  ebs_optimized = var.ebs_optimized # Make EBS optimization configurable for more flexibility

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = var.disk_size
      volume_type           = var.volume_type
      encrypted             = var.ebs_encrypted # Make encryption configurable
      kms_key_id            = var.encryption_config_kms_arn
      delete_on_termination = true
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge({
      Name        = format("%s-node-group", "${var.cluster_name}-${var.node_group_name}")
      Environment = var.environment
      ManagedBy   = "Terraform"
      Role        = var.node_group_role # Add role tag for more clarity on the instance purpose
    }, var.tags)
  }

  placement {
    availability_zone = var.availability_zone # Allow specifying availability zone for better control
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = false  # Defina um valor fixo (true ou false) para `prevent_destroy`
  }
}

