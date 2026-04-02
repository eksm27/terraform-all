-- Create Database
CREATE DATABASE IF NOT EXISTS users;

-- Create Application User
CREATE USER IF NOT EXISTS 'appuser'@'%' IDENTIFIED BY 'apppassword';

-- Grant Permissions
GRANT ALL PRIVILEGES ON users.* TO 'appuser'@'%';

FLUSH PRIVILEGES;

-- Use Database
USE users;

-- Create Users Table
CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(100),
  mobile VARCHAR(20),
  location VARCHAR(100),
  dob DATE,
  photo_url TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);