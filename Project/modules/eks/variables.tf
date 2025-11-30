variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "cluster_version" {
  type        = string
  description = "EKS Kubernetes version"
  default     = "1.30"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID for EKS"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for EKS"
}

variable "node_group_desired_size" {
  type    = number
  default = 2
}

variable "node_group_min_size" {
  type    = number
  default = 1
}

variable "node_group_max_size" {
  type    = number
  default = 2
}

variable "node_instance_type" {
  type    = string
  default = "t3.small"
}
