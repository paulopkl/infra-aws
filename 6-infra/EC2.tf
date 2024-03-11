# policy:
#   - "AmazonS3ReadOnlyAccess"
#   - "AmazonS3ReadOnlyAccess"

# Bootstrap script for instances
locals {
  nodes_user_data = <<EOF
#!/bin/bash
set -e
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y python-pip
	EOF
}

# Launch Configuration for Swarm MANAGER nodes
resource "aws_launch_configuration" "swarm_manager_node" {
  name_prefix = "launch-template-swarm-manager-node"

  associate_public_ip_address = true
  image_id                    = data.aws_ami.ubuntu.id                       // ubuntu 22.04
  instance_type               = var.aws_manager_instance_type                // t3.micro
  security_groups             = [aws_security_group.public_manager_nodes.id] // [22, 80, 443, 2377] : 0
  # aws_security_group.swarm_node.id,
  key_name  = aws_key_pair.key.id
  user_data = local.nodes_user_data

  # provisioner "" {
  # }

  lifecycle {
    create_before_destroy = true
  }
}

# Launch Configuration for Swarm WORKER nodes
resource "aws_launch_configuration" "swarm_worker_node" {
  name_prefix = "launch-template-swarm-worker-node"

  associate_public_ip_address = false                                        // true
  image_id                    = data.aws_ami.ubuntu.id                       // ubuntu 22.04
  instance_type               = var.aws_worker_instance_type                 // t3.medium
  security_groups             = [aws_security_group.private_worker_nodes.id] // [22, 7946, 4789] : 0
  key_name                    = aws_key_pair.key.id
  user_data                   = local.nodes_user_data

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "rabbit-mq" {
  depends_on = [
    data.aws_ami.ubuntu,
    aws_key_pair.tier3_key,
    aws_subnet.public
  ]

  ami                         = data.aws_ami.ubuntu.id // ubuntu 22.04
  instance_type               = var.aws_rabbitmq_instance_type
  subnet_id                   = element(aws_subnet.public[*].id, length(aws_subnet.public) - 1) # Assuming you have a list of public subnets
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.private_rabbitmq.id] # Attach the public security group
  key_name                    = aws_key_pair.key.key_name

  tags = var.aws_tags
}

# Create EC2 instances in public subnets
# resource "aws_instance" "public" {
#   depends_on = [
#     data.aws_ami.ubuntu,
#     aws_key_pair.tier3_key,
#     aws_subnet.public
#   ]

#   count = length(aws_subnet.public)

#   iam_instance_profile = aws_iam_instance_profile.tier3.name

#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = var.aws_ec2_instance_type
#   subnet_id                   = aws_subnet.public[count.index].id # Assuming you have a list of public subnets
#   associate_public_ip_address = true

#   vpc_security_group_ids = [aws_security_group.public_security_group.id] # Attach the public security group
#   key_name               = aws_key_pair.key.key_name

#   # Use the remote-exec provisioner to execute commands after instance creation
#   provisioner "remote-exec" {
#     inline = [
#       # "echo '${aws_key_pair.key.public_key}' > ~/.ssh/${aws_key_pair.key.key_name}.pub",
#       "echo \"${tls_private_key.ssh.private_key_pem}\" > ~/.ssh/${aws_key_pair.key.key_name}.pem",
#       "chmod 600 ~/.ssh/${aws_key_pair.key.key_name}.pem"
#     ]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"                            # Adjust based on your instance's OS user
#       private_key = tls_private_key.ssh.private_key_pem # Adjust based on your private key path
#       host        = self.public_ip                      # Assumes you have a public IP. Otherwise, use private_ip.
#     }
#   }

#   tags = {
#     Name = "Admin-Node-instance-${count.index + 1}"
#   }
# }

# # Create EC2 instances in private subnets
# resource "aws_instance" "private" {
#   depends_on = [
#     data.aws_ami.ubuntu,
#     aws_key_pair.key,
#     aws_subnet.private
#   ]

#   count = length(aws_subnet.private)

#   ami                         = data.aws_ami.ubuntu.id
#   instance_type               = var.aws_ec2_instance_type
#   subnet_id                   = aws_subnet.private[count.index].id # Assuming you have a list of private subnets
#   associate_public_ip_address = false

#   vpc_security_group_ids = [aws_security_group.private_security_group.id] # Attach the private security group
#   key_name               = aws_key_pair.key.key_name

#   # Tags for better organization (optional but recommended)
#   tags = {
#     Name = "private-instance-${count.index + 1}"
#   }
# }

# output "ec2_ips" {
#   value = concat(
#     [for instance in aws_instance.public : instance.public_ip],
#     [for instance in aws_instance.private : instance.private_ip]
#   )
# }
