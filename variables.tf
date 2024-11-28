variable "node_role_arn" {
  type    = string
  default = "arn:aws:iam::1234567890:role/default_node_role_arn"  # Substitua por um valor adequado para o seu ambiente
}

variable "role_eks" {
  type    = string
  default = "arn:aws:iam::1234567890:role/custom_metrics_test_eksCluster_role"
}

variable "encryption_kms_arn" {
  type    = string
  default = "arn:aws:kms-us-east-1:1234567890:key/xxxxxxxx-xxxx-xxxx-xxxxx-xxxxxx"
}

variable "code_build_role" {
  type    = string
  default = "arn:aws:iam::1234567890:role/metrics_test_ServiceRoleCodeBuild-role"
}

variable "subnet_ids" {
  type = map(list(string))
  default = {
    "test" = ["subnet-1234567890", "subnet-0987654321"]
  }
}

variable "subnet_ids_nodes" {
  type = map(list(string))
  default = {
    "test"   = ["subnet-1234567890", "subnet-0987654321"],
    "test-a" = ["subnet-1234567890", "subnet-0987654321"],
    "test-b" = ["subnet-2234567890", "subnet-2987654321"],
    "test-c" = ["subnet-3234567890", "subnet-3987654321"]
  }
}

variable "cidr_blocks" {
  type = map(list(string))
  default = {
    "test" = ["200.9.199.0/24"]
  }
}

variable "worker_role_arn" {
  type    = string
  default = "arn:aws:iam::1234567890:role/custom_metrics_test_EksWorkerNode_role"
}

variable "vpc_id" {
  type = map(string)
  default = {
    "test" = "sg-xpto1234567890"
  }
}

variable "allowed_cidr_blocks" {
  type = list(string)
  description = "List of CIDR blocks allowed for egress traffic"
  default = ["10.0.0.0/16"] # Replace with your internal CIDR range
}


variable "public_access_cidrs" {
  type = list(string)
  default = [
    "200.9.199.0/24"
  ]
}

variable "worker_fargate_role_arn" {
  type    = string
  default = "arn:aws:iam::1234567890:role/custom_services_eks_role"
}

variable "sso_role" {
  type    = string
  default = "arn:aws:iam::1234567890:role/AWSReservedSSO_METRICS_PWR_xxxxxxxxxxxx"
}

variable "tags" {
  type = map(string)
  default = {
    Name = ""
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "s3_bucket" {
  type    = string
  default = "terraform-state-bucket-test"
}

variable "dynamodb_table" {
  type    = string
  default = "terraform-state-lock-test"
}

variable "environment" {
  type    = string
  default = "test"
}

variable "metrics_role_arn" {
  type = string
}

