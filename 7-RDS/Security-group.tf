# Create a security group for public subnets
resource "aws_security_group" "database_security_group" {
  depends_on = [
    data.aws_vpc.vq
  ]

  name   = "database-private-security-postgres"
  description = "Security group for PostgreSQL Database"

  vpc_id = data.aws_vpc.vq.id

  # ingress {
  #   description = "Port to connect to Database"
  #   from_port   = 5432
  #   to_port     = 5432
  #   protocol    = "tcp"
  #   cidr_blocks = [data.aws_vpc.vq.cidr_block]
  # }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = "false"
    cidr_blocks = ["0.0.0.0/0"]
    description = "any"
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
