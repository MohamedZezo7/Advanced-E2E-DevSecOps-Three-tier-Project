#!/bin/bash

NAMESPACE=argo-cd
RELEASE_NAME=argo

if ./create-eks.sh && [ $? -eq 0 ]; then
   echo " !!! Eks is Ready !!! "

   echo " Create Argo-cd namespace "
   kubectl create namespace ${NAMESPACE} || true 

   echo " Deploy argo-cd on eks "
   helm repo add argo https://argoproj.github.io/argo-helm
   helm repo update
   helm install ${RELEASE_NAME} argo/argo-cd -n ${NAMESPACE} || true 

   echo " Wait Pods to Start "
   sleep 2m

   echo " change argocd service to LOAD Balancer "
   kubectl patch svc ${RELEASE_NAME}-argocd-server -n ${NAMESPACE} -p '{"spec": {"type": "LoadBalancer"}}'

   echo "--------------------Creating External-IP--------------------"
   sleep 10s

   echo "--------------------Argocd Ex-URL--------------------"
   kubectl get service ${RELEASE_NAME}-argocd-server -n ${NAMESPACE} | awk '{print $4}'

   echo "--------------------ArgoCD UI Password--------------------"
   echo "Username: admin"
   kubectl -n ${NAMESPACE} get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d > argo-pass.txt

else
   echo " Eks is not working "
fi

