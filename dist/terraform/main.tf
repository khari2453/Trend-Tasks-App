
# provider
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.11.0"
    }
  }
}

provider "aws" {
   region = "us-east-1"
}

# VPC creation

resource "aws_vpc" "jenkins_vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "jenkins_vpc"
  }
}

# Subnets

resource "aws_subnet" "jenkins_public_subnet" {
  vpc_id     = aws_vpc.jenkins_vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "jenkins_public_subnet"
  }
}

resource "aws_subnet" "jenkins_private_subnet" {
  vpc_id     = aws_vpc.jenkins_vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "jenkins_private_subnet"
  }
}

# internet gateway
resource "aws_internet_gateway" "jenkins_igw" {
  vpc_id = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "jenkins_igw"
  }
}

# Route table
resource "aws_route_table" "jenkins_routetable" {
  vpc_id = aws_vpc.jenkins_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.jenkins_igw.id
  }

  tags = {
    Name = "jenkins_routetable"
  }
}

# Subnet association

resource "aws_route_table_association" "jenkins_public_routetable" {
  subnet_id      = aws_subnet.jenkins_public_subnet.id
  route_table_id = aws_route_table.jenkins_routetable.id
}

resource "aws_route_table_association" "jenkins_private_routetable" {
  subnet_id      = aws_subnet.jenkins_private_subnet.id
  route_table_id = aws_route_table.jenkins_routetable.id
}

# Security group

resource "aws_security_group" "jenkins_securitygroup" {
  name        = "jenkins_securitygroup"
  description = "Allow TLS inbound traffic and all outbound traffic. Ssh http https"
  vpc_id      = aws_vpc.jenkins_vpc.id

  tags = {
    Name = "jenkins_securitygroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ipv4_ssh" {
  security_group_id = aws_security_group.jenkins_securitygroup.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "ipv4_http" {
  security_group_id = aws_security_group.jenkins_securitygroup.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ipv4_https" {
  security_group_id = aws_security_group.jenkins_securitygroup.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.jenkins_securitygroup.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# IAM Role for EC2
# -----------------------
resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ec2.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_attach" {
  role       = aws_iam_role.jenkins_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}

resource "aws_iam_instance_profile" "jenkins_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_role.name
}


# Ec2 creation

resource "aws_instance" "jenkins_Ec2" {
  ami           = "ami-08982f1c5bf93d976"
  instance_type = "t2.medium"
  key_name = aws_key_pair.jenkinskeyname.key_name
  subnet_id = aws_subnet.jenkins_public_subnet.id
  vpc_security_group_ids = [aws_security_group.jenkins_securitygroup.id]
   iam_instance_profile   = aws_iam_instance_profile.jenkins_profile.name
  user_data = <<-EOF
              #!/bin/bash
              sudo yum update –y
              sudo wget -O /etc/yum.repos.d/jenkins.repo \https://pkg.jenkins.io/redhat-stable/jenkins.repo
              sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
              sudo yum upgrade -y
              sudo yum install java-21-amazon-corretto -y
              sudo yum install jenkins -y
              sudo systemctl enable jenkins
              sudo systemctl start jenkins
              EOF

  tags = {
    Name = "jenkins_Ec2"
  }
}

# allocate EIP

resource "aws_eip" "jenkins_eip" {
    tags = {
        Name = "jenkins_eip" 
    }
  
}

# association EIP to EC2

resource "aws_eip_association" "eip_association" {
    instance_id = aws_instance.jenkins_Ec2.id
    allocation_id = aws_eip.jenkins_eip.id
  
}

# keypair creations
resource "aws_key_pair" "jenkinskeyname" {
  key_name   = "jenkinskey"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYlV2pxzPNFOHh03vZZFcjrYxYtGa1+o0bOxqGPpbfrGkhz8bO9W23m/1Tp7B4zsnhlL0SsPi8GL7rbW+pNdmYxFwhAOsOsiUnIz8OmB96xtufd3/XFTMuq3OjDpYgi1gUw/73M2pr1frggKLOkklRcjHuguZUKFd7Nvn+XPRMiXszBiEBt3BfWSpyH3gD9QPq705ySbAP59BxoGnekeWBBb7fBH8i3xMPOMQkoO071FbkRw8Jz6Vjtg3Od01L9ARS7uOX/eXnl08yM+S7pD2m8UTRnLU1RBgE1CMjWzpJJHhnxTu8KU6pHUZQ0yibm64tGkQpFc6izhgx95At6tHp imported-openssh-key"
}
