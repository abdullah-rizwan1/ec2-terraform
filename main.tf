# data "aws_availability_zones" "available" {}

#region setting
provider "aws" {
    region = "us-east-1"
}

resource "aws_vpc" "app-vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    enable_network_address_usage_metrics = true
    lifecycle {
      prevent_destroy = true
    }

    tags = {
        Name = "app-vpc"
    }
}


resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnet_cidrs)
  vpc_id = aws_vpc.app-vpc.id
  cidr_block = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  enable_resource_name_dns_a_record_on_launch = true
  map_public_ip_on_launch = true

  tags = {
    Name = "AppCloud Public Subnet ${count.index + 1}"
  }

  lifecycle {
    prevent_destroy = true
  }
}


# Internet gateway
resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.app-vpc.id
    
    tags = {
        Name = "AppCloud VPC Internet Gateway"
    }
}


# 2 aws route table route
resource "aws_route_table" "second_rt" {
    vpc_id = aws_vpc.app-vpc.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    
    tags = {
        Name = "2nd Route Table"
    }
}

# Associate Public Subnets with the Second Route Table
resource "aws_route_table_association" "public_subnet_asso" {
 count = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.second_rt.id
 
}

output "VPCID" {
  value = aws_vpc.app-vpc.id
}


// AMI Security group setting using HashiCorp Configuration Language (HCL)
resource "aws_security_group" "appcloud-SG" {
  name        = var.instance_secgroupname
  description = var.instance_secgroupname
  vpc_id      = var.instance_vpc_id

  // To Allow SSH Transport
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = lookup(ingress.value, "description", null)
      from_port   = lookup(ingress.value, "from_port", null)
      to_port     = lookup(ingress.value, "to_port", null)
      protocol    = lookup(ingress.value, "protocol", null)
      cidr_blocks = lookup(ingress.value, "cidr_blocks", null)
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name = "appcloud-SG"
  }

  lifecycle {
    create_before_destroy = true
  }
}





# Terraform provision AWS EC2 instance with S3 State Management
# AWS EC2 Instance A 
resource "aws_instance" "appcloud-ec2" {
  ami                         = var.instance_ami
  instance_type               = var.instance_type
  subnet_id                   = var.instance_subnet_id
  associate_public_ip_address = var.publicip
  key_name                    = var.instance_keyName



  vpc_security_group_ids = [
    aws_security_group.appcloud-SG.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size           = 50
    volume_type           = "gp2"
  }
  tags = {
    Name        = "appcloud-ec2"
    Environment = "DEV"
    OS          = "UBUNTU"
    Managed     = "APPCLOUD"
  }




  depends_on = [aws_security_group.appcloud-SG]
}

output "appcloud-ec2instance1" {
  value = aws_instance.appcloud-ec2.public_ip
}


# resource "aws_instance" "app_server" {
#     ami = "ami-04a81a99f5ec58529"
#     instance_type = "t2.micro"
#     key_name = "ec2-ssh-key"

#     tags = {
#         Name = var.ec2_name
#     }
# }

