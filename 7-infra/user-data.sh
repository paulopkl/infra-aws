#! /bin/sh
yum update -y
# sudo yum update -y
# sudo yum install htop
# sudo systemctl enable docker.service
# sudo docker swarm join --token SWMTKN-1-2tcrqcot4sctwi08l53e6vgq9py05bwjc64yskzwyfagy8qzwg-92rqjoi3tzuzm9x8v8u6sni7u 10.0.0.184:2377

amazon-linux-extras install docker
service docker start
usermod -a -G docker ec2-user
chkconfig docker on

#!/bin/bash