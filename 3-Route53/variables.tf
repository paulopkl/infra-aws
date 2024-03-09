variable "aws_tfstate_bucket_name" {
  default = "paulopkl-terraform-state"
}

variable "aws_region" {
  default = "us-east-1"
}

variable "aws_cidr_block" {
  default = "10.0.0.0/16"
}

variable "aws_tags" {
  default = {
    Name = "Tier 3"
  }
}

variable "aws_domain_name" {
  default = "lojaplus-web.com"
}
