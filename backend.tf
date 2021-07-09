terraform {
  backend "s3" {
    bucket         = "skundu-terraform-remote-state-two"
    encrypt        = true
    key            = "tf/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-lock-table"
  }
}