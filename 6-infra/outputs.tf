
data "aws_instances" "managers" {
  depends_on = [
    aws_autoscaling_group.swarm_manager_nodes
  ]

  instance_tags = {
    Name = "auto-scaling-swarm-manager-node"
  }
}

data "aws_instances" "workers" {
  depends_on = [
    aws_autoscaling_group.swarm_worker_nodes
  ]

  instance_tags = {
    Name = "auto-scaling-swarm-worker-node"
  }
}

output "name" {
  value = [
    cidrsubnet(aws_vpc.vq.cidr_block, 8, 0),
    cidrsubnet(aws_vpc.vq.cidr_block, 8, 1),
    cidrsubnet(aws_vpc.vq.cidr_block, 8, 2),
  ]
}

output "ami_ubuntu" {
  value = data.aws_ami.ubuntu.arn
}

# Output the DNS name of the ALB
output "alb_dns_name" {
  value = aws_lb.swarm_managers.dns_name
}

output "rabbitmq-mq-private-subnets" {
  value = element(aws_subnet.private[*].id, length(aws_subnet.private) - 1)
}

output "managers_ips" {
  value = {
    "Public IP" = data.aws_instances.managers.public_ips,
    "Private IP" = data.aws_instances.managers.private_ips
  }
}

output "workers_ips" {
  value = {
    "Public IP" = data.aws_instances.workers.public_ips,
    "Private IP" = data.aws_instances.workers.private_ips
  }
}

output "rabbitmq-ips" {
  value = {
    "Public IP"  = aws_instance.rabbit-mq.public_ip,
    "Private IP" = aws_instance.rabbit-mq.private_ip
  }
}

resource "local_file" "ansible_inventory_ini" {
  depends_on = [
    data.aws_instances.managers,
    data.aws_instances.workers
  ]

  filename             = "../8-Ansible/inventory.ini"
  file_permission      = "777"
  directory_permission = "700"
  content              = <<-EOT
    [swarm_managers]
    ${join("\n", [for ip in data.aws_instances.managers.public_ips : "${ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/tier3-ssh.pem"])}

    [swarm_workers]
    ${aws_instance.rabbit-mq.private_ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/tier3-ssh.pem
    ${join("\n", [for ip in data.aws_instances.workers.private_ips : "${ip} ansible_ssh_user=ubuntu ansible_ssh_private_key_file=~/.ssh/tier3-ssh.pem"])}

    [all:vars]
    ansible_ssh_common_args='-o StrictHostKeyChecking=no'

    ## ENTER public instances
    # ssh -i ~/.ssh/tier3-ssh.pem ubuntu@ec2-${replace(data.aws_instances.managers.public_ips[0], ".", "-")}.compute-1.amazonaws.com

    ## ENTER RabbitMQ private instance inside public instances
    # ssh -i ~/.ssh/tier3-ssh.pem ubuntu@${aws_instance.rabbit-mq.private_ip}

    ## ENTER RabbitMQ private instances inside public instances
    # ssh -i ~/.ssh/tier3-ssh.pem ubuntu@${data.aws_instances.workers.private_ips[0]}

    ## Copy current ssh key to the EC2 instances
    # sudo scp -i ~/.ssh/tier3-ssh.pem /home/paulo/.ssh/tier3-ssh.pem ubuntu@ec2-${replace(data.aws_instances.managers.public_ips[0], ".", "-")}.compute-1.amazonaws.com:~/.ssh/
  EOT
}

