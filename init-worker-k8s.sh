#!/bin/bash

# Exit on error
set -e

# Обновляем систему
sudo apt-get update && sudo apt-get upgrade -y

# Отключаем swap (Kubernetes требует отключения swap)
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
grep -q '^vm.swappiness=10' /etc/sysctl.conf || echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
sudo sed -i '/swap/s/^/#/' /etc/fstab

# Устанавливаем необходимые пакеты для Kubernetes
sudo apt-get install -y apt-transport-https ca-certificates curl

# Добавляем GPG ключ для Kubernetes репозитория
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.23/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

# Добавляем Kubernetes репозиторий
echo "Adding Kubernetes repository..."
sudo bash -c 'cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.23/deb/ /
EOF'

# Обновляем пакеты и устанавливаем kubelet, kubeadm и kubectl
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Установка Docker (если он не установлен)
sudo apt-get install -y docker.io
sudo systemctl enable docker
sudo systemctl start docker

# Инициализация кластера на мастер-узле (если это мастер)
# echo "Initializing Kubernetes cluster..."
# sudo kubeadm init --pod-network-cidr=10.244.0.0/16

# Настраиваем kubectl для текущего пользователя
# mkdir -p $HOME/.kube
# sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Устанавливаем сетевой плагин Flannel
# kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

# Вывод команды для добавления воркеров в кластер
# echo "Cluster initialized. Use the following command to join worker nodes:"
# kubeadm token create --print-join-command
