variable "aws_profile_name" {
  type    = string
  default = "admin"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to use to create resources."
  default     = "us-east-1"
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

variable "bucket_name" {
  description = "(required since we are not using 'bucket') Creates a unique bucket name beginning with the specified prefix. Conflicts with bucket."
  default     = "paulopkl-terraform-state"
}

variable "aws_tags" {
  default = {
    Name = "Tier 3"
  }
}

#########

variable "bucket_s3_tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags to assign to the bucket."
  default     = {}
}

variable "acl" {
  type        = string
  description = " Defaults to private "
  default     = "private"
}

variable "bucket_force_destroy" {
  description = ""
  type        = bool
  default     = false
}

variable "attach_policy" {
  description = ""
  type        = bool
  default     = "false"
}

variable "s3_block_public_acls" {
  description = "s3_block_public_acls"
  type        = bool
  default     = true
}

variable "s3_block_public_policy" {
  description = "s3_block_public_policy"
  type        = bool
  default     = true
}

variable "s3_ignore_public_acls" {
  description = "s3_ignore_public_acls"
  type        = bool
  default     = true
}

variable "s3_restrict_public_buckets" {
  description = "s3_restrict_public_buckets"
  type        = bool
  default     = true
}

variable "acceleration_status" {
  description = "Enable / Suspended s3 transfer acceleration"
  type        = string
  default     = "Suspended"
}

variable "s3_acl" {
  description = "acl access"
  type        = string
  default     = "private"
}

variable "versioning" {
  description = "versioning config"
  type        = string
  default     = "Enabled"
}
