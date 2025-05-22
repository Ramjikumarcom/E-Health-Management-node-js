# Telemedicine App Docker Setup

This document provides instructions for running the Telemedicine application using Docker containers.

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Security Note

Before deploying to production, make sure to:
1. Change the JWT_SECRET in the docker-compose.yml file
2. Consider using Docker secrets or environment files for sensitive information
3. Set up proper network security rules

## Getting Started

1. Clone the repository
2. Navigate to the project directory

## Configuration

Before building the containers, you should modify the following:

1. In `docker-compose.yml`:
   - Replace `your_jwt_secret_key_here` with a strong secret key
   - Adjust port mappings if needed

## Building and Running

From the root directory of the project, run:

```bash
docker-compose up -d
```

This will:
- Build the MongoDB container
- Build the backend Node.js container
- Build the frontend React container
- Create a Docker network for all services
- Start all containers

## Accessing the Application

- Frontend: http://localhost:3000
- Backend API: http://localhost:5000
- MongoDB: localhost:27017 (accessible to backend)

## Stopping the Application

```bash
docker-compose down
```

To remove all data (including the MongoDB volume):

```bash
docker-compose down -v
```

## Viewing Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs frontend
docker-compose logs backend
docker-compose logs mongodb
```

## Rebuilding After Changes

```bash
docker-compose up -d --build
```

## Container Structure

- **frontend**: React application served with serve
- **backend**: Node.js/Express API server
- **mongodb**: MongoDB database server

## Data Persistence

MongoDB data is stored in a Docker volume named `mongodb_data` for persistence across container restarts.
