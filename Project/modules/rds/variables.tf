variable "name" {
  type        = string
  description = "Базовий префікс для всіх RDS-ресурсів (identifier, SG, subnet group, параметри)"
}

variable "use_aurora" {
  type        = bool
  description = "Якщо true — створюємо Aurora cluster, якщо false — звичайний RDS instance"
  default     = false
}

variable "engine" {
  type        = string
  description = "Тип engine: 'postgres', 'mysql', 'aurora-postgresql' або 'aurora-mysql'"
  default     = "postgres"

  validation {
    condition = contains(
      ["postgres", "mysql", "aurora-postgresql", "aurora-mysql"],
      var.engine
    )
    error_message = "engine має бути одним із: postgres, mysql, aurora-postgresql, aurora-mysql."
  }
}

variable "engine_version" {
  type        = string
  description = "Версія engine (наприклад, '16.3' або '15.4')"
  default     = "16.3"
}

variable "instance_class" {
  type        = string
  description = "Тип інстансу для звичайної RDS"
  default     = "db.t3.micro"
}

variable "aurora_instance_class" {
  type        = string
  description = "Тип інстансу для Aurora instances"
  default     = "db.t3.small"
}

variable "aurora_instances" {
  type        = number
  description = "Кількість Aurora instances у кластері"
  default     = 1
}

variable "allocated_storage" {
  type        = number
  description = "Розмір диску (GB) для звичайної RDS"
  default     = 20
}

variable "multi_az" {
  type        = bool
  description = "Ввімкнути Multi-AZ для звичайної RDS"
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "ID VPC, в якій створюється RDS"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Список приватних subnet-ів для DB Subnet Group"
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "CIDR-діапазони, які можуть підключатися до БД"
  default     = []
}

variable "username" {
  type        = string
  description = "DB master username"
}

variable "password" {
  type        = string
  description = "DB master password"
  sensitive   = true
}

variable "database_name" {
  type        = string
  description = "Назва бази даних, яка буде створена"
  default     = "app_db"
}

variable "port" {
  type        = number
  description = "Порт для бази даних"
  default     = 5432

  validation {
    condition     = var.port > 0 && var.port < 65535
    error_message = "port має бути у діапазоні 1–65534."
  }
}

variable "parameter_group_family" {
  type        = string
  description = "Назва family для parameter group (наприклад 'postgres16', 'aurora-postgresql15')"
  default     = "aurora-postgresql15"
}

variable "max_connections" {
  type        = number
  description = "Параметр max_connections у DB parameter group"
  default     = 100
}

variable "log_statement" {
  type        = string
  description = "Параметр log_statement (none, ddl, mod, all)"
  default     = "none"

  validation {
    condition = contains(["none", "ddl", "mod", "all"], var.log_statement)
    error_message = "log_statement має бути одним із: none, ddl, mod, all."
  }
}

variable "work_mem" {
  type        = string
  description = "Параметр work_mem (наприклад '4MB', '16MB')"
  default     = "4MB"
}

variable "tags" {
  type        = map(string)
  description = "Додаткові теги для всіх ресурсів"
  default     = {}
}
