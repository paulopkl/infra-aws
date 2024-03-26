# Create a VPC
resource "aws_vpc" "vq" {
  cidr_block       = var.aws_cidr_block
  instance_tenancy = "default"

  // We want DNS hostnames enabled for this VPC
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = var.aws_vpc_tags
}
