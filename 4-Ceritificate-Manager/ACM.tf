
locals {
  aws_services_aliases = toset([
    # "www.${var.aws_hosted_name}",
    "api.${var.aws_hosted_name}",
    "pg.${var.aws_hosted_name}",
    "keycloak.${var.aws_hosted_name}",
    "portainer.${var.aws_hosted_name}",
    "rabbitmq.${var.aws_hosted_name}"
  ])
}

# Get Hosted Zone
data "aws_route53_zone" "zone" {
  name = var.aws_hosted_name
}

# Create an ACM certificate
resource "aws_acm_certificate" "cert" {
  domain_name = data.aws_route53_zone.zone.name # "testing.example.com"
  subject_alternative_names = local.aws_services_aliases
  validation_method = "DNS"

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
  # depends_on = [
  #   aws_acm_certificate.cert,
  # ]

  # count = length(aws_acm_certificate.cert.domain_validation_options)

  # allow_overwrite = true

  # #   name    = tolist(aws_acm_certificate.cert.domain_validation_options)[0].resource_record_name
  # zone_id = data.aws_route53_zone.zone.zone_id
  # name    = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_name, count.index)
  # type    = element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_type, count.index)
  # records = [element(aws_acm_certificate.cert.domain_validation_options.*.resource_record_value, count.index)]

  count   = length(local.aws_services_aliases)

  zone_id = data.aws_route53_zone.zone.zone_id
  name    = local.aws_services_aliases[count.index]
  type    = "CNAME"
  ttl     = 300

  records = ["www.${var.aws_hosted_name}"]
}

resource "aws_acm_certificate_validation" "example" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = aws_route53_record.cert_dns.*.fqdn
}

output "name" {
  value = aws_acm_certificate.cert.domain_validation_options
}
