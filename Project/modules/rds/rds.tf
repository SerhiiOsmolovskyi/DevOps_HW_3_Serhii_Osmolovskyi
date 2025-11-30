resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier        = "${var.name}-db"
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  db_name  = var.database_name
  username = var.username
  password = var.password

  port                = var.port
  multi_az            = var.multi_az
  publicly_accessible = false

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]
  parameter_group_name   = aws_db_parameter_group.this.name

  skip_final_snapshot = true

  tags = merge(
    {
      Name = "${var.name}-db-instance"
    },
    var.tags
  )
}
