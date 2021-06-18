terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.29.0"
    }
  }
}
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
  assume_role {
    role_arn = var.provider_env_roles[terraform.workspace]
  }
}