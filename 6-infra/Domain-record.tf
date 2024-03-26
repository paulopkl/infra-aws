
locals {
  aws_domain_names = toset([
    var.aws_domain_name,
    "www.${var.aws_domain_name}",
  ])
  aws_services_aliases = toset([
    "api.${var.aws_domain_name}",
    "pg.${var.aws_domain_name}",
    "keycloak.${var.aws_domain_name}",
    "portainer.${var.aws_domain_name}",
    "rabbitmq.${var.aws_domain_name}",
  ])
}

resource "aws_route53_record" "alb_record" {
  depends_on = [
    aws_lb.swarm_managers
  ]

  for_each = local.aws_domain_names

  zone_id = data.aws_route53_zone.zone.id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_lb.swarm_managers.dns_name
    zone_id                = aws_lb.swarm_managers.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "server_aliases" {
  depends_on = [
    aws_lb.swarm_managers
  ]

  for_each = local.aws_services_aliases

  zone_id = data.aws_route53_zone.zone.id
  name    = each.value
  # type    = "A"
  # ttl     = 60
  type = "CNAME"
  ttl  = 300

  records = ["www.${var.aws_domain_name}"]

  # records = [aws_lb.swarm_managers.dns_name]

  # alias {
  #   name                   = aws_lb.swarm_managers.dns_name
  #   zone_id                = aws_lb.swarm_managers.zone_id
  #   evaluate_target_health = true
  # }
}
