variable "availabilities_zones" {
  default = ["a", "b", "c", "d", "e", "f"]
}

# Create public subnets
resource "aws_subnet" "public" {
  count  = var.aws_public_subnets # 2
  vpc_id = aws_vpc.tier3.id
  cidr_block        = cidrsubnet(aws_vpc.tier3.cidr_block, 8, count.index)
  availability_zone = "${var.aws_region}${var.availabilities_zones[count.index]}" # Change AZ as needed

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

# Create private subnets
resource "aws_subnet" "private" {
  count  = var.aws_private_subnets # 3
  vpc_id = aws_vpc.tier3.id
  cidr_block        = cidrsubnet(aws_vpc.tier3.cidr_block, 8, count.index + 2)
  availability_zone = "${var.aws_region}${var.availabilities_zones[count.index + 2]}" # Change AZ as needed

  tags = {
    Name = "private-subnet-${count.index + 2}"
  }
}

output "name" {
  value = [
    cidrsubnet(aws_vpc.tier3.cidr_block, 8, 0),
    cidrsubnet(aws_vpc.tier3.cidr_block, 8, 1),
    cidrsubnet(aws_vpc.tier3.cidr_block, 8, 2),
    cidrsubnet(aws_vpc.tier3.cidr_block, 8, 3),
  ]
}
