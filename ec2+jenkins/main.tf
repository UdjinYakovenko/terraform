terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  version = "~>3.0"
  region   = var.region
}

resource "aws_instance" "Jenkins" {
  ami           = "ami-0947d2ba12ee1ff75"
  instance_type = "t2.micro"
  key_name        = "${var.keyname}"
  vpc_security_group_ids = [aws_security_group.Jenkins_SG.id]
  user_data = file("Script.sh")

  tags = {
    Name = "Jenkins"
  }
}

resource "aws_security_group" "Jenkins_SG" {
  name        = "Jenkins_SG"
  description = "Ec2-Jenkins"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins_SG"
  }
}

output "jenkins_ip_address" {
  value = "${aws_instance.Jenkins.public_dns}"
}