# Отримуємо список доступних AZ у регіоні
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "lesson-8-9-vpc"
  }
}

# Публічні сабнети в РІЗНИХ AZ
resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true

  # Розкидаємо сабнети по різних зонах: 0 → eu-central-1a, 1 → eu-central-1b і т.д.
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "lesson-8-9-public-${count.index}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "lesson-8-9-igw"
  }
}
