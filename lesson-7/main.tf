terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# ---------------- VARIABLES ----------------

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ca-central-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "lesson7"
}

variable "bucket_suffix" {
  type    = string
  default = "devops"
}

variable "backend_bucket" {
  type    = string
  default = "lesson7-tf-state-devops"
}

variable "backend_table" {
  type    = string
  default = "lesson7-tf-locks-devops"
}

# ---------------- VPC MODULE ----------------

module "vpc" {
  source         = "./modules/vpc"
  cidr_block     = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  azs            = ["ca-central-1a", "ca-central-1b"]
}

# ---------------- ECR MODULE ----------------

module "ecr" {
  source    = "./modules/ecr"
  repo_name = "${var.project_name}-django-app"
}

# ---------------- EKS MODULE  ----------------

module "eks" {
  source = "./modules/eks"

  cluster_name = "${var.project_name}-eks2"
  cluster_version = "1.30"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids

  desired_size  = 2
  min_size      = 2
  max_size      = 3
  instance_type = "t3.small"
}
