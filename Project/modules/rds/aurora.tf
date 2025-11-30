resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = "${var.name}-cluster"
  engine             = var.engine # очікується aurora-postgresql або aurora-mysql
  engine_version     = var.engine_version

  database_name   = var.database_name
  master_username = var.username
  master_password = var.password

  port = var.port

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  apply_immediately            = true
  skip_final_snapshot          = true
  deletion_protection          = false
  preferred_backup_window      = "03:00-04:00"
  preferred_maintenance_window = "sun:04:00-sun:05:00"

  tags = merge(
    {
      Name = "${var.name}-aurora-cluster"
    },
    var.tags
  )
}

resource "aws_rds_cluster_instance" "this" {
  count = var.use_aurora ? var.aurora_instances : 0

  identifier         = "${var.name}-cluster-${count.index}"
  cluster_identifier = aws_rds_cluster.this[0].id

  instance_class = var.aurora_instance_class
  engine         = var.engine
  engine_version = var.engine_version

  publicly_accessible = false

  db_subnet_group_name    = aws_db_subnet_group.this.name
  db_parameter_group_name = aws_db_parameter_group.this.name

  tags = merge(
    {
      Name = "${var.name}-aurora-instance-${count.index}"
    },
    var.tags
  )
}
