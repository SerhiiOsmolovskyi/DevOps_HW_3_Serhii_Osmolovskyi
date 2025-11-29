# CI/CD з Jenkins, Terraform, Helm, EKS, ECR та Argo CD (lesson-8-9)

Цей проєкт — домашнє завдання до теми **«Вивчення Argo CD + CI/CD»**.  
Мета — показати повний шлях доставки застосунку в Kubernetes-кластер AWS EKS за допомогою:

- **Terraform** — створення інфраструктури (VPC, ECR, EKS, backend для стейту);
- **Helm** — встановлення Jenkins та (опційно) Argo CD;
- **Jenkins** — збірка Docker-образу Django-застосунку, пуш в Amazon ECR, оновлення Helm-чарту;
- **Argo CD** — GitOps-синхронізація стану кластера з Git-репозиторієм.

---

## 1. Структура проєкту

```text
lesson-8-9/
├── backend.tf          # Налаштування remote backend (S3 + DynamoDB)
├── main.tf             # Підключення модулів (VPC, ECR, EKS, Jenkins, Argo CD)
├── outputs.tf          # Корисні виводи (URL ECR, імʼя кластера тощо)
├── variables.tf        # Глобальні змінні проєкту
│
├── modules/
│   ├── s3-backend/     # (опційний) модуль для S3 + DynamoDB під backend
│   │   ├── s3.tf
│   │   ├── dynamodb.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── vpc/            # Модуль мережі
│   │   ├── vpc.tf      # VPC, сабнети по різних AZ, Internet Gateway
│   │   ├── routes.tf   # Маршрутизація (public route table)
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── ecr/            # Модуль реєстру образів
│   │   ├── ecr.tf      # AWS ECR репозиторій (django-app)
│   │   ├── variables.tf
│   │   └── outputs.tf
│   │
│   ├── eks/            # Модуль EKS-кластера
│   │   ├── eks.tf      # EKS cluster + node group
│   │   ├── variables.tf
│   │   └── outputs.tf  # endpoint, CA, імʼя кластера
│   │
│   ├── jenkins/        # Модуль встановлення Jenkins через Helm
│   │   ├── jenkins.tf  # helm_release для Jenkins
│   │   ├── variables.tf
│   │   ├── values.yaml # Кастомний конфіг Jenkins (admin, ресурси, persistence=false)
│   │   └── outputs.tf
│   │
│   └── argo_cd/        # Модуль встановлення Argo CD через Helm (app-of-apps)
│       ├── argo.tf         # helm_release для Argo CD (може бути закоментований)
│       ├── variables.tf
│       ├── values.yaml     # Базова конфігурація Argo CD
│       ├── outputs.tf
│       └── charts/         # Helm-чарт "app of apps" для застосунків
│           ├── Chart.yaml
│           ├── values.yaml # Список applications і repositories
│           └── templates/
│               ├── application.yaml
│               └── repository.yaml
│
└── charts/
    └── django-app/     # Helm-чарт Django-застосунку
        ├── Chart.yaml
        ├── values.yaml     # image.repository, image.tag, env, ресурси тощо
        └── templates/
            ├── deployment.yaml
            ├── service.yaml
            ├── configmap.yaml
            └── hpa.yaml


# Команди для ініціалізації та запуску
```
terraform init
terraform plan
terraform apply

helm install django-app ./django-app

terraform destroy
```

# Деплой

1. В Jenkins запускаємо pipeline seed-job для динамічного створення іншого pipeline goit-django-docker
2. В Jenkins запускаємо pipeline goit-django-docker для збірки та деплою Docker image у AWS ECR
3. В ArgoCD перевіряємо статус застосунку після синхронізації