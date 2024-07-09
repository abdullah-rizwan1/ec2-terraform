#region setting
provider "aws" {
    region = "us-east-1"
}


resource "aws_instance" "app_server" {
    ami = "ami-07c8c1b18ca66bb07"
    instance_type = "t2.micro"
    key_name = "ec2-ssh-key"

    tags = {
        Name = var.ec2_name
    }
}