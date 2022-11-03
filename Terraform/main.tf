terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.37.0"
    }
  }
  backend "s3" {
    bucket = "aws-terraformtt"
    key    = "aws/ec2-deploy/terraform.tfstate"
    region = "us-east-1"
    # role_arn = "arn:aws:iam::219634475281:user/Terraform"
  }
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  instance_tenancy     = "default"
  tags = {
    Name = "Project VPC"
  }
}
resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}

# resource "aws_subnet" "private_subnets" {
#   count             = length(var.private_subnet_cidrs)
#   vpc_id            = aws_vpc.main.id
#   cidr_block        = element(var.private_subnet_cidrs, count.index)
#   availability_zone = element(var.azs, count.index)
#   tags = {
#     Name = "Private Subnet ${count.index + 1}"
#   }
# }

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "Project VPC IG"
  }
}

resource "aws_route_table" "second_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "2nd Route Table"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.second_rt.id
}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress = [{
    description      = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]
  egress = [{
    description      = "egress"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = []
    prefix_list_ids  = []
    security_groups  = []
    self             = false
  }]


  tags = {
    Name = "allow_tls"
  }
}



resource "aws_key_pair" "deploy" {
  key_name   = "deployer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDCTY0VbF293HTGUcmfSqGwtHHdb6D+nt3IGpSMFUd5zpWjWHeUl2LYFbedH3ynOduOCN3/J73wCX3OI7x3DVwxObh05Ws7sOBjgpHIzKQRBzQZ0gq4RqREaTIskifMT5Jr123DAj4ATN6BOPbsb4amM5kby94xzDXytze3R16/JwEVOGOpISQab9hIcjbiSHG9J8+g2y/RpsaFoUSd9hQbiL2Id3x3bvNjbXeU8ZlH1IA5bxosGY4qYoSM1GNWqZpZ2QFu0DVZDMGJKxjLwOKOgZYk3upLivnn1oIpUqElaByLE61sE5B+lPNzs0n2yQiGPGVVcU7UBFuTSl+VtvUN1VQKnYMjKRsOplGw1MWn6iF5tPd3oUi9kI6zMb0Jf+11Cf1WnBMin36Akx6l8HImvnfUFjoQlnlyEjxBD7K17WD+8VzXlwHsnivJ7CNs7wDWqIQ6GGWCgKpALGEuRUveV1fsrga95QjlWuzb1bfQuNBQygHzc1fNbCPEgxHyzmE= arnab@arnab-HP-Pavilion-x360-Convertible-14-dh1xxx"
  # public_key = file("~/.ssh/devenv.pub")

}

resource "aws_iam_instance_profile" "example" {
  name = "Hello"
  role = "Terraform"
}

resource "aws_instance" "name" {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = aws_key_pair.deploy.key_name
  iam_instance_profile   = aws_iam_instance_profile.example.name
  subnet_id              = aws_subnet.public_subnets[0].id
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = var.private_key
    # private_key = file("~/.ssh/devenv")
  }
  tags = {
    Name = "terraform-ec2"
  }
}

output "public_ip" {
  value     = aws_instance.name.public_ip
  sensitive = true
}

