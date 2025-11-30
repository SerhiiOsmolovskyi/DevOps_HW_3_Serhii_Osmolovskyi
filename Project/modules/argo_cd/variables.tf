variable "namespace" {
  type    = string
  default = "argocd"
}

variable "chart_version" {
  type    = string
  default = "7.5.2"
}

variable "applications_repo_url" {
  type        = string
  description = "Git repo URL with Argo CD applications Helm chart (app-of-apps)"
}

variable "kube_host" {
  type = string
}

variable "kube_ca" {
  type = string
}

variable "kube_token" {
  type = string
}

