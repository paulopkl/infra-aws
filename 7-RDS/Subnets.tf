data "aws_subnets" "private" {
  depends_on = [
    data.aws_vpc.vq
  ]

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vq.id]
  }

  tags = {
    Name = "private-subnet-*"
  }
}
