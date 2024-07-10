variable "aws_region" {
    type = string

  
}
variable "ec2_name" {
    type = string
}

variable "vpc_name" {
    type = string
}

variable "instance_vpc_id" {
  type    = string
#   default = "vpc-01ea6a058d95995ca"
}

variable "instance_ami" {
    type= string
    default = "ami-04a81a99f5ec58529"
}

variable "instance_subnet_id" {
  type    = string
}

variable "publicip" {
    type    = bool
    default = true    
}

variable "instance_keyName" {
  type    = string
  default = "ec2-ssh-key"
}

variable "instance_secgroupname" {
  description = "This is a security Group Name"
  type        = string
  default     = "appcloud-SG"
}

variable "cidr_block" {
    default = "10.0.0.0/16"
}

variable "subnet" {
    default = "10.0.0.0/24"
}

variable "instance_type" {
    type = string
    default = "t2.micro"
}

variable "instace_ami" {
    type = string
    default = "ami-04a81a99f5ec58529"
}

variable "bucket" {
    default = "my-s3-bucket"
}

variable "aws_availability_zone" {
    type = string
    default = "us-east-1a"
}

variable "ingress_rules" {
  default = {
    "my ingress rule" = {
      "description" = "For HTTP"
      "from_port"   = "80"
      "to_port"     = "80"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

    "all ingress rule" = {
      "description" = "All"
      "from_port"   = "0"
      "to_port"     = "9999"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },
    "my other ingress rule" = {
      "description" = "For SSH"
      "from_port"   = "22"
      "to_port"     = "22"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

    "Postgres port" = {
      "description" = "For HTTP postgres"
      "from_port"   = "5432"
      "to_port"     = "5432"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

    "Jenkins port" = {
      "description" = "For Jenkins"
      "from_port"   = "8080"
      "to_port"     = "8080"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

     "React Application port" = {
      "description" = "For React"
      "from_port"   = "3000"
      "to_port"     = "3000"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    },

    "Django Application port" = {
      "description" = "For Django"
      "from_port"   = "8585"
      "to_port"     = "8585"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    }

    "All Ports" = {
      "description" = "For HTTP all ports"
      "from_port"   = "3000"
      "to_port"     = "65535"
      "protocol"    = "tcp"
      "cidr_blocks" = ["0.0.0.0/0"]
    }
  }
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "Security group rules"
}


variable "public_subnet_cidrs" {
    type = list(string)
    description = "app Public subnet CIDR values"
    default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "azs" {
    type = list(string)
    description = "Availability zones"
    default = ["us-east-1a", "us-east-1b"]
}



