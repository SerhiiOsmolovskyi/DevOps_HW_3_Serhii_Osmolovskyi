#!/bin/bash

# Оновлення списку пакетів
echo "🔄 Оновлення системи..."
sudo apt update -y && sudo apt upgrade -y

# Функція перевірки наявності команди
check_installed() {
    command -v "$1" >/dev/null 2>&1
}

# 1. Встановлення Docker
if check_installed docker; then
    echo "✅ Docker вже встановлено."
else
    echo "📦 Встановлення Docker..."
    sudo apt-get install ca-certificates curl gnupg -y
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update -y
    sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    echo "✅ Docker встановлено."
fi

# 2. Встановлення Docker Compose
if check_installed docker-compose; then
    echo "✅ Docker Compose вже встановлено."
else
    echo "📦 Встановлення Docker Compose..."
    sudo apt install docker-compose -y
    echo "✅ Docker Compose встановлено."
fi

# 3. Встановлення Python 3.9+
if check_installed python3; then
    PYTHON_VERSION=$(python3 -V | awk '{print $2}')
    echo "✅ Python $PYTHON_VERSION вже встановлено."
else
    echo "📦 Встановлення Python..."
    sudo apt install python3 python3-pip -y
    echo "✅ Python встановлено."
fi

# 4. Встановлення Django
if python3 -m django --version >/dev/null 2>&1; then
    echo "✅ Django вже встановлено."
else
    echo "📦 Встановлення Django..."
    pip3 install django
    echo "✅ Django встановлено."
fi

echo "🎉 Усі інструменти встановлено або вже були в системі!"
