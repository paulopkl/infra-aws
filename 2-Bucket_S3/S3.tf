# Create an S3 bucket
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket_name  # Replace with your desired bucket name
  
  force_destroy = var.bucket_force_destroy

  object_lock_enabled = true

  tags          = var.bucket_s3_tags
}

### PRIVATE
resource "aws_s3_bucket_ownership_controls" "tier3" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

### PUBLIC
# resource "aws_s3_bucket_public_access_block" "public_access_block" {
#   bucket                  = aws_s3_bucket.s3_bucket.id

#   block_public_acls       = var.s3_block_public_acls
#   block_public_policy     = var.s3_block_public_policy
#   ignore_public_acls      = var.s3_ignore_public_acls
#   restrict_public_buckets = var.s3_restrict_public_buckets
# }

# Access control list (ACL) for the bucket, default is "private"
resource "aws_s3_bucket_acl" "acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.tier3
  ]

  bucket = aws_s3_bucket.s3_bucket.id
  acl    = var.acl # If "aws_s3_bucket_public_access_block" is setted it must to be "public-read"
}

# resource "aws_s3_bucket_versioning" "bucket_versioning" {
#   bucket = aws_s3_bucket.s3_bucket.id

#   versioning_configuration {
#     status = var.versioning
#   }
# }

# resource "aws_s3_bucket_accelerate_configuration" "accelerate_configuration" {
#   bucket = aws_s3_bucket.s3_bucket.id
#   status = var.acceleration_status
# }

output "s3_bucket_name" {
  value = aws_s3_bucket.s3_bucket.id
}
