data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name = "description"
    values = ["Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2024-02-07"]
    # values = ["Ubuntu Server 22.04 LTS (HVM), SSD Volume Type*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

    owners = ["099720109477"]  # Canonical's AWS account ID
}

output "aws_ami_ubuntu" {
  value = data.aws_ami.ubuntu.id
}
