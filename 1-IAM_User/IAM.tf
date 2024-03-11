# "arn:aws:iam::344743739159:user/administrator-vq"
resource "aws_iam_user" "iamuser" {
  name = var.aws_iam_user_username
  #   permissions_boundary = ""
}

resource "pgp_key" "user_login_key" {
  name    = aws_iam_user.iamuser.name
  email   = "palmeida.ipms@gmail.com"
  comment = "Generated PGP Key"
}

resource "aws_iam_user_login_profile" "user_login" {
  depends_on = [
    aws_iam_user.iamuser,
    pgp_key.user_login_key
  ]

  user                    = aws_iam_user.iamuser.name
  pgp_key                 = pgp_key.user_login_key.public_key_base64
  password_length         = 8
  password_reset_required = false

  lifecycle {
    ignore_changes = [password_reset_required]
  }
}

data "pgp_decrypt" "user_password_decrypt" {
  ciphertext          = aws_iam_user_login_profile.user_login.encrypted_password
  ciphertext_encoding = "base64"
  private_key         = pgp_key.user_login_key.private_key
}

resource "aws_iam_access_key" "iam_access_key" {
  user = aws_iam_user.iamuser.name
  #   pgp_key = pgp_key.user_login_key.public_key_base64
  status = "Active"
}

resource "local_file" "example" {
  filename = "./${var.aws_iam_user_username}" # Specify the path where you want to create the file
  content  = <<-EOT
    [${var.aws_iam_user_username}]
    aws_access_key_id = ${aws_iam_access_key.iam_access_key.id}
    aws_secret_access_key = ${aws_iam_access_key.iam_access_key.secret}
EOT
}

output "credentials" {
  value = {
    "key"      = aws_iam_access_key.iam_access_key.id
    "secret"   = aws_iam_access_key.iam_access_key.secret
    "password" = data.pgp_decrypt.user_password_decrypt.plaintext
  }
  sensitive = true
}

resource "aws_iam_user_policy_attachment" "admin_administrator_access" {
  user       = aws_iam_user.iamuser.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_policy_attachment" "iam_user_change_password" {
  user       = aws_iam_user.iamuser.name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
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
