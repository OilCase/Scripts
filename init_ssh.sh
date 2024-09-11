#!/bin/bash

# Обновление пакетов
echo "Обновление пакетов..."
sudo apt update

# Установка OpenSSH-сервера
echo "Установка OpenSSH-сервера..."
sudo apt install -y openssh-server

# Проверка статуса сервиса SSH
echo "Проверка статуса сервиса SSH..."
sudo systemctl status ssh

# Включение SSH-сервиса для автоматического запуска при старте системы
echo "Включение SSH-сервиса для автозапуска..."
sudo systemctl enable ssh

# Запуск SSH-сервиса (если он не запущен)
echo "Запуск SSH-сервиса..."
sudo systemctl start ssh

# Открытие порта 22 в firewall (если используется UFW)
if sudo ufw status | grep -q "Status: active"; then
  echo "Настройка firewall для разрешения порта 22..."
  sudo ufw allow 22/tcp
  sudo ufw reload
else
  echo "UFW не активен. Пропускаем настройку firewall."
fi

# Проверка статуса SSH
echo "Проверка статуса SSH после настройки..."
sudo systemctl status ssh

echo "Настройка завершена. SSH-сервер установлен и запущен."
