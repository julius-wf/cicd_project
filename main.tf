terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~>5.0"
    }
  }
}

# Configure AWS provider

provider "aws" {
  region = "eu-north-1"
}

# Use default AWS VPC
resource "aws_default_vpc" "default" {
  
}


#Create key pair 


resource "aws_key_pair" "tf-key-pair" {
key_name = "tf-key-pair"
public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}
resource "local_file" "tf-key" {
content  = tls_private_key.rsa.private_key_pem
filename = "tf-key-pair"
}


# Create Master host
resource "aws_instance" "master" {
    ami = "ami-0989fb15ce71ba39e"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.web.id]
    key_name = "tf-key-pair"
    user_data = file("setup.sh")
}

# Create Security group
resource "aws_security_group" "web" {
  name = "my_group"
  description = "Security group allowing HTTP, HTTPS, and SSH"
  vpc_id = aws_default_vpc.default.id
}

# Defined ports
resource "aws_security_group_rule" "http_ingress" {
  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "http8080" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "https_ingress" {
  type        = "ingress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "ssh_ingress" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "ICMP" {
  type = "ingress" 
  description = "Allow all incoming ICMP IPv4 traffic"
  from_port = -1
  to_port = -1
  protocol = "icmp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

resource "aws_security_group_rule" "outbound_all" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"  # All protocols
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.web.id
}

