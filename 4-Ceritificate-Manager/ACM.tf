data "aws_route53_zone" "zone" {
  name = "portfolio-paulo.com"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = data.aws_route53_zone.zone.name # "example.com" # "testing.example.com"
  validation_method = "DNS"
  # validation_method = "EMAIL"

  # validation_option {
  #   domain_name       = "testing.example.com"
  #   validation_domain = "example.com"
  # }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = "test"
  }
}
