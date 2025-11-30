variable "namespace" {
  type        = string
  default     = "jenkins"
  description = "Namespace for Jenkins"
}

variable "chart_version" {
  type    = string
  default = "5.5.16"
}

variable "admin_user" {
  type    = string
  default = "admin"
}

variable "admin_password" {
  type    = string
  default = "admin123"
}

variable "kube_host" {
  type        = string
  description = "Kubernetes API server endpoint"
}

variable "kube_ca" {
  type        = string
  description = "Base64 encoded CA cert"
}

variable "kube_token" {
  type        = string
  description = "Service account token"
}

