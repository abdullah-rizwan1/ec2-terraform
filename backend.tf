terraform {
  backend "s3" {
    bucket = "terraform-tfstate-bucket-905418336711"
    region = "us-east-1"
    key = "terraform.tfstate"
    encrypt= false
  }
}