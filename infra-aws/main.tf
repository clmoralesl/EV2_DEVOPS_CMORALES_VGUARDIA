terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = { Name = "VPC-Proyecto-EP2" }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "IGW-Proyecto" }
}

resource "aws_subnet" "public_front" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags                    = { Name = "Subnet-Public-Front" }
}

resource "aws_subnet" "private_app" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "Subnet-Private-App" }
}

resource "aws_subnet" "private_db" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "Subnet-Private-DB" }
}

resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.gw]
  tags       = { Name = "NAT-EIP" }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_front.id
  tags          = { Name = "Main-NAT-Gateway" }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = { Name = "RT-Publica" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_front.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = { Name = "RT-Privada" }
}

resource "aws_route_table_association" "app_assoc" {
  subnet_id      = aws_subnet.private_app.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "db_assoc" {
  subnet_id      = aws_subnet.private_db.id
  route_table_id = aws_route_table.private_rt.id
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_security_group" "sg_frontend" {
  name   = "sg_frontend"
  vpc_id = aws_vpc.main.id
  tags   = { Name = "SG-Frontend" }
}

resource "aws_security_group" "sg_backend" {
  name   = "sg_backend"
  vpc_id = aws_vpc.main.id
  tags   = { Name = "SG-Backend" }
}

resource "aws_security_group" "sg_database" {
  name   = "sg_database"
  vpc_id = aws_vpc.main.id
  tags   = { Name = "SG-Database" }
}

resource "aws_security_group_rule" "front_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_frontend.id
}

resource "aws_security_group_rule" "front_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_frontend.id
}

resource "aws_security_group_rule" "front_icmp_from_back" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.sg_backend.id
  security_group_id        = aws_security_group.sg_frontend.id
}

resource "aws_security_group_rule" "front_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_frontend.id
}

# --- REGLAS PARA BACKEND ---
resource "aws_security_group_rule" "back_api" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8081
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_frontend.id
  security_group_id        = aws_security_group.sg_backend.id
}

resource "aws_security_group_rule" "back_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_frontend.id
  security_group_id        = aws_security_group.sg_backend.id
}

resource "aws_security_group_rule" "back_icmp_from_front" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.sg_frontend.id
  security_group_id        = aws_security_group.sg_backend.id
}

resource "aws_security_group_rule" "back_icmp_from_db" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.sg_database.id
  security_group_id        = aws_security_group.sg_backend.id
}

resource "aws_security_group_rule" "back_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_backend.id
}

# --- REGLAS PARA DATABASE ---
resource "aws_security_group_rule" "db_mysql" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.sg_backend.id
  security_group_id        = aws_security_group.sg_database.id
}

resource "aws_security_group_rule" "db_icmp_from_back" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = aws_security_group.sg_backend.id
  security_group_id        = aws_security_group.sg_database.id
}

resource "aws_security_group_rule" "db_egress" {
  type              = "egress"
  from_port         = 0
  to_port         = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.sg_database.id
}

variable "user_data_script" {
  default = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install docker git -y
              sudo systemctl start docker
              sudo systemctl enable docker
              sudo usermod -a -G docker ec2-user
            EOF
}

resource "aws_instance" "front_ec2" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_front.id
  vpc_security_group_ids = [aws_security_group.sg_frontend.id]
  iam_instance_profile   = "LabInstanceProfile"
  key_name               = "devops_key_cm_vg"
  user_data              = var.user_data_script
  tags                   = { Name = "EC2-Frontend" }
}

resource "aws_instance" "back_ec2" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_app.id
  vpc_security_group_ids = [aws_security_group.sg_backend.id]
  iam_instance_profile   = "LabInstanceProfile"
  key_name               = "devops_key_cm_vg"
  user_data              = var.user_data_script
  tags                   = { Name = "EC2-Backends" }
}

resource "aws_instance" "db_ec2" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_db.id
  vpc_security_group_ids = [aws_security_group.sg_database.id]
  iam_instance_profile   = "LabInstanceProfile"
  key_name               = "devops_key_cm_vg"
  user_data              = var.user_data_script
  tags                   = { Name = "EC2-Databases" }
}

# --- REPOSITORIOS ECR ---
resource "aws_ecr_repository" "repo_front" {
  name                 = "proyecto-frontend"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "repo_back_ventas" {
  name                 = "proyecto-back-ventas"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "repo_back_despachos" {
  name                 = "proyecto-back-despachos"
  image_tag_mutability = "MUTABLE"
  force_delete         = true
  image_scanning_configuration {
    scan_on_push = true
  }
}
