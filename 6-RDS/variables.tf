variable "aws_profile_name" {
  type    = string
  default = "admin"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to use to create resources."
  default     = "us-east-1"
}

variable "aws_tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default = {
    Name        = "tier_3"
    Environment = "Prod"
  }
}

### Database Configs
variable "db_multi_az_deployment" {
  description = ""
  type        = bool
  default     = true
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "db_nm"
}

variable "db_username" {
  type        = string
  description = "Database user name"
  default     = "admin"
}

variable "db_password" {
  type        = string
  description = "Database user password"
  default     = "@dmin12345"
}