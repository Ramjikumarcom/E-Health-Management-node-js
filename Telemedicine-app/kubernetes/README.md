# Kubernetes Deployment for Telemedicine Application

This directory contains Kubernetes manifests for deploying the Telemedicine application in a Kubernetes cluster.

## Components

The deployment consists of:

1. **MongoDB** - Database for storing application data
2. **Backend** - Node.js API running on port 5000
3. **Frontend** - React application running on port 3000
4. **Ingress** - For routing external traffic to the appropriate services

## Prerequisites

Before deploying, ensure you have:

1. A running Kubernetes cluster
2. `kubectl` installed and configured to connect to your cluster
3. An Ingress controller installed in your cluster (e.g., NGINX Ingress Controller)
4. Docker images pushed to Docker Hub (the manifests use `gupta9939/e_health_management*:02` images)

## Required Credentials

You need to manually provide the following credentials:

1. **JWT Secret**: Update the `secret.yaml` file with your base64-encoded JWT secret
   ```bash
   echo -n "your_actual_jwt_secret" | base64
   ```
   Replace the placeholder value in `secret.yaml` with the output

2. **Domain Name**: If you're using a custom domain, update the host in `ingress.yaml`

3. **Storage Class**: If your Kubernetes cluster requires a specific storage class for persistent volumes, update the `mongodb.yaml` file

## Deployment Instructions

1. Review and modify the configuration files as needed:
   - `configmap.yaml` - Contains environment variables
   - `secret.yaml` - Contains sensitive information (update with actual values)
   - Other YAML files as needed for your specific environment

2. Run the deployment script:
   ```bash
   cd kubernetes
   ./deploy.sh
   ```

3. Verify the deployment:
   ```bash
   kubectl get pods -n telemedicine
   kubectl get svc -n telemedicine
   kubectl get ingress -n telemedicine
   ```

## Accessing the Application

- If using the default configuration with Ingress, access the application at: http://telemedicine.local
- If you're using a cloud provider with LoadBalancer support, you can change the service type in `frontend.yaml` and access via the assigned external IP

## Troubleshooting

If you encounter issues:

1. Check pod status:
   ```bash
   kubectl get pods -n telemedicine
   ```

2. Check pod logs:
   ```bash
   kubectl logs -n telemedicine <pod-name>
   ```

3. Check service endpoints:
   ```bash
   kubectl get endpoints -n telemedicine
   ```

4. For persistent volume issues:
   ```bash
   kubectl get pv,pvc -n telemedicine
   ```

## Scaling the Application

To scale the application components:

```bash
kubectl scale deployment backend -n telemedicine --replicas=3
kubectl scale deployment frontend -n telemedicine --replicas=3
```
