resource "aws_route53_zone" "hosted_zone" {
  name = var.aws_hosted_name # "teste-application.com"
  comment = "Hosted for Veridiana Quirino domain"

  tags = {
    Name = "Veridiana Quirino"
  }
}

output "name" {
  value = aws_route53_zone.hosted_zone
}
