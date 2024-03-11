data "aws_acm_certificate" "dns_certificate" {
  domain      = var.aws_domain_name
  most_recent = true
}

# Listener for HTTP
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.swarm_managers.id
  port              = 80
  protocol          = "HTTP"
  depends_on = [
    aws_lb_target_group.swarm_managers
  ]

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Listener for HTTPS
# Attach the ACM certificate to the ALB
resource "aws_lb_listener" "https" {
  depends_on = [
    aws_lb_target_group.swarm_managers
  ]

  load_balancer_arn = aws_lb.swarm_managers.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  certificate_arn = data.aws_acm_certificate.dns_certificate.arn

  default_action {
    target_group_arn = aws_lb_target_group.swarm_managers.arn
    type             = "forward"
  }
}

# Attach the ACM certificate to the ALB
resource "aws_lb_listener_certificate" "https_additional_certs" {
  listener_arn    = aws_lb_listener.https.arn
  certificate_arn = data.aws_acm_certificate.dns_certificate.arn
}
