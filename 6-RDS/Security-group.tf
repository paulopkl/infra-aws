# Create a security group for public subnets
resource "aws_security_group" "database_security_group" {
  name   = "tier3-public-security-group"
  vpc_id = aws_vpc.tier3.id

  # Allow inbound traffic on port 5432
  dynamic "ingress" {
    for_each = [5432]

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
