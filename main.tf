provider "aws" {
	region = "eu-west-3"
	access_key = "REDACTED"
	secret_key = "REDACTED"
}

resource "aws_instance" "back-end" {
	ami = "ami-0357d42faf6fa582f"
	instance_type = "t2.micro"
	
	tags = {
		Name = "Bootstrap customer project"
	}
}