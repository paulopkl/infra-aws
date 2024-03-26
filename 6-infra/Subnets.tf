variable "availabilities_zones" {
  default = ["a", "b", "c", "d", "e", "f"]
}

# Create public subnets
resource "aws_subnet" "public" {
  count = var.aws_public_subnets # 2

  vpc_id            = aws_vpc.vq.id
  cidr_block        = cidrsubnet(aws_vpc.vq.cidr_block, 8, count.index)
  availability_zone = "${var.aws_region}${var.availabilities_zones[count.index]}" # Change AZ as needed

  tags = {
    Name = "public-subnet-${count.index + 1}"
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count = var.aws_private_subnets # 3

  vpc_id            = aws_vpc.vq.id
  cidr_block        = cidrsubnet(aws_vpc.vq.cidr_block, 8, count.index + var.aws_public_subnets + 1)
  availability_zone = "${var.aws_region}${var.availabilities_zones[count.index]}" # Change AZ as needed

  tags = {
    Name = "private-subnet-${count.index + 1}"
  }
}
