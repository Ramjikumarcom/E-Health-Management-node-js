#!/bin/bash

# Apply Kubernetes manifests in the correct order
echo "Creating Kubernetes resources for Telemedicine application..."

# Create namespace first
kubectl apply -f namespace.yaml
echo "Namespace created"

# Apply ConfigMap and Secret
kubectl apply -f configmap.yaml
kubectl apply -f secret.yaml
echo "ConfigMap and Secret created"

# Apply MongoDB deployment
kubectl apply -f mongodb.yaml
echo "MongoDB resources created"

# Wait for MongoDB to be ready
echo "Waiting for MongoDB to be ready..."
kubectl wait --namespace=telemedicine --for=condition=ready pod -l app=mongodb --timeout=120s

# Apply Backend deployment
kubectl apply -f backend.yaml
echo "Backend resources created"

# Wait for Backend to be ready
echo "Waiting for Backend to be ready..."
kubectl wait --namespace=telemedicine --for=condition=ready pod -l app=backend --timeout=120s

# Apply Frontend deployment
kubectl apply -f frontend.yaml
echo "Frontend resources created"

# Apply Ingress
kubectl apply -f ingress.yaml
echo "Ingress created"

echo "Deployment complete! Your application should be available shortly."
echo "To check the status of your pods, run: kubectl get pods -n telemedicine"
echo "To check the services, run: kubectl get svc -n telemedicine"
echo "To check the ingress, run: kubectl get ingress -n telemedicine"
