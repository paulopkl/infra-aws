variable "aws_profile_name" {
  type    = string
  default = "admin"
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

variable "aws_ec2_instance_type" {
  default = "t2.micro"
}

variable "ssh_key_name" {
  default = "tier3-ssh"
}

variable "aws_public_subnets" {
  default = 1
}

variable "aws_private_subnets" {
  default = 1
}
