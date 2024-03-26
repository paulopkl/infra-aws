# Create Internet Gateway
resource "aws_internet_gateway" "vq" {
  vpc_id = aws_vpc.vq.id

  tags = {
    Name = "vq-public-internet-gateway"
  }
}
