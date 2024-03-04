# Thingsboard Repository
Repo for thingsboard carport project

## Prerequisites

### Clone Repository

Login via SSH to Linux (as `root`)and execute below command:
```sh
git clone https://github.com/mariano-italiano/thingsboard.git
cd thingsboard/install
```

### Install Ansible

To install whole platform there is a requirement to install ansible. It can be done by executing following command:
```sh
source ansible-install.sh
```

## Installation

Once Ansible is installed, please run the following playbook:
```sh
ansible-playbook install-tb.yaml 
```

The playbook above will proceed with following tasks:
- install KinD Prerequisites
- install KinD and create K8s cluster
- deploy NGINX Ingress on top of K8s cluster
- deploy ArgoCD within K8s cluster
- expose the ArgoCD via NGINX Ingress
- configure 3 ArgoCD applications to fully deploy ThingsBoard on Kubernetes
  - create postgress application
  - create thirdparty application
  - create Thingsboard application
- show post installation details for user
