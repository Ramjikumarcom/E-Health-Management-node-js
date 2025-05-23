// This script will be executed when MongoDB container starts for the first time
// It creates the necessary database, users, collections, and indexes

// Switch to the admin database to create application user
db = db.getSiblingDB('admin');

// Authenticate as the root user (credentials set in docker-compose.yml)
db.auth('root', 'rootpassword');

// Create the telemedicine database
db = db.getSiblingDB('telemedicine');

// Create an application user with restricted permissions
db.createUser({
  user: 'app_user',
  pwd: 'app_password',
  roles: [
    {
      role: 'readWrite',
      db: 'telemedicine'
    }
  ]
});

// Create collections needed by the application
db.createCollection('users');
db.createCollection('appointments');
db.createCollection('messages');
db.createCollection('medicalRecords');
db.createCollection('reports');

// Insert a default admin user
db.users.insertOne({
  name: 'Admin User',
  email: 'admin@example.com',
  password: '$2a$10$vI8aWBnW3fID.ZQ4/zo1G.q1lRps.9cGLcZEiGDMVr5yUP1KUOYTa', // hashed password: 'password'
  role: 'admin',
  status: 'active',
  createdAt: new Date(),
  updatedAt: new Date()
});

// Create indexes for better performance
db.users.createIndex({ email: 1 }, { unique: true });
db.appointments.createIndex({ doctorId: 1, date: 1 });
db.appointments.createIndex({ patientId: 1 });
db.messages.createIndex({ sender: 1, receiver: 1 });
db.medicalRecords.createIndex({ patientId: 1 });

// Log completion
print('MongoDB initialization completed successfully');
