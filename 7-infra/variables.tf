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

variable "ssh_cidr_blocks" {
  default = "0.0.0.0/0"
}

variable "aws_tags" {
  default = {
    Name = "Tier 3"
  }
}

variable "aws_manager_instance_type" {
  default = "t3.micro"
}

variable "aws_worker_instance_type" {
  default = "t3.medium"
}

variable "aws_rabbitmq_instance_type" {
  default = "t3.large"
}

variable "ssh_key_name" {
  default = "tier3-ssh"
}

variable "aws_public_subnets" {
  default = 2
}

variable "aws_private_subnets" {
  default = 3
}
