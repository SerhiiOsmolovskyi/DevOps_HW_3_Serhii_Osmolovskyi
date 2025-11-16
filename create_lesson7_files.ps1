param(
    [string]$ProjectRoot = "lesson-7"
)

function Write-File {
    param(
        [string]$RelativePath,
        [string]$Content
    )

    $fullPath = Join-Path -Path $ProjectRoot -ChildPath $RelativePath
    $dir = Split-Path $fullPath -Parent

    if (-not (Test-Path $dir)) {
        New-Item -Path $dir -ItemType Directory -Force | Out-Null
    }

    Set-Content -Path $fullPath -Value $Content -Encoding UTF8
}

# -----------------------------------
# main.tf
# -----------------------------------
Write-File "main.tf" @'
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

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

module "s3_backend" {
  source              = "./modules/s3-backend"
  bucket_name         = "${var.project_name}-tf-state"
  dynamodb_table_name = "${var.project_name}-tf-locks"
  region              = var.aws_region
}

module "vpc" {
  source         = "./modules/vpc"
  cidr_block     = "10.0.0.0/16"
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  azs            = ["ca-central-1a", "ca-central-1b"]
}

module "ecr" {
  source    = "./modules/ecr"
  repo_name = "${var.project_name}-django-app"
}

module "eks" {
  source          = "./modules/eks"
  cluster_name    = "${var.project_name}-eks-cluster"
  cluster_version = "1.30"
  region          = var.aws_region
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.public_subnet_ids
  desired_size    = 2
  min_size        = 2
  max_size        = 3
  instance_type   = "t3.small"
}
'@

# -----------------------------------
# backend.tf
# -----------------------------------
Write-File "backend.tf" @'
terraform {
  backend "s3" {
    bucket         = "lesson7-tf-state"
    key            = "lesson-7/terraform.tfstate"
    region         = "ca-central-1"
    dynamodb_table = "lesson7-tf-locks"
    encrypt        = true
  }
}
'@

# -----------------------------------
# outputs.tf
# -----------------------------------
Write-File "outputs.tf" @'
output "aws_region" { value = var.aws_region }
output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnet_ids" { value = module.vpc.public_subnet_ids }
output "ecr_repository_url" { value = module.ecr.repository_url }
output "eks_cluster_name" { value = module.eks.cluster_name }
output "eks_cluster_endpoint" { value = module.eks.cluster_endpoint }
output "eks_cluster_ca_certificate" { value = module.eks.cluster_ca_certificate }
'@

# =====================================================
# MODULE s3-backend
# =====================================================

Write-File "modules/s3-backend/variables.tf" @'
variable "bucket_name" { type = string }
variable "dynamodb_table_name" { type = string }
variable "region" { type = string }
'@

Write-File "modules/s3-backend/s3.tf" @'
resource "aws_s3_bucket" "terraform_state" {
  bucket = var.bucket_name
  tags = { Name = var.bucket_name }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration { status = "Enabled" }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.bucket
  rule {
    apply_server_side_encryption_by_default { sse_algorithm = "AES256" }
  }
}
'@

Write-File "modules/s3-backend/dynamodb.tf" @'
resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamodb_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute { name = "LockID" type = "S" }
}
'@

Write-File "modules/s3-backend/outputs.tf" @'
output "bucket_name" { value = aws_s3_bucket.terraform_state.bucket }
output "dynamodb_table_name" { value = aws_dynamodb_table.terraform_locks.name }
'@

# =====================================================
# MODULE vpc
# =====================================================
Write-File "modules/vpc/variables.tf" @'
variable "cidr_block" { type = string }
variable "public_subnets" { type = list(string) }
variable "azs" { type = list(string) }
'@

Write-File "modules/vpc/vpc.tf" @'
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.azs[count.index]
  map_public_ip_on_launch = true
}
'@

Write-File "modules/vpc/routes.tf" @'
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count = length(aws_subnet.public)
  subnet_id = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}
'@

Write-File "modules/vpc/outputs.tf" @'
output "vpc_id" { value = aws_vpc.this.id }
output "public_subnet_ids" { value = [for s in aws_subnet.public : s.id] }
'@

# =====================================================
# MODULE ecr
# =====================================================
Write-File "modules/ecr/variables.tf" @'
variable "repo_name" { type = string }
'@

Write-File "modules/ecr/ecr.tf" @'
resource "aws_ecr_repository" "this" {
  name = var.repo_name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration { scan_on_push = true }
}
'@

Write-File "modules/ecr/outputs.tf" @'
output "repository_url" { value = aws_ecr_repository.this.repository_url }
'@

# =====================================================
# MODULE eks
# =====================================================

Write-File "modules/eks/variables.tf" @'
variable "cluster_name" { type = string }
variable "cluster_version" { type = string }
variable "region" { type = string }
variable "vpc_id" { type = string }
variable "subnet_ids" { type = list(string) }
variable "desired_size" { type = number }
variable "min_size" { type = number }
variable "max_size" { type = number }
variable "instance_type" { type = string }
'@

Write-File "modules/eks/eks.tf" @'
module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = var.subnet_ids
  vpc_id          = var.vpc_id

  eks_managed_node_groups = {
    default = {
      desired_size   = var.desired_size
      min_size       = var.min_size
      max_size       = var.max_size
      instance_types = [var.instance_type]
    }
  }
}
'@

Write-File "modules/eks/outputs.tf" @'
output "cluster_name" { value = module.eks_cluster.cluster_name }
output "cluster_endpoint" { value = module.eks_cluster.cluster_endpoint }
output "cluster_ca_certificate" { value = module.eks_cluster.cluster_certificate_authority_data }
'@

# =====================================================
# HELM CHART
# =====================================================

Write-File "charts/django-app/Chart.yaml" @'
apiVersion: v2
name: django-app
version: 0.1.0
description: Django app chart
type: application
'@

Write-File "charts/django-app/values.yaml" @'
image:
  repository: "<ECR_URL>"
  tag: "latest"
  pullPolicy: IfNotPresent

service:
  type: LoadBalancer
  port: 80
  targetPort: 8000

env:
  DJANGO_DEBUG: "False"
  DJANGO_SECRET_KEY: "change-me"
  DJANGO_ALLOWED_HOSTS: "*"

autoscaling:
  minReplicas: 2
  maxReplicas: 6
  targetCPUUtilizationPercentage: 70
'@

Write-File "charts/django-app/templates/deployment.yaml" @'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: django-app
spec:
  replicas: {{ .Values.autoscaling.minReplicas }}
  selector:
    matchLabels:
      app: django-app
  template:
    metadata:
      labels:
        app: django-app
    spec:
      containers:
        - name: django-app
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag }}"
          envFrom:
            - configMapRef:
                name: django-app-config
          ports:
            - containerPort: 8000
'@

Write-File "charts/django-app/templates/service.yaml" @'
apiVersion: v1
kind: Service
metadata:
  name: django-app
spec:
  selector:
    app: django-app
  ports:
    - port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.targetPort }}
  type: {{ .Values.service.type }}
'@

Write-File "charts/django-app/templates/configmap.yaml" @'
apiVersion: v1
kind: ConfigMap
metadata:
  name: django-app-config
data:
  DJANGO_DEBUG: "{{ .Values.env.DJANGO_DEBUG }}"
  DJANGO_SECRET_KEY: "{{ .Values.env.DJANGO_SECRET_KEY }}"
  DJANGO_ALLOWED_HOSTS: "{{ .Values.env.DJANGO_ALLOWED_HOSTS }}"
'@

Write-File "charts/django-app/templates/hpa.yaml" @'
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: django-app-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: django-app
  minReplicas: {{ .Values.autoscaling.minReplicas }}
  maxReplicas: {{ .Values.autoscaling.maxReplicas }}
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: {{ .Values.autoscaling.targetCPUUtilizationPercentage }}
'@

# -----------------------------------
# Final message
# -----------------------------------
Write-Host "Структура проекту 'lesson-7' створена успішно!"
