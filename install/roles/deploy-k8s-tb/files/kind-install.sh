#!/bin/bash

# Read inputs
#read -p "Enter K8s server IP address: " IP
#read -p "Enter K8s version [v1.29.1]: " K8SVER
IP=$1

# Set K8s version if not provided
K8SVER=${K8SVER:-v1.29.1}

# Install KinD from Binaries
[ $(uname -m) = x86_64 ] && curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

KIND_VER=`kind version | cut -d " " -f2`

# Increase the ulimit for max_user_watches and max_user_instances
echo fs.inotify.max_user_watches=655360 | sudo tee -a /etc/sysctl.conf
echo fs.inotify.max_user_instances=1280 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Create cluster config file
cat > /root/cluster-config.yaml << EOF
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  apiServerAddress: "$IP"
  apiServerPort: 6443
  serviceSubnet: "10.96.0.0/12"
 # One control-plane and 2 worker nodes
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  # Ports for NodePort
  - containerPort: 30080
    hostPort: 30080
    protocol: TCP
  - containerPort: 30443
    hostPort: 30443
    protocol: TCP
  # Ports for Ingress
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
EOF

echo
echo "Ready to create clusters"
echo
kind create cluster --name k8s-cluster --image=kindest/node:$K8SVER --config /root/cluster-config.yaml
echo
echo "Installed clusters:"
KIND_CLUSTER=`kind get clusters`

echo
if [[ ! -z "$KIND_VER" ]]; then
        echo -e "KIND INSTALLATION \t\t\t\t\t [ \033[32mSUCCESS\033[0m ]"
        echo "KIND VERSION: $KIND_VER"
else
        echo -e "KIND INSTALLATION \t\t\t\t\t [ \033[31mFAILED\033[0m  ]"
fi

echo

if [[ ! -z "$KIND_CLUSTER" ]]; then
        echo -e "KIND CLUSTER CREATION \t\t\t\t\t [ \033[32mSUCCESS\033[0m ]"
        echo "KIND CLUSTER: $KIND_CLUSTER"
else
        echo -e "KIND CLUSTER CREATION \t\t\t\t\t [ \033[31mFAILED\033[0m  ]"
fi

echo

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.5.0/components.yaml
kubectl patch -n kube-system deployment metrics-server --type=json -p '[{"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"}]'
