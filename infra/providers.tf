# in terraform block no variables can be used
terraform {
  required_version = ">= 0.12.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.4.2"
    }
  }
}


# Configure AWS Provider
provider "aws" {
  region  = var.region
  profile = var.aws_profile //pick waht AWS account you want to connect
}