-- Create departments table
CREATE TABLE IF NOT EXISTS departments (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    manager_id BIGINT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create employees table
CREATE TABLE IF NOT EXISTS employees (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone_number VARCHAR(50),
    job_title VARCHAR(255) NOT NULL,
    salary DECIMAL(15, 2) NOT NULL,
    department_id BIGINT,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Create indexes
CREATE INDEX idx_employees_email ON employees(email);
CREATE INDEX idx_employees_department_id ON employees(department_id);
CREATE INDEX idx_employees_job_title ON employees(job_title);
CREATE INDEX idx_departments_name ON departments(name);

-- Insert sample departments
INSERT INTO departments (name, description, manager_id) VALUES
('Engineering', 'Software development and technical operations', NULL),
('Human Resources', 'Employee management and recruitment', NULL),
('Sales', 'Business development and client relations', NULL),
('Marketing', 'Brand management and digital marketing', NULL),
('Finance', 'Financial planning and accounting', NULL);

-- Insert sample employees
INSERT INTO employees (first_name, last_name, email, phone_number, job_title, salary, department_id) VALUES
('John', 'Doe', 'john.doe@talentix.com', '+1-555-0101', 'Software Engineer', 95000.00, 1),
('Jane', 'Smith', 'jane.smith@talentix.com', '+1-555-0102', 'Senior Software Engineer', 120000.00, 1),
('Michael', 'Johnson', 'michael.johnson@talentix.com', '+1-555-0103', 'HR Manager', 85000.00, 2),
('Emily', 'Brown', 'emily.brown@talentix.com', '+1-555-0104', 'Sales Representative', 75000.00, 3),
('David', 'Wilson', 'david.wilson@talentix.com', '+1-555-0105', 'Marketing Specialist', 70000.00, 4),
('Sarah', 'Davis', 'sarah.davis@talentix.com', '+1-555-0106', 'Financial Analyst', 80000.00, 5),
('Robert', 'Martinez', 'robert.martinez@talentix.com', '+1-555-0107', 'DevOps Engineer', 105000.00, 1),
('Lisa', 'Anderson', 'lisa.anderson@talentix.com', '+1-555-0108', 'HR Coordinator', 60000.00, 2),
('James', 'Taylor', 'james.taylor@talentix.com', '+1-555-0109', 'Senior Sales Manager', 110000.00, 3),
('Jennifer', 'Thomas', 'jennifer.thomas@talentix.com', '+1-555-0110', 'Content Marketing Manager', 85000.00, 4);

-- Update manager IDs
UPDATE departments SET manager_id = 2 WHERE name = 'Engineering';
UPDATE departments SET manager_id = 3 WHERE name = 'Human Resources';
UPDATE departments SET manager_id = 9 WHERE name = 'Sales';
UPDATE departments SET manager_id = 10 WHERE name = 'Marketing';
UPDATE departments SET manager_id = 6 WHERE name = 'Finance';