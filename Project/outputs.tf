output "ecr_repository_url" {
  value = module.ecr.repository_url
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "jenkins_namespace" {
  value = var.jenkins_namespace
}

output "argocd_namespace" {
  value = var.argocd_namespace
}
