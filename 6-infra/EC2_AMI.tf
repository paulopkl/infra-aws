# Latest Ubuntu 22.04 LTS AMI in the current region
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20240*"]
  }

  # filter {
  #   name = "description"
  #   values = ["Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2024-02-07"]
  #   # values = ["Ubuntu Server 22.04 LTS (HVM), SSD Volume Type*"]
  # }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
