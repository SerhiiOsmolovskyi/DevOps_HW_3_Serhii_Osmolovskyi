# Використовуємо офіційний Python
FROM python:3.10

# Встановлюємо робочу директорію
WORKDIR /app

# Копіюємо залежності
COPY requirements.txt /app/

# Встановлюємо залежності
RUN pip install --upgrade pip && pip install -r requirements.txt

# Копіюємо весь проект
COPY . /app/

# Відкриваємо порт для Django
EXPOSE 8000

# Команда для запуску
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
