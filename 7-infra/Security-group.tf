# Create a security group for public subnets
resource "aws_security_group" "public_security_group" {
  name   = "tier3-public-security-group"
  vpc_id = aws_vpc.tier3.id

  # Allow inbound traffic on ports 80 and 443
  dynamic "ingress" {
    for_each = [22, 80, 443]

    content {
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
    }
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

resource "aws_security_group" "private_security_group" {
  name   = "tier3-private-security-group"
  vpc_id = aws_vpc.tier3.id

  dynamic "ingress" {
    for_each = [22]

    content {
      protocol    = "tcp"
      from_port   = ingress.value
      to_port     = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
    }
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
