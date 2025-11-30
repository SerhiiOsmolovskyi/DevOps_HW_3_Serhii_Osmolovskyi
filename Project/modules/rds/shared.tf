resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnets"
  subnet_ids = var.subnet_ids

  tags = merge(
    {
      Name = "${var.name}-db-subnets"
    },
    var.tags
  )
}

resource "aws_security_group" "this" {
  name        = "${var.name}-db-sg"
  description = "Security group for ${var.name} RDS"
  vpc_id      = var.vpc_id

  // Вхідний трафік на порт БД
  dynamic "ingress" {
    for_each = length(var.allowed_cidr_blocks) > 0 ? var.allowed_cidr_blocks : []
    content {
      from_port   = var.port
      to_port     = var.port
      protocol    = "tcp"
      cidr_blocks = [ingress.value]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${var.name}-db-sg"
    },
    var.tags
  )
}

resource "aws_db_parameter_group" "this" {
  name        = "${var.name}-param-group"
  family      = var.parameter_group_family
  description = "Parameter group for ${var.name}"

  parameter {
    name  = "max_connections"
    value = tostring(var.max_connections)
  }

  parameter {
    name  = "log_statement"
    value = var.log_statement
  }

  parameter {
    name  = "work_mem"
    value = var.work_mem
  }

  tags = merge(
    {
      Name = "${var.name}-param-group"
    },
    var.tags
  )
}
