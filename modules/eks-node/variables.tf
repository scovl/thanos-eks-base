variable "node_group_name" {
  type        = string
  description = "Name of the node group"
}

variable "node_role_arn" {
  type        = string
  description = "ARN of the IAM role for the node group"
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
}

variable "eks_version" {
  type        = string
  default     = "1.30"
  description = "Kubernetes version for the EKS cluster"
}

variable "security_groups" {
  type        = list(string)
  description = "List of security group IDs for the node group"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the node group"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type for the node group"
  default     = "t2.medium"
}

variable "labels" {
  type        = map(string)
  description = "Labels to assign to nodes"
}

variable "capacity_type" {
  type        = string
  description = "Capacity type for the node group (on-demand or spot)"
  default     = "on-demand"
}

variable "desired_size" {
  type        = number
  description = "Desired number of nodes in the node group"
  default     = 1
}

variable "min_size" {
  type        = number
  description = "Minimum number of nodes in the node group"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum number of nodes in the node group"
  default     = 1
}

variable "cluster_certificate_authority" {
  type        = string
  description = "Cluster CA certificate data for authentication"
}

variable "cluster_endpoint" {
  type        = string
  description = "Endpoint for the EKS cluster"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the node group resources"
}

variable "node_volume_size" {
  type        = number
  description = "Size of the EBS volume for nodes (in GiB)"
  default     = 20
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Indicates whether to associate a public IP address with the instance"
  default     = false
}

variable "volume_type" {
  type        = string
  description = "Type of the EBS volume (e.g., gp2, gp3)"
  default     = "gp2"
}

variable "ebs_optimized" {
  type        = bool
  description = "Indicates whether the instance should be optimized for EBS"
  default     = true
}

variable "ebs_encrypted" {
  type        = bool
  description = "Indicates whether the EBS volume should be encrypted"
  default     = true
}

variable "encryption_config_kms_arn" {
  type        = string
  description = "KMS key ARN for encrypting EBS volumes and other resources"
  default     = "arn:aws:kms:us-east-1:123456789012:key/your-kms-key-id"
}


variable "availability_zone" {
  type        = string
  description = "Availability zone for the instances"
  default     = null
}

variable "prevent_destroy" {
  type        = bool
  description = "Prevent nodes from being destroyed by Terraform"
  default     = false
}

variable "environment" {
  type        = string
  description = "The environment for the resources, e.g., dev, staging, or prod."
}

variable "node_group_role" {
  type        = string
  description = "Role tag for clarity on the instance purpose."
}

variable "disk_size" {
  type        = number
  description = "The size of the disk for the node group instances."
}

variable "max_unavailable_percentage" {
  type        = number
  description = "The maximum percentage of nodes that can be unavailable during updates or scaling activities."
  default     = 20
}

