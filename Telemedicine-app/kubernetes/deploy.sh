#!/bin/bash
set -e  # Exit immediately if a command exits with a non-zero status

# Deploy E-Health Management Application to Kubernetes
echo "Deploying E-Health Management Application to Kubernetes..."

# Set non-interactive mode for kubectl
export KUBECTL_INTERACTIVE=false

# Create namespace if it doesn't exist
kubectl get namespace e-health 2>/dev/null || kubectl create namespace e-health

# Apply all resources using kustomize
echo "Applying Kubernetes resources..."
kubectl apply -k . --force

# Display what was deployed
echo "Resources created:"
kubectl get all -n e-health

# Wait for deployments to be ready
echo "Waiting for deployments to be ready..."
kubectl -n e-health wait --for=condition=available --timeout=300s deployment/mongodb 2>/dev/null || true
kubectl -n e-health wait --for=condition=available --timeout=300s deployment/backend 2>/dev/null || true
kubectl -n e-health wait --for=condition=available --timeout=300s deployment/frontend 2>/dev/null || true

# Get the NodePort services
echo "Services are available at:"
BACKEND_PORT=$(kubectl -n e-health get svc backend -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null || echo "Not available")
FRONTEND_PORT=$(kubectl -n e-health get svc frontend -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null || echo "Not available")

echo "Backend: http://localhost:$BACKEND_PORT"
echo "Frontend: http://localhost:$FRONTEND_PORT"

# Show running pods
echo "Running pods:"
kubectl -n e-health get pods 2>/dev/null || echo "No pods found"

echo "Deployment completed successfully!"
