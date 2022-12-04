terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.15.1"
    }
  }
}

provider "aws" {
  region = var.region
}
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
data "aws_vpc" "default_vpc" {
  default = true
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default_vpc.id]
  }
}

resource "aws_security_group" "allow_public" {

  name        = var.ec2_security_group_name
  description = var.ec2_security_group_description
  vpc_id      = data.aws_vpc.default_vpc.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group_rule" "public_allow_ssh" {
  # This is a trick to convert list to map
  type              = "ingress"
  description       = "Public access inbound for port ssh"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.allow_public.id
}

resource "aws_security_group_rule" "public_allow_http" {
  # This is a trick to convert list to map
  type              = "ingress"
  description       = "Public access inbound for port http"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.allow_public.id
}

resource "aws_security_group_rule" "public_allow_https" {
  # This is a trick to convert list to map
  type              = "ingress"
  description       = "Public access inbound for port https"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks = ["::/0"]
  security_group_id = aws_security_group.allow_public.id
}

resource "aws_instance" "docker_vm" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.ec2_instance_type
  key_name      = var.keypair_name
  user_data     = templatefile("./bootstrap/templatescript.tftpl", {
    script_list : [
      templatefile("./bootstrap/docker.sh", {})      
    ]
  })
  security_groups =  [ aws_security_group.allow_public.name ]
}


