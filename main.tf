terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
  }
}

#######################################
# PROVIDERS
#######################################

provider "aws" {
  region = var.aws_region
}

# EKS кластер створюємо через aws-провайдер, а доступ до нього
# для kubernetes/helm будуємо на основі його параметрів.

# Дані для авторизації в EKS (токен)
data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_name
}

# Kubernetes provider направлений на EKS-кластер
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca)
  token                  = data.aws_eks_cluster_auth.this.token
}

# Helm provider також працює через той самий EKS-кластер
provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

#######################################
# MODULES
#######################################

# S3 + DynamoDB для backend-а
# (у тебе вже створені вручну і використані через backend.tf)
# Якщо захочеш – колись можна або імпортувати, або видалити вручну
# і віддати керування цьому модулю.
/*
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = var.backend_bucket_name
  table_name  = var.backend_dynamodb_table_name
}
*/

# VPC
module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr_block      = var.vpc_cidr_block
  public_subnet_cidrs = var.public_subnet_cidrs
}

# ECR
module "ecr" {
  source        = "./modules/ecr"
  ecr_name      = var.ecr_name
  force_destroy = true
}

# EKS
module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnet_ids
}

# Jenkins через Helm
module "jenkins" {
  source = "./modules/jenkins"

  namespace      = var.jenkins_namespace
  chart_version  = var.jenkins_chart_version
  admin_user     = var.jenkins_admin_user
  admin_password = var.jenkins_admin_password

  # Передаємо параметри кластера — якщо модуль їх використовує
  kube_host  = module.eks.cluster_endpoint
  kube_ca    = module.eks.cluster_ca
  kube_token = data.aws_eks_cluster_auth.this.token
}

# Argo CD через Helm
module "argo_cd" {
  source = "./modules/argo_cd"

  namespace             = var.argocd_namespace
  chart_version         = var.argocd_chart_version
  applications_repo_url = var.argocd_applications_repo_url

  kube_host  = module.eks.cluster_endpoint
  kube_ca    = module.eks.cluster_ca
  kube_token = data.aws_eks_cluster_auth.this.token
}
