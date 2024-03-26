# policy:
#   - "AmazonS3ReadOnlyAccess"
#   - "AmazonS3ReadOnlyAccess"

data "template_file" "user_data_script" {
  template = <<EOF
#!/bin/bash

echo "${aws_key_pair.key.public_key}" > ~/.ssh/${aws_key_pair.key.key_name}.pub
echo "${tls_private_key.ssh.private_key_pem}" > ~/.ssh/${aws_key_pair.key.key_name}.pem
chmod 600 ~/.ssh/${aws_key_pair.key.key_name}.pem

# Add Docker's official GPG key:
sudo apt-get update -y
sudo apt-get install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update -y

sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin unzip -y

# Install AWS Cli 2.0
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.13.33.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install --update

# Authenticate Docker to ECR
aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${var.aws_ecr_prefix}

# Initialize a crontab
crontab -l > temp_crontab # Get the current crontab

# Set up the cron job to authenticate Docker with AWS ECR every 12 hours
echo "0 */12 * * * /usr/local/bin/aws ecr get-login-password --region ${var.aws_region} | /usr/bin/docker login --username AWS --password-stdin ${var.aws_ecr_prefix}" >> temp_crontab # Install the updated crontab

# Execute a crontab based on file
crontab temp_crontab

# Remove the temporary file
rm temp_crontab

EOF
}

# Launch Configuration for Swarm MANAGER nodes
resource "aws_launch_template" "swarm_manager_node" {
  depends_on = [
    aws_security_group.public_manager_nodes
  ]

  name          = "launch-template-swarm-manager-node"
  description   = "Launch Template for Manager Nodes"
  image_id      = data.aws_ami.ubuntu.id        // ubuntu 22.04
  instance_type = var.aws_manager_instance_type // t3.micro

  key_name      = aws_key_pair.key.id
  user_data     = base64encode(data.template_file.user_data_script.rendered)
  ebs_optimized = true
  # default_version = 1
  update_default_version = true

  iam_instance_profile {
    name = aws_iam_instance_profile.vq.name
  }

  network_interfaces {
    security_groups             = [aws_security_group.public_manager_nodes.id] // [22, 80, 443, 2377] : 0
    associate_public_ip_address = true
  }

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size           = 10    #volume_size = 20 # LT Update Testing - Version 2 of LT
      delete_on_termination = false # true
      volume_type           = "gp2" # default is gp2
    }
  }

  monitoring {
    enabled = true
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "myasg"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Launch Configuration for Swarm WORKER nodes
resource "aws_launch_template" "swarm_worker_node" {
  name_prefix            = "launch-template-swarm-worker-node"
  description            = "Launch Template for Worker Nodes"
  image_id               = data.aws_ami.ubuntu.id                       // ubuntu 22.04
  instance_type          = var.aws_worker_instance_type                 // t3.medium
  vpc_security_group_ids = [aws_security_group.private_worker_nodes.id] // [22, 7946, 4789] : 0
  key_name               = aws_key_pair.key.id
  user_data              = base64encode(data.template_file.user_data_script.rendered)
  # ebs_optimized        = true
  # default_version = 1
  update_default_version = true

  iam_instance_profile {
    name = aws_iam_instance_profile.vq.name
  }

  #   monitoring {
  #     enabled = true
  #   }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "rabbit-mq" {
  depends_on = [
    data.aws_ami.ubuntu,
    aws_key_pair.key,
    aws_subnet.public
  ]

  ami                         = data.aws_ami.ubuntu.id // ubuntu 22.04
  instance_type               = var.aws_rabbitmq_instance_type
  subnet_id                   = element(aws_subnet.private[*].id, length(aws_subnet.private) - 1) # Assuming you have a list of public subnets
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.private_rabbitmq.id] # Attach the public security group
  key_name                    = aws_key_pair.key.key_name
  user_data                   = base64encode(data.template_file.user_data_script.rendered)
  iam_instance_profile        = aws_iam_instance_profile.vq.name

  tags = {
    Name        = "RabbitMQ"
    Environment = "Production"
  }
}
