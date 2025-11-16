terraform {
  backend "s3" {
    bucket         = "lesson7-tf-state-devops"
    key            = "lesson-7/terraform.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "lesson7-tf-locks-devops"
    encrypt        = true
  }
}
