resource "aws_iam_user" "iamuser" {
  name = var.aws_iam_user_username
}

# resource "aws_iam_policy" "restricted_policy" {
#   name        = "restricted_policy"
#   description = "Policy to restrict user access to us-east-1"
#   policy      = <<EOF
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "*"
#             ],
#             "Resource": "*",
#             "Condition": {
#                 "StringEquals": {
#                     "aws:RequestedRegion": "us-east-1"
#                 }
#             }
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "iam:ChangePassword"
#             ],
#             "Resource": [
#                 "arn:aws:iam::*:user/$${aws:username}"
#             ]
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "iam:GetAccountPasswordPolicy"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "s3:ListAllMyBuckets",
#                 "s3:GetBucketLocation",
#                 "s3:ListBucket",
#                 "s3:GetBucketPolicy",
#                 "s3:GetObject",
#                 "s3:PutObject",
#                 "s3:DeleteObject"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:Describe*",
#                 "ec2:List*"
#             ],
#             "Resource": "*"
#         },
#          {
#             "Effect": "Allow",
#             "Action": [
#                 "rds:Describe*"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "route53:Get*",
#                 "route53:List*"
#             ],
#             "Resource": "*"
#         },
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "acm:Describe*",
#                 "acm:Get*",
#                 "acm:List*"
#             ],
#             "Resource": "*"
#         }
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ecr:GetAuthorizationToken",
#                 "ecr:GetDownloadUrlForLayer",
#                 "ecr:BatchCheckLayerAvailability",
#                 "ecr:BatchGetImage",
#                 "ecr:GetLifecyclePolicy",
#                 "ecr:GetRepositoryPolicy",
#                 "ecr:DescribeRepositories",
#                 "ecr:ListImages"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
# EOF
# }

output "user_arn" {
  value = aws_iam_user.iamuser.arn
}

resource "aws_iam_user_policy_attachment" "admin_administrator_access" {
  user       = aws_iam_user.iamuser.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_policy_attachment" "iam_user_change_password" {
  user       = aws_iam_user.iamuser.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}
