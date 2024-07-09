#region setting
provider "aws" {
    region = "us-east-1"
}


resource "aws_instance" "app_server" {
    ami = "ami-04a81a99f5ec58529"
    instance_type = "t2.micro"
    key_name = "ec2-ssh-key"

    tags = {
        Name = var.ec2_name
    }
}