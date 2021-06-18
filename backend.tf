terraform {
  backend "s3" {
    bucket         = "terraform-project4-vpc-peering"
    encrypt        = true
    key            = "tf/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-lock-table"
  }
}