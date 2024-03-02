#!/bin/bash

kubectl create namespace argocd
ARGO_STATUS=`kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml`

sleep 5

#ARGO_PATCH=`kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer", "externalIPs":["'"$IP"'"]}}'`
#ARGO_PATCH=`kubectl patch svc argocd-server -n argocd --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"},{"op":"replace","path":"/spec/ports/0/nodePort","value":31080},{"op":"replace","path":"/spec/ports/1/nodePort","value":30443}]'`

### SHOW INSTALATION DETAILS ###

echo
if [[ ! -z "$ARGO_STATUS" ]]; then
        echo -e "ARGOCD INSTALLATION \t\t\t\t [ \033[32mSUCCESS\033[0m ]"
else
        echo -e "ARGOCD INSTALLATION \t\t\t\t [ \033[31mFAILED\033[0m  ]"
fi

#echo
#if [[ ! -z "$ARGO_PATCH" ]]; then
#        echo -e "ARGOCD SERVICE PATCHED \t\t\t\t [ \033[32mSUCCESS\033[0m ]"
#else
#        echo -e "ARGOCD SERVICE PATCHED \t\t\t\t [ \033[31mFAILED\033[0m  ]"
#fi

echo
echo "To validate the installation process execute:"
echo -e "\t kubectl get all -n argocd"
echo
echo "To get initial login credentials execute:"
echo -e "\t kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo"
echo
