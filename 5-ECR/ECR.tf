resource "aws_ecr_repository" "ecr" {
  for_each             = toset(var.ecr_name)
  name                 = each.key             # ["backend_service"]
  image_tag_mutability = var.image_mutability # IMMUTABLE | MUTABLE
  force_delete         = false                # true

  encryption_configuration {
    encryption_type = var.encrypt_type # KMS | AES256
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = var.tags
}

output "aws_ecr_repository" {
  value = [for ecr in aws_ecr_repository.ecr : ecr.repository_url]
}
