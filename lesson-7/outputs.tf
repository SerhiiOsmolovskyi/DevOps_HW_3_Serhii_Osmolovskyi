output "aws_region" { value = var.aws_region }
output "vpc_id" { value = module.vpc.vpc_id }
output "public_subnet_ids" { value = module.vpc.public_subnet_ids }
output "ecr_repository_url" { value = module.ecr.repository_url }
output "eks_cluster_name" { value = module.eks.cluster_name }
output "eks_cluster_endpoint" { value = module.eks.cluster_endpoint }
output "eks_cluster_ca_certificate" { value = module.eks.cluster_ca_certificate }
