# Configuration

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.39"
    }
  }
  
  required_version = ">= 0.12"
}

variable "aws_region" {
  description = "Region-for-AWS"
  default = "no_region_value_found"
}

variable "aws_access_key" {
  description = "Access-key-for-AWS"
  default = "no_access_key_value_found"
}
 
variable "aws_secret_key" {
  description = "Secret-key-for-AWS"
  default = "no_secret_key_value_found"
}

variable "ami_key_pair_name" {
  description = "ec2-key-pair-for-AWS"
  default = "no_key_pair_value_found"
}

output "aws_region_is" {
  value = var.aws_region
}

output "access_key_is" {
  value = var.aws_access_key
}
 
output "secret_key_is" {
  value = var.aws_secret_key
}
 
output "key_pair_is" {
  value = var.ami_key_pair_name
}

provider "aws" {
	region = var.aws_region 
	access_key = var.aws_access_key
	secret_key = var.aws_secret_key
}

# Resources

resource "aws_vpc" "back-end" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "back-end" {
  vpc_id                  = aws_vpc.back-end.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "back-end" {
  name        = "back-end"
  description = "Security group for back-end"
  vpc_id      = aws_vpc.back-end.id

  ## External SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # External internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "back-end" {
	ami = "ami-0b3e57ee3b63dd76b"
	instance_type = "t2.micro"
  subnet_id = aws_subnet.back-end.id
  key_name = "${var.ami_key_pair_name}"
  security_groups = [aws_security_group.back-end.id]
	
	tags = {
		Name = "Bootstrap customer project"
	}
}