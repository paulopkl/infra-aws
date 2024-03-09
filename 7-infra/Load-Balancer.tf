# The ELB (Classic)
# Layer 4, no SSL termination, since it is handled by Traefik
resource "aws_elb" "swarm" {
  name = "production-swarm"

  subnets         = [
    aws_subnet.public.*.id
  ]
  security_groups = [
    aws_security_group.swarm_load_balancer.id
  ]

  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }

  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }
}
