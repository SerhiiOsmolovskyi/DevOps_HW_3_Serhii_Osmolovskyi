variable "aws_region" {
  type        = string
  description = "AWS region"
  default     = "eu-central-1"
}

variable "backend_bucket_name" {
  type        = string
  description = "S3 bucket for Terraform remote state"
  default     = "osmolovskyi-terraform-state"
}

variable "backend_dynamodb_table_name" {
  type        = string
  description = "DynamoDB table for state locking"
  default     = "terraform-lock"
}

variable "vpc_cidr_block" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "ecr_name" {
  type    = string
  default = "django-app"
}

variable "cluster_name" {
  type    = string
  default = "dev-eks"
}

variable "cluster_version" {
  type    = string
  default = "1.30"
}

variable "jenkins_namespace" {
  type    = string
  default = "jenkins"
}

variable "jenkins_chart_version" {
  type    = string
  default = "5.5.16"
}

variable "jenkins_admin_user" {
  type    = string
  default = "admin"
}

variable "jenkins_admin_password" {
  type    = string
  default = "admin123"
}

variable "argocd_namespace" {
  type    = string
  default = "argocd"
}

variable "argocd_chart_version" {
  type    = string
  default = "7.5.2"
}

variable "argocd_applications_repo_url" {
  type        = string
  description = "Git repo URL with Argo CD applications Helm chart (app-of-apps)"
  default     = "https://github.com/SerhiiOsmolovskyi/DevOps_HW_3_Serhii_Osmolovskyi.git"
}

variable "kube_host" {
  type        = string
  description = "Kubernetes API server endpoint"
  default     = ""
}

variable "kube_ca" {
  type        = string
  description = "Base64 encoded Kubernetes CA certificate"
  default     = ""
}

variable "kube_token" {
  type        = string
  description = "Service account token for helm/kubernetes providers"
  default     = ""
}
