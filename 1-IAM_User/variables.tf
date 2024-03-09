variable "aws_region" {
  default = "us-east-1"
}

variable "aws_cidr_block" {
  default = "10.0.0.0/24"
}

variable "aws_tags" {
  default = {
    Name = "Tier 3"
  }
}

variable "aws_iam_user_username" {
  default = "administrator-vq"
}