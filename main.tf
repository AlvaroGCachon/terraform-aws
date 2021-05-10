variable "aws_access_key" {
  description = "Access-key-for-AWS"
  default = "no_access_key_value_found"
}
 
variable "aws_secret_key" {
  description = "Secret-key-for-AWS"
  default = "no_secret_key_value_found"
}

provider "aws" {
	region = "eu-west-3"
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