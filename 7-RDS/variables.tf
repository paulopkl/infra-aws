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

variable "aws_tags" {
  description = "The key-value maps for tagging"
  type        = map(string)
  default = {
    Name        = "pg-keycloak-database"
    Environment = "Prod"
  }
}

variable "db_availability_zone" {
  description = "The key-value maps for tagging"
  type        = string
  default     = "us-east-1c"
}

### Database Configs
variable "db_multi_az_deployment" {
  type        = bool
  description = "Active multi-region database"
  default     = false
}

variable "db_instance_type" {
  type        = string
  description = "Database name"
  default     = "db.t3.xlarge"
}

variable "db_name" {
  type        = string
  description = "Database name"
  default     = "keycloak"
}

variable "db_username" {
  type        = string
  description = "Database user name"
  default     = "veridiana_quirino"
}

variable "db_password" {
  type        = string
  description = "Database user password"
  default     = "Admin12345"
}

variable "aws_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "aws_vpc_tags" {
  default = {
    Name        = "Tier 3"
    Environment = "Prod"
    Company     = "Veridiana-Quirino"
  }
}
