variable "aws_region" {
  type        = string
  description = "The AWS region to use to create resources."
  default     = "us-east-1"
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

#======================================================
variable "ecr_name" {
  description = "The name of the ECR registry"
  type        = set(string)
  default = [
    "backend_service",
    # "frontend_service",
    # "golang_microservice_service",
  ]
}

variable "image_mutability" {
  description = "Provide image mutability"
  type        = string
  default     = "MUTABLE"
}

variable "encrypt_type" {
  description = "Provide type of encryption here"
  type        = string
  default     = "KMS"
}

variable "tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default = {
    Name        = "tier_3"
    Environment = "Prod"
  }
}
