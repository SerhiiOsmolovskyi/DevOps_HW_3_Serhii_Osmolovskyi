/*
terraform {
  backend "s3" {
    bucket         = "osmolovskyi-terraform-state"
    key            = "lesson-8-9/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
*/