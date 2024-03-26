# Create an Application Load Balancer
# Layer 4, no SSL termination, since it is handled by Traefik
resource "aws_lb" "swarm_managers" {
  name               = "production-swarm-managers"
  internal           = false
  load_balancer_type = "application"

  # Network
  subnets = [for subnet in aws_subnet.public : subnet.id]
  security_groups = [
    aws_security_group.swarm_load_balancer.id
  ]

  #   listener {
  #     instance_port     = 80
  #     instance_protocol = "tcp"
  #     lb_port           = 80
  #     lb_protocol       = "tcp"
  #   }

  #   listener {
  #     instance_port     = 443
  #     lb_port           = 443
  #     instance_protocol = "tcp"
  #     lb_protocol       = "tcp"
  #   }

  enable_deletion_protection = false # Set to true if you want to enable deletion protection
}

# Create a target group for the ALB
resource "aws_lb_target_group" "swarm_managers" {
  name     = "target-group-for-swarm" # var.name
  port     = 80                       # var.container_port
  protocol = "HTTP"
  vpc_id   = aws_vpc.vq.id
  #   target_type = "ip"

  health_check {
    path                = "/" # var.health_check_path
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 30
    interval            = 60
    matcher             = "200"
  }
}

# Attach the target group to the ALB
# resource "aws_lb_target_group_attachment" "example" {
#   target_group_arn = aws_lb_target_group.swarm_managers.arn
#   target_id        = aws_autoscaling_group.swarm_manager_nodes.id
# }
