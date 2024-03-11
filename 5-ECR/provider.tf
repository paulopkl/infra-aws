terraform {
  required_version = "= 1.7.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.39.0"
    }
  }

  backend "s3" {
    bucket = "paulopkl-terraform-state"
    key    = "tfstate/ecr/terraform.tfstate" # "path/to/your/state/file.tfstate"
    region = "us-east-1"
    # You may specify other configurations like encryption, dynamodb table, etc.
  }
}

provider "aws" {
  region = var.aws_region
  #   profile = var.aws_profile_name
  access_key = var.aws_user_access_key
  secret_key = var.aws_secret_access_key
}
