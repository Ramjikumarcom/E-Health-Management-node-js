#!/bin/bash

# Deploy E-Health Management Application to Kubernetes
echo "Deploying E-Health Management Application to Kubernetes..."

# Apply all resources using kustomize
kubectl apply -k .

# Wait for deployments to be ready
echo "Waiting for deployments to be ready..."
kubectl -n e-health wait --for=condition=available --timeout=300s deployment/mongodb
kubectl -n e-health wait --for=condition=available --timeout=300s deployment/backend
kubectl -n e-health wait --for=condition=available --timeout=300s deployment/frontend

# Get the NodePort services
echo "Services are available at:"
BACKEND_PORT=$(kubectl -n e-health get svc backend -o jsonpath='{.spec.ports[0].nodePort}')
FRONTEND_PORT=$(kubectl -n e-health get svc frontend -o jsonpath='{.spec.ports[0].nodePort}')

echo "Backend: http://localhost:$BACKEND_PORT"
echo "Frontend: http://localhost:$FRONTEND_PORT"

# Show running pods
echo "Running pods:"
kubectl -n e-health get pods

echo "Deployment completed successfully!"
