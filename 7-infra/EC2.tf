# policy:
#   - "AmazonS3ReadOnlyAccess"
#   - "AmazonS3ReadOnlyAccess"

# resource "aws_iam_p" "" {

# }

# Create EC2 instances in public subnets
resource "aws_instance" "public" {
  depends_on = [
    data.aws_ami.ubuntu,
    aws_key_pair.tier3_key,
    aws_subnet.public
  ]

  count = length(aws_subnet.public)

  iam_instance_profile = aws_iam_instance_profile.tier3.name

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.aws_ec2_instance_type
  subnet_id                   = aws_subnet.public[count.index].id # Assuming you have a list of public subnets
  associate_public_ip_address = true

  vpc_security_group_ids = [aws_security_group.public_security_group.id] # Attach the public security group
  key_name               = aws_key_pair.tier3_key.key_name

  # Use the remote-exec provisioner to execute commands after instance creation
  provisioner "remote-exec" {
    inline = [
      # "echo '${aws_key_pair.tier3_key.public_key}' > ~/.ssh/${aws_key_pair.tier3_key.key_name}.pub",
      "echo \"${tls_private_key.ssh.private_key_pem}\" > ~/.ssh/${aws_key_pair.tier3_key.key_name}.pem",
      "chmod 600 ~/.ssh/${aws_key_pair.tier3_key.key_name}.pem"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"                            # Adjust based on your instance's OS user
      private_key = tls_private_key.ssh.private_key_pem # Adjust based on your private key path
      host        = self.public_ip                      # Assumes you have a public IP. Otherwise, use private_ip.
    }
  }

  # Tags for better organization (optional but recommended)
  tags = {
    Name = "public-instance-${count.index + 1}"
  }
}

# Create EC2 instances in private subnets
resource "aws_instance" "private" {
  depends_on = [
    data.aws_ami.ubuntu,
    aws_key_pair.tier3_key,
    aws_subnet.private
  ]

  count = length(aws_subnet.private)

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.aws_ec2_instance_type
  subnet_id                   = aws_subnet.private[count.index].id # Assuming you have a list of private subnets
  associate_public_ip_address = false

  vpc_security_group_ids = [aws_security_group.private_security_group.id] # Attach the private security group
  key_name               = aws_key_pair.tier3_key.key_name

  # Tags for better organization (optional but recommended)
  tags = {
    Name = "private-instance-${count.index + 1}"
  }
}

output "ec2_ips" {
  value = concat(
    [for instance in aws_instance.public : instance.public_ip],
    [for instance in aws_instance.private : instance.private_ip]
  )
}
