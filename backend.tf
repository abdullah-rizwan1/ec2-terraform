terraform {
  backend "s3" {
    bucket = "terraform-tfstate-bucket-905418336711"
    region = "us-east-1"
    key = "terraform.tfstate"
    dynamodb_table = "data_onenets_tf_lockid"
    encrypt= false
  }
}