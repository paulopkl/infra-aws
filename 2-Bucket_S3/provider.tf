# Configure the backend to store state file in an S3 bucket
terraform {
  required_version = "= 1.7.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.0"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = var.aws_region
  #   profile = var.aws_profile_name
  access_key = var.aws_user_access_key
  secret_key = var.aws_secret_access_key
}
