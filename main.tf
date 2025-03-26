terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "amazon2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon
}

variable instance_type {
  default = "t2.micro"
}

resource "aws_instance" "test" {
  ami           = data.aws_ami.amazon2.id
  instance_type = "${var.instance_type}"

  tags = {
    Name = "Test"
  }
}

output public_ip {
  value = aws_instance.test.public_ip
}

output public_dns {
  value = aws_instance.test.public_dns
}

output instance_type {
  value = aws_instance.test.instance_type
}
