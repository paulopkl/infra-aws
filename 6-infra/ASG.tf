## MANAGER NODES
# Spread placement group for Swarm manager nodes
resource "aws_placement_group" "swarm_manager_nodes" {
  name     = "placement-group-swarm-manager-nodes"
  strategy = "spread"
}

## WORKER NODES
# Spread placement group for Swarm worker nodes
resource "aws_placement_group" "swarm_worker_nodes" {
  name     = "placement-group-swarm-worker-nodes"
  strategy = "spread"
}

# Swarm MANAGER nodes auto-scaling group
resource "aws_autoscaling_group" "swarm_manager_nodes" {
  depends_on = [
    aws_subnet.public,
    aws_launch_template.swarm_manager_node,
    aws_lb.swarm_managers
  ]

  name = "auto-scaling-swarm-manager-nodes"

  # Configuration
  min_size         = 0
  desired_capacity = 2
  max_size         = 2

  # Network
  vpc_zone_identifier = aws_subnet.public.*.id
  placement_group     = aws_placement_group.swarm_manager_nodes.id
  #   load_balancers      = [aws_lb.swarm_managers.id]
  # Attach the ALB target group ARN to the Auto Scaling Group
  target_group_arns = [
    aws_lb_target_group.swarm_managers.arn
  ]

  launch_template {
    id      = aws_launch_template.swarm_manager_node.id
    version = aws_launch_template.swarm_manager_node.latest_version
  }

  #   launch_configuration = aws_launch_configuration.swarm_manager_node.id

  # Instance Refresh
  instance_refresh {
    strategy = "Rolling"

    preferences {
      #instance_warmup = 300 # Default behavior is to use the Auto Scaling Group's health check grace period.
      min_healthy_percentage = 95
    }

    triggers = [/*"launch_template",*/ "desired_capacity"] # You can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger
  }

  tag {
    key                 = "Name"
    value               = "auto-scaling-swarm-manager-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "Production"
    propagate_at_launch = true
  }

  tag {
    key                 = "node-type"
    value               = "manager" # we use this tag to output instances IPs
    propagate_at_launch = true
  }
}

# Swarm WORKER nodes auto-scaling group
resource "aws_autoscaling_group" "swarm_worker_nodes" {
  depends_on = [
    aws_subnet.private,
    aws_launch_template.swarm_worker_node,
    aws_lb.swarm_managers
  ]

  name = "auto-scaling-swarm-worker-nodes"

  # Configuration
  min_size         = 0
  desired_capacity = 2
  max_size         = 2

  # Network
  vpc_zone_identifier = aws_subnet.private.*.id
  placement_group     = aws_placement_group.swarm_worker_nodes.id

  # launch_configuration = aws_launch_configuration.swarm_worker_node.id
  launch_template {
    id      = aws_launch_template.swarm_worker_node.id
    version = aws_launch_template.swarm_worker_node.latest_version
  }

  instance_refresh {
    strategy = "Rolling"

    preferences {
      #instance_warmup = 300 # Default behavior is to use the Auto Scaling Group's health check grace period.
      min_healthy_percentage = 95
    }

    triggers = [/*"launch_template",*/ "desired_capacity"] # You can add any argument from ASG here, if those has changes, ASG Instance Refresh will trigger
  }

  tag {
    key                 = "Name"
    value               = "auto-scaling-swarm-worker-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = "Production"
    propagate_at_launch = true
  }

  tag {
    key                 = "node-type"
    value               = "worker" # we use this tag to output instances IPs
    propagate_at_launch = true
  }
}
