# Generate Key Pair
resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Public Key - Goes to AWS
resource "aws_key_pair" "key" {
  key_name   = var.ssh_key_name
  public_key = tls_private_key.ssh.public_key_openssh
}

# Private Key - Stay in my local machine
resource "local_file" "pem_file" {
  filename             = pathexpand("~/.ssh/${aws_key_pair.key.key_name}.pem")
  file_permission      = "600"
  directory_permission = "700"
  content              = tls_private_key.ssh.private_key_pem
}
