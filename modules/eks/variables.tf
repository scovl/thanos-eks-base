variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the EKS cluster."
}

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster."
}

variable "role_eks" {
  type        = string
  description = "ARN of the IAM role for the EKS cluster."
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources created by the EKS cluster."
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for the EKS cluster."
}

variable "encryption_config_kms_arn" {
  type        = string
  description = "ARN of the KMS key for EKS encryption."
}

variable "eks_version" {
  type        = string
  description = "Kubernetes version for the EKS cluster."
}

variable "endpoint_private_access" {
  type        = bool
  description = "Enable private access to the EKS cluster endpoint."
  default     = true
}

variable "endpoint_public_access" {
  type        = bool
  description = "Enable public access to the EKS cluster endpoint."
  default     = true
}

variable "public_access_cidrs" {
  type        = list(string)
  description = "List of CIDR blocks that can access the EKS public endpoint."
  default     = ["0.0.0.0/0"]
}

variable "service_ipv4_cidr" {
  type        = string
  description = "CIDR block for Kubernetes service IP addresses."
  default     = "172.20.0.0/16"
}

variable "environment" {
  type        = string
  description = "Environment for which this EKS cluster is being created (e.g., dev, prod)."
}
