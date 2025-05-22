#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Apply Kubernetes manifests in the correct order
echo "Creating Kubernetes resources for Telemedicine application..."

# Create namespace first
kubectl apply -f namespace.yaml
echo "Namespace created"

# Apply ConfigMap and Secret
kubectl apply -f configmap.yaml
echo "ConfigMap created"
kubectl apply -f secret.yaml
echo "Secret created"

# Apply MongoDB deployment
kubectl apply -f mongodb.yaml
echo "MongoDB resources created"

# Wait for MongoDB to be ready (with a longer timeout)
echo "Waiting for MongoDB to be ready..."
kubectl wait --namespace=telemedicine --for=condition=ready pod -l app=mongodb --timeout=180s || {
  echo "Warning: MongoDB pods not ready in time, but continuing deployment"
  kubectl get pods -n telemedicine -l app=mongodb
}

# Apply Backend deployment
kubectl apply -f backend.yaml
echo "Backend resources created"

# Wait for Backend to be ready (with a longer timeout)
echo "Waiting for Backend to be ready..."
kubectl wait --namespace=telemedicine --for=condition=ready pod -l app=backend --timeout=180s || {
  echo "Warning: Backend pods not ready in time, but continuing deployment"
  kubectl get pods -n telemedicine -l app=backend
}

# Apply Frontend deployment
kubectl apply -f frontend.yaml
echo "Frontend resources created"

# Check if ingress controller is installed
if kubectl get ingressclass 2>/dev/null | grep -q "nginx"; then
  # Apply Ingress
  kubectl apply -f ingress.yaml
  echo "Ingress created"
else
  echo "Warning: No ingress controller found. Skipping ingress creation."
  echo "To access the application, you'll need to use port-forwarding or a NodePort service."
  
  # Create a NodePort service for the frontend as a fallback
  cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: frontend-nodeport
  namespace: telemedicine
spec:
  selector:
    app: frontend
  ports:
  - port: 3000
    targetPort: 3000
    nodePort: 30080
  type: NodePort
EOF
  echo "Created NodePort service for frontend on port 30080"
fi

echo "Deployment complete! Your application should be available shortly."
echo "To check the status of your pods, run: kubectl get pods -n telemedicine"
echo "To check the services, run: kubectl get svc -n telemedicine"
echo "To check the ingress, run: kubectl get ingress -n telemedicine"
