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

variable "ami_instance_id" {
  description = "ami-id-ec2-for-AWS"
  default = "no_ami_id_value_found"
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

output "url" {
  value = "http://${aws_eip.eip.public_ip}/"
}

provider "aws" {
	region = var.aws_region 
	access_key = var.aws_access_key
	secret_key = var.aws_secret_key
}

# Resources

resource "aws_vpc" "nginx" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
}

resource "aws_subnet" "nginx" {
  vpc_id                  = aws_vpc.nginx.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Security group for nginx"
  vpc_id      = aws_vpc.nginx.id

  ## External SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic in our nginx instance"
  vpc_id      = aws_vpc.nginx.id

  ## External SSH access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "allow_outbound_traffic" {
  name        = "allow-outbound-traffic"
  description = "Allow all outbound traffic"
  vpc_id      = aws_vpc.nginx.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx" {
	ami = var.ami_instance_id
	instance_type = "t2.micro"
  subnet_id = aws_subnet.nginx.id
  key_name = "${var.ami_key_pair_name}"
  vpc_security_group_ids = [
    aws_security_group.allow_ssh.id, 
    aws_security_group.allow_http.id, 
    aws_security_group.allow_outbound_traffic.id
    ]

	tags = {
		Name = "HTTP Nginx instance"
	}
}

resource "aws_internet_gateway" "nginx-gw" {
  vpc_id = "${aws_vpc.nginx.id}"
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.nginx.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.nginx-gw.id
}

resource "aws_eip" "eip" {
  instance = aws_instance.nginx.id
  vpc = true
}