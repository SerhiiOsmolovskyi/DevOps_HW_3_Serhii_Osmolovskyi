# Lesson 5 - Terraform AWS Infrastructure

## Опис завдання

Мета цього домашнього завдання — створити Terraform-структуру для інфраструктури на AWS у директорії `lesson-5`.  

Завдання включає:

1. Синхронізацію стейт-файлів у S3 з використанням DynamoDB для блокування.
2. Створення мережевої інфраструктури (VPC) з публічними та приватними підмережами.
3. Створення ECR (Elastic Container Registry) для зберігання Docker-образів.

Це завдання максимально наближене до реальних сценаріїв роботи DevOps/Cloud Engineer.

---

## Структура проєкту

```
lesson-5/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальне виведення ресурсів
├── terraform.tfvars         # Файл конфігураційних значень для інфраструктури
├── providers.tf             # Опис провайдерів Terraform
│
├── modules/                 # Каталог з усіма модулями
│   │
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакета
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf       # Виведення інформації про VPC
│   │
│   └── ecr/                 # Модуль для ECR
│       ├── data.tf          # Отримання змінних хмарного провайдера
│       ├── ecr.tf           # Створення ECR репозиторію
│       ├── variables.tf     # Змінні для ECR
│       └── outputs.tf       # Виведення URL репозиторію ECR
│
└── README.md                # Документація проєкту
```

---

## Кроки виконання

### 1. Створення структури проєкту

- У кореневій папці `lesson-5` створюємо файли:  
  `main.tf`, `backend.tf`, `outputs.tf`, `README.md`
- Створюємо папку `modules` з підкаталогами: `s3-backend`, `vpc`, `ecr`  

### 2. Налаштування S3 і DynamoDB

- Модуль `s3-backend`:
  - Створює S3-бакет для стейтів Terraform з версіюванням
  - Створює DynamoDB таблицю для блокування стейтів
  - Outputs: URL S3-бакета та ім’я таблиці

### 3. Створення мережевої інфраструктури (VPC)

- Модуль `vpc`:
  - Створює VPC з CIDR блоком
  - 3 публічні та 3 приватні підмережі
  - Internet Gateway для публічних підмереж
  - NAT Gateway для приватних підмереж
  - Route Tables
  - Outputs: VPC ID

### 4. Створення ECR

- Модуль `ecr`:
  - Створює ECR репозиторій
  - Автоматичне сканування образів
  - Outputs: URL репозиторію

---

## Підключення модулів у main.tf
---

module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "ваше_ім'я"
  table_name  = "terraform-locks"
}

module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_name           = "lesson-5-vpc"
}

module "ecr" {
  source      = "./modules/ecr"
  ecr_name    = "lesson-5-ecr"
  scan_on_push = true
}

## Налаштування бекенду для Terraform

terraform {
  backend "s3" {
    bucket         = "ваше_ім'я"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

---

## Команди Terraform

terraform init
terraform plan
terraform apply
terraform destroy

⚠️ Після використання AWS обов’язково видаляйте ресурси, щоб уникнути непередбачених витрат.