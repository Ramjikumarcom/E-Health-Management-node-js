const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();
// Routes
const authRoutes = require('./routes/auth');
const appointmentRoutes = require('./routes/appointment');
const userRoutes = require('./routes/user');
const messageRoutes = require('./routes/message');
const medicalRecordRoutes = require('./routes/medicalRecord'); 
const reportRoutes = require('./routes/reports'); 
const adminRoutes = require('./routes/admin'); 
const availabilityRoutes = require('./routes/availability'); 

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/appointments', appointmentRoutes);
app.use('/api/users', userRoutes);
app.use('/api/messages', messageRoutes);
app.use('/api/medical-history', medicalRecordRoutes); 
app.use('/api/reports', reportRoutes); 
app.use('/api/admin', adminRoutes); 
app.use('/api/availability', availabilityRoutes); 

// Test Route
app.get('/', (req, res) => {
  res.send("Telemedicine API Running");
});

// Global Error Handler
app.use((err, req, res, next) => {
  console.error(err.stack);
  const statusCode = err.statusCode || 500;
  res.status(statusCode).json({
    status: 'error',
    message: err.message || 'Internal Server Error',
    ...(process.env.NODE_ENV === 'development' && { stack: err.stack })
  });
});

// 404 Handler - Keep this after all valid routes
app.use((req, res) => {
  res.status(404).json({ status: 'error', message: 'Route not found' });
});

// DB Connection with improved error handling
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  serverSelectionTimeoutMS: 5000,
  connectTimeoutMS: 5000
})
  .then(() => console.log("Connected to MongoDB"))
  .catch(err => {
    console.error("MongoDB connection error:", err);
    process.exit(1); // Exit on database connection failure
  });

// Server Start
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));

// Handle unhandled promise rejections
process.on('unhandledRejection', (err) => {
  console.error('UNHANDLED REJECTION! Shutting down...', err.name, err.message);
  console.error(err.stack);
  process.exit(1);
});

// Handle uncaught exceptions
process.on('uncaughtException', (err) => {
  console.error('UNCAUGHT EXCEPTION! Shutting down...', err.name, err.message);
  console.error(err.stack);
  process.exit(1);
});