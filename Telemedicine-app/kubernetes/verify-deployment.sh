#!/bin/bash

# Verify Kubernetes Deployment for E-Health Management Application
echo "Verifying Kubernetes deployment for E-Health Management Application..."

# Check if kubectl is installed
if ! command -v kubectl &> /dev/null; then
    echo "kubectl is not installed. Please install kubectl first."
    exit 1
fi

# Check if namespace exists
if kubectl get namespace e-health &> /dev/null; then
    echo "✓ Namespace e-health exists"
else
    echo "✗ Namespace e-health does not exist"
    echo "Creating namespace..."
    kubectl create namespace e-health
fi

# Check if ConfigMap exists
if kubectl -n e-health get configmap e-health-config &> /dev/null; then
    echo "✓ ConfigMap e-health-config exists"
else
    echo "✗ ConfigMap e-health-config does not exist"
fi

# Check if Secret exists
if kubectl -n e-health get secret e-health-secrets &> /dev/null; then
    echo "✓ Secret e-health-secrets exists"
else
    echo "✗ Secret e-health-secrets does not exist"
fi

# Check if deployments exist
echo "Checking deployments..."
for deployment in mongodb backend frontend; do
    if kubectl -n e-health get deployment $deployment &> /dev/null; then
        echo "✓ Deployment $deployment exists"
        
        # Check if pods are running
        READY=$(kubectl -n e-health get deployment $deployment -o jsonpath='{.status.readyReplicas}')
        if [ "$READY" == "1" ]; then
            echo "  ✓ Deployment $deployment has 1 ready replica"
        else
            echo "  ✗ Deployment $deployment has $READY ready replicas (expected 1)"
        fi
    else
        echo "✗ Deployment $deployment does not exist"
    fi
done

# Check if services exist
echo "Checking services..."
for service in mongodb backend frontend; do
    if kubectl -n e-health get service $service &> /dev/null; then
        echo "✓ Service $service exists"
        
        # Get service port
        PORT=$(kubectl -n e-health get service $service -o jsonpath='{.spec.ports[0].nodePort}')
        if [ -n "$PORT" ]; then
            echo "  ✓ Service $service is exposed on NodePort $PORT"
        else
            CLUSTER_IP=$(kubectl -n e-health get service $service -o jsonpath='{.spec.clusterIP}')
            PORT=$(kubectl -n e-health get service $service -o jsonpath='{.spec.ports[0].port}')
            echo "  ✓ Service $service is available at $CLUSTER_IP:$PORT (ClusterIP)"
        fi
    else
        echo "✗ Service $service does not exist"
    fi
done

# Display all resources in the namespace
echo -e "\nAll resources in e-health namespace:"
kubectl -n e-health get all

echo -e "\nVerification completed!"
echo "If any components are missing, run the Jenkins pipeline again or manually apply the Kubernetes manifests."
echo "To access the application:"
BACKEND_PORT=$(kubectl -n e-health get service backend -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)
FRONTEND_PORT=$(kubectl -n e-health get service frontend -o jsonpath='{.spec.ports[0].nodePort}' 2>/dev/null)

if [ -n "$BACKEND_PORT" ]; then
    echo "- Backend API: http://localhost:$BACKEND_PORT"
fi

if [ -n "$FRONTEND_PORT" ]; then
    echo "- Frontend: http://localhost:$FRONTEND_PORT"
fi
