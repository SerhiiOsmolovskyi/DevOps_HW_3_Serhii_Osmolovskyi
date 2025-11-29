 variable "ecr_name" {
  type        = string
  description = "ECR repo name"
}

variable "force_destroy" {
  type        = bool
  description = "Force delete ECR repo on destroy"
  default     = true
}

