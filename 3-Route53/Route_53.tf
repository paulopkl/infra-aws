# resource "aws_elb" "tier3" {
#   name               = "foobar-terraform-elb"
#   availability_zones = ["us-east-1c"]

  

#   listener {
#     instance_port     = 80
#     instance_protocol = "http"
#     lb_port           = 80
#     lb_protocol       = "http"
#   }

#   tags = var.aws_tags
# }

resource "aws_route53_zone" "hosted_zone" {
  name = var.aws_domain_name # "www.lojaplus-web.com"

  tags = var.aws_tags
}

# data "aws_route53_zone" "hosted_zone" {
#     name = "paulo-k8s.com"
# }

# resource "aws_route53_record" "RECORDNAME" {
#   zone_id = data.aws_route53_zone.hosted_zone.id
#   name    = "www.example.com" # "RECORDNAME.abc.com" # www
#   type    = "A"
#   #   ttl = 300
#   #   records = [aws_eip.lb.public_ip]

#   alias {
#     name                   = aws_elb.tier3.dns_name # "ELB_NAME"
#     zone_id                = aws_elb.tier3.zone_id # "ELB_HOSTED_ZONE"
#     evaluate_target_health = true
#   }
# }

# data "aws_route53_zone" "portfolio_paulo" {
#     name = "portfolio-paulo.com"
# }

# # data "aws_route53_record" "asdsa" {
# #     name = data.aws_route53_zone.portfolio_paulo.name
# #     type = "CNAME"
# # }

# output "name" {
#   value = data.aws_route53_zone.portfolio_paulo
# }
