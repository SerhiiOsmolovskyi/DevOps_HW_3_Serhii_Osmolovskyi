# Dockerized Django Project with PostgreSQL and Nginx

Цей проєкт демонструє повну Docker-структуру для вебзастосунку Django з PostgreSQL та Nginx.  
Він дозволяє запускати повноцінний стек локально за допомогою Docker Compose.  

---

## 📂 Структура проєкту

devops-django/
├── docker-compose.yml
├── DjangoProject/ # Ваш Django-проєкт
│ ├── manage.py
│ └── ...
├── Dockerfile # Dockerfile для Django
├── requirements.txt
└── nginx/
└── nginx.conf # Конфігурація Nginx

yaml

---

## 🛠 Технології

- **Django** — вебзастосунок  
- **PostgreSQL** — база даних  
- **Nginx** — вебсервер та проксі  
- **Docker & Docker Compose** — контейнеризація  

---

## ⚙️ Налаштування та запуск

1. Клонувати репозиторій:

```bash
git clone https://github.com/SerhiiOsmolovskyi/DevOps_HW_3_Serhii_Osmolovskyi.git
cd DevOps_HW_3_Serhii_Osmolovskyi
Перейти на гілку lesson-4:

bash
git checkout lesson-4
Створити та запустити контейнери:

bash
docker-compose up -d
Перевірити, що вебзастосунок доступний:

arduino
http://localhost
