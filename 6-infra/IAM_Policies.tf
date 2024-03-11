######## Create IAM Policies
# Define the IAM policy
resource "aws_iam_policy" "ecr_and_cloudtrail" {
  name        = "ECRAndCloudTrailPolicy"
  description = "Allows ECR actions and CloudTrail event lookup"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Resource = "*",
        Action = [
          "ecr:*",
          "cloudtrail:LookupEvents"
          #   "ecr:GetAuthorizationToken",
          #   "ecr:BatchCheckLayerAvailability",
          #   "ecr:GetDownloadUrlForLayer",
          #   "ecr:GetRepositoryPolicy",
          #   "ecr:DescribeRepositories",
          #   "ecr:ListImages"
        ],
      }
    ]
  })

  tags = var.aws_tags
}

# Define IAM policy allowing S3 access
resource "aws_iam_policy" "s3_access" {
  name        = "S3AccessPolicy"
  description = "Allows access to Amazon S3"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
          # "s3:Get*",
          # "s3:List*",
          # "s3:Describe*",
          # "s3-object-lambda:Get*",
          # "s3-object-lambda:List*"
        ],
        # Resource  = ["arn:aws:s3:::your_bucket_name/*", "arn:aws:s3:::your_bucket_name"]
        Resource = "*"
      }
    ]
  })

  tags = var.aws_tags
}
########

######## Create IAM role
resource "aws_iam_role" "ec2_role" {
  name = "EC2Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        },
      }
    ]
  })
}
########

######## IAM Attach Policy to Role
# Attach IAM policies to the IAM role
resource "aws_iam_role_policy_attachment" "ecr_access_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ecr_and_cloudtrail.arn
}

resource "aws_iam_role_policy_attachment" "s3_access_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}
########

######## IAM Profile Instance
# Create IAM instance profile and associate the IAM role with it
resource "aws_iam_instance_profile" "tier3" {
  name = "EC2InstanceProfile"
  role = aws_iam_role.ec2_role.name
}
