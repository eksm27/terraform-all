CREATE DATABASE IF NOT EXISTS users;

CREATE USER IF NOT EXISTS 'appuser'@'%' IDENTIFIED BY 'apppassword';
GRANT ALL PRIVILEGES ON users.* TO 'appuser'@'%';
FLUSH PRIVILEGES;

USE users;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100) UNIQUE,
  password VARCHAR(100),
  mobile VARCHAR(20),
  location VARCHAR(100),
  dob DATE
);