resource "aws_route_table" "public_route_table" {
  depends_on = [
    aws_vpc.tier3,
    aws_internet_gateway.tier3
  ]

  # count = length(aws_subnet.public)

  vpc_id = aws_vpc.tier3.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tier3.id
  }

  tags = {
    Name = "tier3-public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  depends_on = [
    aws_vpc.tier3,
    aws_nat_gateway.tier3
  ]

  # count = length(aws_subnet.private)

  vpc_id = aws_vpc.tier3.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.tier3.id
  }

  tags = {
    Name = "tier3-private-route-table"
  }
}

resource "aws_route_table_association" "subnet_route_public" {
  depends_on = [aws_subnet.public, aws_route_table.public_route_table]
  count      = length(aws_subnet.public)

  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "subnet_route_private" {
  depends_on = [aws_subnet.private, aws_route_table.private_route_table]
  count      = length(aws_subnet.private)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}
