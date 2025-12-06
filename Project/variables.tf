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
  type        = string
  description = "CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets"
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private subnets (для RDS / внутрішніх сервісів)"
  default = [
    "10.0.11.0/24",
    "10.0.12.0/24"
  ]
}

variable "ecr_name" {
  type        = string
  description = "Name of ECR repository"
  default     = "django-app"
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
  default     = "dev-eks-final"
}

variable "cluster_version" {
  type        = string
  description = "EKS Kubernetes version"
  default     = "1.30"
}

variable "jenkins_namespace" {
  type        = string
  description = "Kubernetes namespace for Jenkins"
  default     = "jenkins"
}

variable "jenkins_chart_version" {
  type        = string
  description = "Helm chart version for Jenkins"
  default     = "5.5.16"
}

variable "jenkins_admin_user" {
  type        = string
  description = "Jenkins admin username"
  default     = "admin"
}

variable "jenkins_admin_password" {
  type        = string
  description = "Jenkins admin password"
  default     = "admin123"
}

variable "argocd_namespace" {
  type        = string
  description = "Kubernetes namespace for Argo CD"
  default     = "argocd"
}

variable "argocd_chart_version" {
  type        = string
  description = "Helm chart version for Argo CD"
  default     = "7.5.2"
}

variable "argocd_applications_repo_url" {
  type        = string
  description = "Git repo URL with Argo CD applications Helm chart (app-of-apps)"
  default     = "https://github.com/SerhiiOsmolovskyi/DevOps_HW_3_Serhii_Osmolovskyi.git"
}

variable "kube_host" {
  type        = string
  description = "Kubernetes API server endpoint (optional override)"
  default     = ""
}

variable "kube_ca" {
  type        = string
  description = "Base64 encoded Kubernetes CA certificate (optional override)"
  default     = ""
}

variable "kube_token" {
  type        = string
  description = "Service account token for helm/kubernetes providers (optional override)"
  default     = ""
}

#######################################
# RDS / Aurora module variables
#######################################

variable "rds_name" {
  type        = string
  description = "Базове ім'я для RDS ресурсів (prefix для identifier-ів)"
  default     = "lesson-db-module"
}

variable "rds_use_aurora" {
  type        = bool
  description = "Якщо true — створюємо Aurora cluster, якщо false — звичайну RDS instance"
  default     = true
}

variable "rds_engine" {
  type        = string
  description = "Тип engine: postgres / mysql / aurora-postgresql / aurora-mysql"
  default     = "aurora-postgresql"
}

variable "rds_engine_version" {
  type        = string
  description = "Версія engine (наприклад, 16.3, 15.4, 8.0 тощо)"
  default     = "15.4"
}

variable "rds_instance_class" {
  type        = string
  description = "Тип інстансу для звичайної RDS"
  default     = "db.t3.micro"
}

variable "rds_aurora_instance_class" {
  type        = string
  description = "Тип інстансу для Aurora cluster instances"
  default     = "db.r6g.large"
}

variable "rds_aurora_instances" {
  type        = number
  description = "Кількість Aurora instances у кластері"
  default     = 1
}

variable "rds_allocated_storage" {
  type        = number
  description = "Розмір диску (GB) для звичайної RDS"
  default     = 20
}

variable "rds_multi_az" {
  type        = bool
  description = "Увімкнути Multi-AZ для звичайної RDS"
  default     = false
}

variable "rds_allowed_cidr_blocks" {
  type        = list(string)
  description = "Список CIDR-блоків, які можуть підключатися до БД"
  default = [
    "10.0.0.0/16"
  ]
}

variable "rds_username" {
  type        = string
  description = "DB master username"
  default     = "app_user"
}

variable "rds_password" {
  type        = string
  description = "DB master password (для реального продакшну — з SSM/Secrets Manager)"
  default     = "ChangeMePlease123!"
  sensitive   = true
}

variable "rds_database_name" {
  type        = string
  description = "Назва бази даних"
  default     = "app_db"
}

variable "rds_port" {
  type        = number
  description = "Порт для підключення до БД"
  default     = 5432
}

variable "rds_parameter_group_family" {
  type        = string
  description = "Family для parameter group (postgres16, aurora-postgresql15, mysql8.0 тощо)"
  default     = "aurora-postgresql15"
}

variable "rds_max_connections" {
  type        = number
  description = "Параметр max_connections у DB parameter group"
  default     = 100
}

variable "rds_log_statement" {
  type        = string
  description = "log_statement (none, ddl, mod, all)"
  default     = "none"
}

variable "rds_work_mem" {
  type        = string
  description = "work_mem для parameter group"
  default     = "4MB"
}

variable "rds_tags" {
  type        = map(string)
  description = "Додаткові теги для всіх RDS ресурсів"
  default = {
    Project = "DevOps_HW_3"
    Env     = "dev"
  }
}

#######################################
# MONITORING (Prometheus + Grafana)
#######################################

variable "monitoring_namespace" {
  type        = string
  description = "Namespace для Prometheus + Grafana"
  default     = "monitoring"
}

variable "monitoring_chart_version" {
  type        = string
  description = "Версія Helm-чарту kube-prometheus-stack"
  default     = "65.5.1"
}

variable "grafana_admin_user" {
  type        = string
  description = "Логін адміністратора Grafana"
  default     = "admin"
}

variable "grafana_admin_password" {
  type        = string
  description = "Пароль адміністратора Grafana"
  default     = "admin123"
  sensitive   = true
}
