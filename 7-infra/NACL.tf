# Create a Network ACL for the NAT Gateway
resource "aws_network_acl" "nat_gateway" {
  vpc_id = aws_vpc.tier3.id

   # Ingress rules
  ingress {
    protocol   = "tcp"
    rule_no = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"  # Allow all inbound traffic
    from_port  = 22  # Adjust as needed
    to_port    = 65535  # Adjust as needed
  }

  ingress {
    protocol   = "udp"
    rule_no = 101
    action     = "allow"
    cidr_block = "0.0.0.0/0"  # Allow all inbound traffic
    from_port  = 22  # Adjust as needed
    to_port    = 65535  # Adjust as needed
  }

  # Egress rules
  egress {
    protocol   = "-1"  # Allow all outbound traffic
    rule_no = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"  # Allow all outbound traffic
    from_port  = 0  # Required for egress rule
    to_port    = 0  # Required for egress rule
  }

  # Associate this NACL with the subnet(s) where your NAT Gateway resides
  subnet_ids = [
    # aws_subnet.private[0].id,
    # aws_subnet.private[1].id,
    # aws_subnet.private[2].id
    for subnet in aws_subnet.private : subnet.id
  ] # Adjust as needed
}
