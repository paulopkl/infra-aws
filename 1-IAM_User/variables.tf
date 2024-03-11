variable "aws_region" {
  default = "us-east-1"
}

variable "aws_profile" {
  default = "root"
}

variable "aws_iam_user_username" {
  default = "administrator-vq"
}

variable "aws_tags" {
  default = {
    Name = "Tier 3"
  }
}
