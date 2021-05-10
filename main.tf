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

output "aws_region_is" {
  value = var.aws_region
}

output "access_key_is" {
  value = var.aws_access_key
}
 
output "secret_key_is" {
  value = var.aws_secret_key
}

provider "aws" {
	region = var.aws_region 
	access_key = var.aws_access_key
	secret_key = var.aws_secret_key
}

resource "aws_instance" "back-end" {
	ami = "ami-0357d42faf6fa582f"
	instance_type = "t2.micro"
	
	tags = {
		Name = "Bootstrap customer project"
	}
}