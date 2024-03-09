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
  name                 = "auto-scaling-swarm-manager-nodes"
  launch_configuration = aws_launch_configuration.swarm_manager_node.id

  # Configuration
  min_size             = 1
  desired_capacity     = 2
  max_size             = 2

  # Network
  vpc_zone_identifier  = aws_subnet.swarm_nodes.*.id
  placement_group      = aws_placement_group.swarm_manager_nodes.id
  load_balancers       = [aws_elb.swarm.id]

  tag {
    key                 = "Name"
    value               = "auto-scaling-swarm-manager-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "tads-environment"
    value               = "Production"
    propagate_at_launch = true
  }

  tag {
    key                 = "tads-node-type"
    value               = "manager" # we use this tag to output instances IPs
    propagate_at_launch = true
  }
}

# Swarm WORKER nodes auto-scaling group
resource "aws_autoscaling_group" "swarm_worker_nodes" {
  min_size             = 2
  desired_capacity     = 2
  max_size             = 2
  launch_configuration = aws_launch_configuration.swarm_worker_node.id
  name                 = "auto-scaling-swarm-worker-nodes"
  vpc_zone_identifier  = "${aws_subnet.swarm_nodes.*.id}"
  placement_group      = "${aws_placement_group.swarm_worker_nodes.id}"

  tag {
    key                 = "Name"
    value               = "auto-scaling-swarm-worker-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "tads-environment"
    value               = "Production"
    propagate_at_launch = true
  }

  tag {
    key                 = "tads-node-type"
    value               = "worker" # we use this tag to output instances IPs
    propagate_at_launch = true
  }
}
