terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.4.1"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
backend "s3" {
  bucket         = "terraform-state-bucket-test"
  key            = "test/terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-state-lock-test"
  encrypt        = true
}

}

provider "aws" {
  assume_role {
    role_arn = var.metrics_role_arn
  }
  region = var.aws_region
}

# Define um alias fixo ao invés de usar variáveis diretamente
provider "kubernetes" {
  alias                  = "test"  # Substitua "test" pelo ambiente desejado
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

