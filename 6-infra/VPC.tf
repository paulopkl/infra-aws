# Create a VPC
resource "aws_vpc" "tier3" {
  cidr_block = var.aws_cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = var.aws_tags
}
