# Kubernetes Deployment for E-Health Management Application

This directory contains Kubernetes manifests for deploying the E-Health Management application.

## Architecture

The application consists of three main components:

1. **MongoDB** - Database for storing application data
2. **Backend** - Node.js backend API running on port 5000
3. **Frontend** - React.js frontend application

## Prerequisites

- Kubernetes cluster (Minikube, Docker Desktop Kubernetes, or a cloud provider)
- kubectl command-line tool
- Docker Hub account (for pulling images)

## Configuration

The deployment uses the following configuration:

- **Docker Images**:
  - MongoDB: `gupta9939/e_health_management:02`
  - Backend: `gupta9939/e_health_management_backend:02`
  - Frontend: `gupta9939/e_health_management_frontend:02`

- **Environment Variables**:
  - Stored in ConfigMap and Secret resources
  - Backend uses MongoDB connection string, JWT secret, and port
  - Frontend uses API base URL

## Deployment

### Manual Deployment

To deploy the application manually:

```bash
# Create namespace
kubectl apply -f namespace.yaml

# Apply all resources
kubectl apply -k .

# Check deployment status
kubectl -n e-health get pods
kubectl -n e-health get services
```

### CI/CD Integration

The application is automatically deployed through Jenkins CI/CD pipeline:

1. Jenkins builds Docker images for all components
2. Images are pushed to Docker Hub
3. Kubernetes manifests are applied to the cluster
4. Jenkins waits for deployments to be ready
5. Application is accessible via NodePort services

## Accessing the Application

- Backend API: http://localhost:30500
- Frontend: http://localhost:30300

## Troubleshooting

If you encounter issues with the deployment:

1. Check pod status:
   ```bash
   kubectl -n e-health get pods
   ```

2. View pod logs:
   ```bash
   kubectl -n e-health logs <pod-name>
   ```

3. Check service endpoints:
   ```bash
   kubectl -n e-health get endpoints
   ```

4. Verify ConfigMap and Secret:
   ```bash
   kubectl -n e-health describe configmap e-health-config
   kubectl -n e-health describe secret e-health-secrets
   ```

## Cleanup

To remove the application from your cluster:

```bash
kubectl delete namespace e-health
```
