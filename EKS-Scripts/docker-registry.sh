#!/bin/bash
# deploy_docker_registry.sh

# Set AWS account ID and region
ACCOUNTID="4901-0829-5743"
REGION="us-east-1"

# AWS ECR login
echo "Logging in to AWS ECR..."
if ! aws ecr get-login-password --region "${REGION}" | docker login --username AWS --password-stdin "${ACCOUNTID}.dkr.ecr.${REGION}.amazonaws.com"; then
    echo "Error: Failed to log in to AWS ECR. Please check your AWS credentials and try again."
    exit 1
fi
echo "Successfully logged in to AWS ECR."

# Create Kubernetes namespace
NAMESPACE="three-tier"
echo "Creating Kubernetes namespace: ${NAMESPACE}"
kubectl create namespace "${NAMESPACE}" || {
    echo "Error: Failed to create namespace ${NAMESPACE}. Please check your Kubernetes configuration."
    exit 1
}
echo "Namespace ${NAMESPACE} created successfully."

# Create Kubernetes secret for ECR registry
echo "Creating Kubernetes secret for ECR registry..."
kubectl create secret generic ecr-registry-secret \
  --from-file=.dockerconfigjson="${HOME}/.docker/config.json" \
  --type=kubernetes.io/dockerconfigjson --namespace "${NAMESPACE}" || {
    echo "Error: Failed to create Kubernetes secret. Please check your Docker configuration and try again."
    exit 1
}
echo "Kubernetes secret created successfully."

# Display available secrets in the namespace
echo "Available secrets in namespace ${NAMESPACE}:"
kubectl get secrets -n "${NAMESPACE}"
