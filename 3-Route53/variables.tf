variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_profile_name" {
  type    = string
  default = "admin"
}

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

variable "aws_hosted_name" {
  type    = string
  default = "teste-application.com"
}
