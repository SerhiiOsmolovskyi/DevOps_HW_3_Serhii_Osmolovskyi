output "db_subnet_group_name" {
  description = "Назва DB Subnet Group"
  value       = aws_db_subnet_group.this.name
}

output "security_group_id" {
  description = "ID security group для БД"
  value       = aws_security_group.this.id
}

output "parameter_group_name" {
  description = "Назва параметр групи"
  value       = aws_db_parameter_group.this.name
}

output "rds_endpoint" {
  description = "Endpoint звичайної RDS-інстанси (якщо use_aurora = false)"
  value       = try(aws_db_instance.this[0].address, null)
}

output "rds_port" {
  description = "Порт RDS-інстанси (якщо use_aurora = false)"
  value       = try(aws_db_instance.this[0].port, null)
}

output "aurora_endpoint" {
  description = "Endpoint Aurora cluster (якщо use_aurora = true)"
  value       = try(aws_rds_cluster.this[0].endpoint, null)
}

output "aurora_reader_endpoint" {
  description = "Reader endpoint Aurora cluster (якщо use_aurora = true)"
  value       = try(aws_rds_cluster.this[0].reader_endpoint, null)
}
