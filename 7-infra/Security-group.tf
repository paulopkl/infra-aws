# A security group for the ELB so it is accessible via the web
resource "aws_security_group" "swarm_load_balancer" {
  name   = "securit-group-swarm-load-balancer"
  vpc_id = "${aws_vpc.swarm.id}"

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS access from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.aws_tags
}

# Create a security group for public subnets
# Security Group for Manager Nodes
resource "aws_security_group" "public_manager_nodes" {
  name   = "tier3-public-manager-nodes"
  vpc_id = aws_vpc.tier3.id

  # SSH for Ansible
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  # HTTP
  ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    security_groups = ["${aws_security_group.swarm_node.id}"]
    # cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    security_groups = ["${aws_security_group.swarm_node.id}"]
    # cidr_blocks = ["0.0.0.0/0"]
  }

  # Docker Swarm manager only
  ingress {
    description = "Docker Swarm management between managers"
    from_port   = 2377
    to_port     = 2377
    protocol    = "tcp"
    security_groups = ["${aws_security_group.swarm_node.id}"]
    # cidr_blocks = ["0.0.0.0/0"]
  }

  #   ingress {
  #     from_port   = 0
  #     to_port     = 0
  #     protocol    = -1
  #     self        = "false"
  #     cidr_blocks = ["0.0.0.0/0"]
  #     description = "any"
  #   }

  # Allow all outbound traffic to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.aws_tags
}

# Security Group for Worker Nodes
resource "aws_security_group" "private_worker_nodes" {
  name   = "tier3-private-security-group"
  vpc_id = aws_vpc.tier3.id

  # SSH for Ansible
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_blocks
  }

  # Docker Swarm ports from this security group only
  ingress {
    description = "Docker container network discovery"
    from_port   = 7946
    to_port     = 7946
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "Docker container network discovery"
    from_port   = 7946
    to_port     = 7946
    protocol    = "udp"
    self        = true
  }

  ingress {
    description = "Docker overlay network"
    from_port   = 4789
    to_port     = 4789
    protocol    = "udp"
    self        = true
  }

  # Allow all outbound traffic to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.aws_tags
}

# Security Group for Database
resource "aws_security_group" "private_rabbitmq" {
  name   = "private-rabbitmq"
  vpc_id = aws_vpc.tier3.id

  dynamic "ingress" {
    for_each = [22, 5672, 15672, 61613, 61614, 1883, 8883]

    content {
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
    }
  }


  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.aws_tags
}

resource "aws_security_group" "private_database_pg" {
  name   = "tier3-private-database-pg"
  vpc_id = aws_vpc.tier3.id

  ingress {
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.aws_tags
}
