output "s3_backend" {
  value = module.s3_backend
}

output "vpc" {
  value = module.vpc
}

output "ecr_repository_url" {
  value = module.ecr.repository_url
}

