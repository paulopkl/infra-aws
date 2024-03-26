variable "aws_region" {
  type        = string
  description = "The AWS region to use to create resources."
  default     = "us-east-1"
}

# variable "aws_profile_name" {
#   type    = string
#   default = "admin"
# }

variable "aws_user_access_key" {
  type        = string
  description = "The AWS User Access Key."
  default     = "AKIAVARCT74LVPNKTLYD"
}

variable "aws_secret_access_key" {
  type        = string
  description = "The AWS User Secret Key."
  default     = "6RibDQYdReta5D0YRNMHcLmsYHZb1wIGssFb6PFN"
}

variable "aws_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "ssh_cidr_blocks" {
  type    = string
  default = "0.0.0.0/0"
}

variable "aws_tags" {
  default = {
    Name = "Tier 3"
  }
}

variable "aws_vpc_tags" {
  default = {
    Name = "Tier 3"
    Environment = "Prod"
    Company = "Veridiana-Quirino"
  }
}

variable "aws_manager_instance_type" {
  type    = string
  default = "t3.micro"
}

variable "aws_worker_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "aws_rabbitmq_instance_type" {
  type    = string
  default = "t3.large"
}

variable "ssh_key_name" {
  type    = string
  default = "tier3-ssh"
}

variable "aws_public_subnets" {
  type    = number
  default = 2
}

variable "aws_private_subnets" {
  type    = number
  default = 3
}

variable "aws_hosted_name" {
  type    = string
  default = "teste-application.com"
}

variable "aws_domain_name" {
  type    = string
  default = "teste-application.com"
}

variable "aws_ecr_prefix" {
  type    = string
  default = "344743739159.dkr.ecr.us-east-1.amazonaws.com"
}
