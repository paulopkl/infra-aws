# Get Hosted Zone
data "aws_route53_zone" "zone" {
  name = var.aws_hosted_name
}

# Create an ACM certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = data.aws_route53_zone.zone.name # "testing.example.com"
  validation_method = "DNS"                           // EMAIL

  # validation_option {
  #   domain_name       = "testing.example.com"
  #   validation_domain = "example.com"
  # }

  #   lifecycle {
  #     create_before_destroy = true
  #   }

  tags = var.aws_tags
}

# Create a DNS record for ACM certificate validation
resource "aws_route53_record" "cert_dns" {
  depends_on = [
    aws_acm_certificate.cert
  ]

  allow_overwrite = true

  name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.zone.zone_id
  records = [tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_value]
  ttl     = 60
}

output "name" {
  value = aws_acm_certificate.cert.domain_validation_options
}
