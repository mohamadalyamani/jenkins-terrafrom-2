provider "aws" {
  region = var.aws_region
}

#Create security group with firewall rules
resource "aws_security_group" "my_security_group" {
  name        = var.security_group
  description = "security group for Ec2 instance"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from jenkis server
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create AWS ec2 instance
resource "aws_instance" "myFirstInstance" {
  ami           = var.ami_id
  key_name = var.key_name
  instance_type = var.instance_type
 # security_groups = [var.security_group]
}
#create vpc
resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
}
#create public subnet
resource "aws_subnet" "public1" {
  vpc_id = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
}
# Create Elastic IP address
resource "aws_eip" "myFirstInstance" {
  vpc      = true
  instance = aws_instance.myFirstInstance.id
}


