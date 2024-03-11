# Configure the backend to store state file in an S3 bucket
terraform {
  required_version = "= 1.7.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.0"
    }
    pgp = {
      source  = "ekristen/pgp"
      version = "0.2.4"
    }
    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

provider "pgp" {
  # Configuration options
}

provider "local" {
  # Configuration options
}
