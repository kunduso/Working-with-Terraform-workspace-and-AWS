terraform {
  backend "s3" {
    bucket         = "terraform-remote-bucket-skundu"
    encrypt        = true
    key            = "tf/terraform-workspace-poc/terraform.tfstate"
    region         = "us-east-2"
    dynamodb_table = "terraform-state-lock-table"
  }
}