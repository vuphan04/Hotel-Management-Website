-- MySQL / phpMyAdmin-compatible version of your tables
-- Converted only for syntax compatibility (SERIAL/REFERENCES -> AUTO_INCREMENT + FOREIGN KEY)

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS work_schedules;
DROP TABLE IF EXISTS service_usage;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS rooms;
DROP TABLE IF EXISTS customers;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE customers (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    id_passport VARCHAR(20)
) ENGINE=InnoDB;

CREATE TABLE rooms (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL,
    room_type VARCHAR(50),
    price DECIMAL(10, 2),
    status VARCHAR(20),
    description TEXT,
    image TEXT
) ENGINE=InnoDB;

CREATE TABLE bookings (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    customer_id BIGINT UNSIGNED,
    room_id BIGINT UNSIGNED,
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL,
    status VARCHAR(20),
    CONSTRAINT fk_bookings_customer FOREIGN KEY (customer_id)
        REFERENCES customers(id) ON DELETE CASCADE,
    CONSTRAINT fk_bookings_room FOREIGN KEY (room_id)
        REFERENCES rooms(id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE invoices (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT UNSIGNED NOT NULL,
    invoice_number VARCHAR(255) NOT NULL UNIQUE,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    subtotal DECIMAL(10, 2) NOT NULL,
    tax DECIMAL(10, 2) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    status ENUM('Pending', 'Paid', 'Overdue', 'Cancelled') DEFAULT 'Pending',
    payment_method ENUM('Cash', 'Credit Card', 'Bank Transfer') DEFAULT NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT fk_booking_invoice FOREIGN KEY (booking_id)
        REFERENCES bookings(id)
) ENGINE=InnoDB;

CREATE TABLE employees (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    position VARCHAR(50),
    salary DECIMAL(10, 2)
) ENGINE=InnoDB;

CREATE TABLE services (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE service_usage (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    booking_id BIGINT UNSIGNED,
    service_id BIGINT UNSIGNED,
    quantity INT DEFAULT 1,
    total_price DECIMAL(10, 2),
    CONSTRAINT fk_service_usage_booking FOREIGN KEY (booking_id)
        REFERENCES bookings(id) ON DELETE CASCADE,
    CONSTRAINT fk_service_usage_service FOREIGN KEY (service_id)
        REFERENCES services(id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE work_schedules (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    employee_id BIGINT UNSIGNED,
    work_date DATE NOT NULL,
    shift VARCHAR(20),
    CONSTRAINT fk_work_schedules_employee FOREIGN KEY (employee_id)
        REFERENCES employees(id) ON DELETE CASCADE
) ENGINE=InnoDB;
