# Lesson 5 - Terraform AWS Infrastructure

## Опис завдання

Мета цього домашнього завдання — створити Terraform-структуру для інфраструктури на AWS у директорії `lesson-5`.  

Завдання включає:

1. Налаштування синхронізації стейт-файлів у S3 з використанням DynamoDB для блокування.
2. Створення мережевої інфраструктури (VPC) з публічними та приватними підмережами.
3. Створення ECR (Elastic Container Registry) для зберігання Docker-образів.

Це завдання максимально наближене до реальних сценаріїв роботи DevOps/Cloud Engineer.

---

## Структура проєкту

lesson-5/
│
├── main.tf # Головний файл для підключення модулів
├── backend.tf # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf # Загальне виведення ресурсів
├── README.md # Документація проєкту
│
├── modules/ # Каталог з усіма модулями
│ ├── s3-backend/ # Модуль для S3 та DynamoDB
│ ├── vpc/ # Модуль для VPC
│ └── ecr/ # Модуль для ECR



---

## Кроки виконання

1. **Створення структури проєкту**
   - У кореневій папці `lesson-5` створюємо файли `main.tf`, `backend.tf`, `outputs.tf`, `README.md`.
   - Створюємо папку `modules` з модулями `s3-backend`, `vpc`, `ecr`.

2. **Налаштування S3 для Terraform стейтів та DynamoDB**
   - Модуль `s3-backend` створює S3-бакет з версіюванням для збереження стейтів.
   - DynamoDB таблиця для блокування стейтів.
   - Виведення URL S3-бакета та імені DynamoDB в `outputs.tf`.

3. **Створення мережевої інфраструктури (VPC)**
   - Модуль `vpc` створює VPC з CIDR блоком.
   - 3 публічні та 3 приватні підмережі.
   - Internet Gateway для публічних підмереж.
   - NAT Gateway для приватних підмереж.
   - Налаштування Route Tables.

4. **Створення ECR**
   - Модуль `ecr` створює ECR репозиторій з автоматичним скануванням образів.
   - Виведення URL репозиторію через `outputs.tf`.

5. **Підключення модулів у main.tf**
   ```hcl
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

terraform {
  backend "s3" {
    bucket         = "ваше_ім'я"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

Команди Terraform

Ініціалізація Terraform:

terraform init


Перевірка плану розгортання:

terraform plan


Створення інфраструктури:

terraform apply


Видалення інфраструктури:

terraform destroy


Після використання AWS обов’язково видаляйте ресурси, щоб уникнути непередбачених витрат.

Модулі
s3-backend

Створює S3-бакет для стейтів з версіюванням.

Створює DynamoDB таблицю для блокування стейтів.

Outputs: URL бакета та ім’я таблиці.

vpc

Створює VPC, підмережі, Internet Gateway, NAT Gateway.

Налаштовує маршрутизацію для публічних і приватних підмереж.

Outputs: VPC ID.

ecr

Створює ECR репозиторій.

Включає сканування образів.

Outputs: URL репозиторію.