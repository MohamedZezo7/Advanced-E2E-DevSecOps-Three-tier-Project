#!/bin/bash

NAMESPACE=monitoring
RELEASE_NAME=prometheus-community

if ./create-eks.sh && [ $? -eq 0 ]; then
   echo " !!! Eks is Ready !!! "

   echo " Create Monitoring namespace "
   kubectl create namespace ${NAMESPACE} || true 

   echo " Deploy prometheus on eks "
   helm repo add stable https://charts.helm.sh/stable
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm repo update

   echo " Wait Pods to Start "
   sleep 2m

   echo " change prometheus service to NodePort "
   kubectl patch svc stable-kube-prometheus-sta-prometheus -n ${NAMESPACE} -p '{"spec": {"type": "LoadBalancer"}}'
   kubectl patch svc stable-grafana -n ${NAMESPACE} -p '{"spec": {"type": "LoadBalancer"}}'
   echo "--------------------Creating External-IP--------------------"
   sleep 10s

   echo "--------------------Prometheus & Grafana  Ex-URL--------------------"
   kubectl get service stable-kube-prometheus-sta-prometheus -n ${NAMESPACE} | awk '{print $4}'
   kubectl get service stable-grafana -n ${NAMESPACE} | awk '{print $4}'
   

else
   echo " Eks is not working "
fi
