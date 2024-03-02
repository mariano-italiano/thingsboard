# Thingsboard Repository
Repo for thingsboard carport project

## Prerequisites

To install whole platform there is a requirement to install ansible. It can be done by executing following command:
```sh
source install/ansible-install.sh
```

## Installation

Once Ansible is installed, please run the following playbook:
```sh
ansible-playbook install/install-tb.yaml
```

The playbook above will proceed with following tasks:
- install KinD Prerequisites
- install KinD and create K8s cluster
- deploy NGINX Ingress on top of K8s cluster
- deploy ArgoCD within K8s cluster
- expose the ArgoCD via NGINX Ingress
