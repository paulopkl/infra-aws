
resource "aws_internet_gateway" "tier3" {
  vpc_id = aws_vpc.tier3.id

  tags = {
    Name = "tier3-public-internet-gateway"
  }
}
