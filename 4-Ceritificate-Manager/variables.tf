variable "aws_profile_name" {
  type    = string
  default = "admin"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to use to create resources."
  default     = "us-east-1"
}
