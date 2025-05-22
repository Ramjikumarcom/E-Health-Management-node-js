# Ansible Configuration for E-Health Management Application

This directory contains Ansible playbooks and roles for deploying and configuring the E-Health Management application using Docker containers.

## Structure

- `site.yml` - Main playbook that orchestrates the entire deployment
- `inventory.ini` - Inventory file defining target hosts
- `ansible.cfg` - Ansible configuration file
- `roles/` - Directory containing role-specific tasks
  - `common/` - Basic system setup
  - `docker/` - Docker installation and configuration
  - `mongodb/` - MongoDB container deployment
  - `backend/` - Node.js backend container deployment
  - `frontend/` - React frontend container deployment

## Usage

### Local Deployment

To deploy the application locally:

```bash
cd ansible
ansible-playbook -i inventory.ini site.yml -c local
```

### Remote Deployment

1. Edit the `inventory.ini` file to add your remote servers under the `[production]` section.
2. Run the playbook targeting the production hosts:

```bash
cd ansible
ansible-playbook -i inventory.ini site.yml -l production
```

## Configuration

You can modify the variables in `site.yml` to customize the deployment:

- `docker_username`: Docker Hub username
- `app_version`: Version tag for Docker images
- `mongodb_port`: Port for MongoDB
- `backend_port`: Port for the backend service
- `frontend_port`: Port for the frontend service
- `mongo_uri`: MongoDB connection URI
- `jwt_secret`: Secret key for JWT authentication
- `react_app_api_base_url`: Base URL for API calls from the frontend

## Integration with Jenkins

The Ansible deployment is integrated with the Jenkins pipeline. The pipeline will:

1. Install Ansible if it's not already available
2. Run the Ansible playbook to deploy the application
3. Fall back to direct Docker commands if Ansible deployment fails

## Requirements

- Ansible 2.9+
- Python 3.6+
- Docker
- `docker` Python module (`pip install docker`)
