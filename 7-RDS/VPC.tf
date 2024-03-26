data "aws_vpc" "vq" {
  cidr_block = var.aws_cidr_block

  tags = var.aws_vpc_tags
}
