# Create a Network ACL for the NAT Gateway
resource "aws_network_acl" "nat_gateway" {
  vpc_id = aws_vpc.vq.id

  # Ingress rules
  # ingress {
  #   protocol   = "tcp"
  #   rule_no    = 100
  #   action     = "allow"
  #   cidr_block = "0.0.0.0/0" # Allow all inbound traffic
  #   from_port  = 22          # Adjust as needed
  #   to_port    = 65535       # Adjust as needed
  # }

  # ingress {
  #   protocol   = "udp"
  #   rule_no    = 101
  #   action     = "allow"
  #   cidr_block = "0.0.0.0/0" # Allow all inbound traffic
  #   from_port  = 22          # Adjust as needed
  #   to_port    = 65535       # Adjust as needed
  # }

  # ingress {
  #   protocol   = "udp"
  #   rule_no    = 101
  #   action     = "allow"
  #   cidr_block = "0.0.0.0/0" # Allow all inbound traffic
  #   from_port  = 22          # Adjust as needed
  #   to_port    = 65535       # Adjust as needed
  # }

  # # Egress rules
  # egress {
  #   protocol   = "-1" # Allow all outbound traffic
  #   rule_no    = 100
  #   action     = "allow"
  #   cidr_block = "0.0.0.0/0" # Allow all outbound traffic
  #   from_port  = 0           # Required for egress rule
  #   to_port    = 0           # Required for egress rule
  # }

  # Creating a rule for inbound traffic
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Represents all protocols
    action      = "allow"
    cidr_block  = "0.0.0.0/0"  # Allow traffic from any source
    rule_no = 100
  }

  # Creating a rule for outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # Represents all protocols
    action      = "allow"
    cidr_block  = "0.0.0.0/0"  # Allow traffic to any destination
    rule_no = 100
  }

  # Associate this NACL with the subnet(s) where your NAT Gateway resides
  subnet_ids = [
    # aws_subnet.private[0].id,
    # aws_subnet.private[1].id,
    # aws_subnet.private[2].id
    # for subnet in aws_subnet.private : subnet.id
  ] # Adjust as needed
}
