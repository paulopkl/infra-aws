# Configure the backend to store state file in an S3 bucket
terraform {
  required_version = "= 1.7.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.0"
    }
  }

  # backend "s3" {
  #   bucket =  "paulopkl-terraform-state"
  #   key    = "tfstate/certificate-manager/terraform.tfstate" # "path/to/your/state/file.tfstate"
  #   region = "us-east-1"
  #   # You may specify other configurations like encryption, dynamodb table, etc.
  # }
}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile_name
}
