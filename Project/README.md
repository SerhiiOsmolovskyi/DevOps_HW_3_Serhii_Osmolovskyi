# Final DevOps Project – AWS EKS + RDS + Jenkins + Argo CD + Monitoring

Це фінальний DevOps-проєкт, який розгортає продакшн-подібну інфраструктуру в AWS за допомогою Terraform та Helm.

Інфраструктура включає:

- **VPC** з публічними та приватними підмережами
- **EKS кластер** для запуску застосунків
- **ECR репозиторій** для Docker-образів
- **Jenkins** для CI (через Helm)
- **Argo CD** для GitOps CD (через Helm)
- **Aurora PostgreSQL (RDS)** як основну БД
- **kube-prometheus-stack** (Prometheus + Grafana + Alertmanager) для моніторингу кластера

---

## 1. Структура проєкту

```text
Project/
├── backend.tf           # Налаштування Terraform backend (S3 + DynamoDB)
├── main.tf              # Головний модуль: провайдери + підключення всіх модулів
├── variables.tf         # Змінні root-модуля
├── outputs.tf           # Вихідні значення (EKS, VPC, ECR, namespaces)
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── eks/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── ecr/
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── jenkins/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── argo_cd/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── rds/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── monitoring/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── README.md

