#!/bin/bash

# INSTALL PREREQUISITES 

sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg 
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# INSTALL K3S KUBERNETES
curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="server" INSTALL_K3S_VERSION="v1.29.2+k3s1" sh -s - --server "https://$1" --bind-address "$1" --write-kubeconfig-mode 644 --disable traefik,servicelb --node-name k3s-master

# INSTALL BASH COMPLETION
sudo apt-get install bash-completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
source ~/.bashrc

# INSTALL HELM
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
