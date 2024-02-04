#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Download IAM policy document
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json

# Create IAM policy
aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam_policy.json

# Associate IAM OIDC provider
eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=Three-Tier-K8s-EKS-Cluster --approve

# Create IAM service account for aws-load-balancer-controller
eksctl create iamserviceaccount \
  --cluster=Three-Tier-K8s-EKS-Cluster \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::4901-0829-5743:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve \
  --region=us-east-1

# Install Helm (if not installed)
if ! command -v helm &> /dev/null; then
    sudo snap install helm --classic
fi

# Add Helm repository
helm repo add eks https://aws.github.io/eks-charts
helm repo update eks

# Install AWS Load Balancer Controller using Helm
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=my-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller

