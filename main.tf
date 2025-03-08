# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-bucket-okori"
#     key            = "terraform.tfstate"
#     region         = "eu-west-1"
#     encrypt        = true
#   }
# }


# terraform {
#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "5.0"
#     }
#   }
# }

# # Configure the AWS Provider
# provider "aws" {
#   region = "eu-west-1"
# }

# # Create a VPC
# resource "aws_vpc" "stanley" {
#   cidr_block = "10.0.0.0/16"
# }

# resource "aws_subnet" "subnet_1" {
#   vpc_id     = aws_vpc.stanley.id
#   cidr_block = "10.0.1.0/24"
#   map_public_ip_on_launch = true
#   availability_zone = "eu-west-1a"

#   tags = {
#     Name = "subnet_1"
#   }
# }

# resource "aws_subnet" "subnet_2" {
#   vpc_id     = aws_vpc.stanley.id
#   cidr_block = "10.0.2.0/24"
#   map_public_ip_on_launch = true
#   availability_zone = "eu-west-1b"

#   tags = {
#     Name = "subnet_2"
#   }
# }

# # Security Group for EC2 allowing SSH (22)
# resource "aws_security_group" "ec2_sg" {
#   vpc_id = aws_vpc.stanley.id

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "EC2 Security Group"
#   }
# }

# resource "aws_instance" "carepulse1" {
#   ami             = "ami-0a89fa9a6d8c7ad98"
#   instance_type   = "t3.micro"
#   subnet_id       = aws_subnet.subnet_1.id
#   security_groups = [aws_security_group.ec2_sg.id]
#   key_name        = "stanley_key"

#   tags = {
#     Name = "carepulse1"
#   }
# }

# resource "aws_instance" "carepulse2" {
#   ami             = "ami-0a89fa9a6d8c7ad98"
#   instance_type   = "t3.micro"
#   subnet_id       = aws_subnet.subnet_2.id
#   security_groups = [aws_security_group.ec2_sg.id]
#   key_name        = "stanley_key"

#   tags = {
#     Name = "carepulse2"
#   }
# }

# resource "aws_internet_gateway" "igw" {
#   vpc_id = aws_vpc.stanley.id

#   tags = {
#     Name = "stanley-igw"
#   }
# }

# resource "aws_route_table" "public_rt" {
#   vpc_id = aws_vpc.stanley.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.igw.id
#   }

#   tags = {
#     Name = "public-route-table"
#   }
# }

# resource "aws_route_table_association" "subnet_1" {
#   subnet_id      = aws_subnet.subnet_1.id
#   route_table_id = aws_route_table.public_rt.id
# }

# resource "aws_route_table_association" "subnet_2" {
#   subnet_id      = aws_subnet.subnet_2.id
#   route_table_id = aws_route_table.public_rt.id
# }

# resource "aws_security_group" "lb_sg" {
#   vpc_id = aws_vpc.stanley.id

#   # Allow inbound HTTP traffic (port 80) to ALB
#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # Allow all outbound traffic
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "Load Balancer Security Group"
#   }
# }


# resource "aws_lb" "web_lb" {
#   name               = "web-load-balancer"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.lb_sg.id]
#   subnets            = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id]
# }

# resource "aws_lb_target_group" "web_tg" {
#   name     = "web-target-group"
#   port     = 80
#   protocol = "HTTP"
#   vpc_id   = aws_vpc.stanley.id
# }


# output "vpc_id" {
#   value = aws_vpc.stanley.id
# }

terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket-okori"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    encrypt        = true
  }
}

module "vpc" {
  source      = "./modules/vpc"
  vpc_name    = "stanley-vpc"
  cidr_block  = "10.0.0.0/16"
}

module "subnet_1" {
  source           = "./modules/subnet"
  vpc_id           = module.vpc.vpc_id
  cidr_block       = "10.0.1.0/24"
  availability_zone = "eu-west-1a"
  map_public_ip    = true
  subnet_name      = "subnet_1"
}

module "subnet_2" {
  source           = "./modules/subnet"
  vpc_id           = module.vpc.vpc_id
  cidr_block       = "10.0.2.0/24"
  availability_zone = "eu-west-1b"
  map_public_ip    = true
  subnet_name      = "subnet_2"
}

module "security_group" {
  source = "./modules/security-group"
  vpc_id = module.vpc.vpc_id
  sg_name = "EC2 Security Group"
  ingress_rules = [
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

module "ec2_instance" {
  source            = "./modules/ec2"
  ami               = "ami-0a89fa9a6d8c7ad98"
  instance_type     = "t3.micro"
  subnet_id         = module.subnet_1.subnet_id
  security_group_id = module.security_group.security_group_id
  key_name          = "stanley_key"
  count = 3
  instance_name     = "carepulse-${count.index + 1}"
}
