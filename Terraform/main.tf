terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.37.0"
    }
  }
  backend "s3" {
    bucket = "aws-terraformtt"
    key = "aws/ec2-deploy/terraform.tfstate"
    region = "us-east-1"
    # role_arn = "arn:aws:iam::219634475281:user/Terraform"
  }
}

provider "aws" {
  # Configuration options
  region = var.region
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
  public_key = var.public_key

}

resource "aws_iam_instance_profile" "example" {
  name      = "Terraform"
  role_name = "Terraform"
}

resource "aws_instance_type" "name" {
  ami                    = "ami-08c40ec9ead489470"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name               = aws_key_pair.deploy.key_name
  iam_instance_profile   = aws_iam_instance_profile.example.name
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = file("~/.ssh/devenv")
  }
  tags = {
    Name = "terraform-ec2"
  }
}

output "public_ip" {
  value = aws_instance_type.name.public_ip
  sensitive = true
}
  