FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Ставимо системні залежності (якщо будуть міграції/бібліотеки)
RUN apt-get update && apt-get install -y \
    build-essential \
 && rm -rf /var/lib/apt/lists/*

# Спочатку requirements (щоб кешувався шар)
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Далі — весь код
COPY . /app/

EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
