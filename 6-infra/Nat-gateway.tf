# Allocate an Elastic IP for the NAT Gateway
resource "aws_eip" "tier3" {
  # depends_on                = [aws_internet_gateway.terraform-lab-igw]

  # associate_with_private_ip = "10.0.0.5"

  vpc = true # Allocate the Elastic IP in the VPC
}

# Create a NAT Gateway
resource "aws_nat_gateway" "tier3" {
  depends_on = [aws_eip.tier3]

  allocation_id = aws_eip.tier3.id        # Assuming you already have an Elastic IP
  subnet_id     = aws_subnet.public[0].id # Assuming you have a public subnet for the NAT Gateway

  tags = {
    Name = "tier3-private-nat-gateway"
  }
}
