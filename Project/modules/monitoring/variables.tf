variable "namespace" {
  type        = string
  description = "Namespace для Prometheus + Grafana"
}

variable "chart_version" {
  type        = string
  description = "Версія helm chart для kube-prometheus-stack"
}

variable "grafana_admin_user" {
  type        = string
  description = "Grafana admin username"
}

variable "grafana_admin_password" {
  type        = string
  description = "Grafana admin password"
  sensitive   = true
}

variable "kube_host" {
  type        = string
}

variable "kube_ca" {
  type        = string
}

variable "kube_token" {
  type        = string
  sensitive   = true
}
