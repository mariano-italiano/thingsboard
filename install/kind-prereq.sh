#!/bin/bash

### INSTALL DOCKER ###

# Uninstall old versions
for pkg in docker.io docker-doc docker-compose podman-docker containerd runc; do sudo apt-get remove $pkg; done

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg 
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Install docker packages
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start and enable service
sudo systemctl enable --now docker

# Add your account to Docker group
sudo usermod -aG docker $USER

DOCKER_VER=`docker version | grep -i "^ Version" | cut -d : -f2 | tr -d " "`

### INSTALL KUBECTL ###

sudo curl -L "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl
sudo chmod +x /usr/local/bin/kubectl
KUBECTL_VER=`kubectl version --client | grep -i "client Version" | cut -d : -f2 | tr -d " "`

# INSTALL BASH COMPLETION
sudo apt-get install bash-completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
source ~/.bashrc

# INSTALL HELM
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

### SHOW INSTALATION DETAIL ###

echo
if [[ ! -z "$DOCKER_VER" ]]; then
        echo -e "DOCKER ENGINE INSTALLATION \t\t\t\t [ \033[32mSUCCESS\033[0m ]"
        echo "DOCKER VERSION: $DOCKER_VER"
else
        echo -e "DOCKER ENGINE INSTALLATION \t\t\t\t [ \033[31mFAILED\033[0m  ]"
fi

echo

if [[ ! -z "$KUBECTL_VER" ]]; then
        echo -e "KUBECTL INSTALLATION \t\t\t\t\t [ \033[32mSUCCESS\033[0m ]"
        echo "KUBECTL VERSION: $KUBECTL_VER"
else
        echo -e "KUBECTL INSTALLATION \t\t\t\t\t [ \033[31mFAILED\033[0m  ]"
fi

echo
echo -e "\033[33mNote: Please logout of your SSH session and log back in."
echo -e "This is required to take effect of Docker changes that were applied to a user '$USER'\033[0m."
echo
