# Configure the backend to store state file in an S3 bucket
terraform {
  required_version = "= 1.7.4"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.39.0"
    }
  }

#   backend "s3" {
#     bucket = "your_bucket_name"
#     key    = "path/to/your/state/file.tfstate"
#     region = var.aws_region
#     # You may specify other configurations like encryption, dynamodb table, etc.
#   }
}

# Configure the AWS provider
provider "aws" {
  region = var.aws_region
  profile = "admin"
}
