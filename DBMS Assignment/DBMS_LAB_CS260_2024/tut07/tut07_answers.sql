-- Comment in MYSQL 
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255),
    location VARCHAR(255),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id) -- Corrected field name
);

INSERT INTO departments (department_id, department_name, location, manager_id)
VALUES 
    (1, 'Engineering', 'New Delhi', 3),
    (2, 'Sales', 'Mumbai', 5),
    (3, 'Finance', 'Kolkata', 4);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

INSERT INTO employees (emp_id, first_name, last_name, salary, department_id)
VALUES 
    (1, 'Rahul', 'Kumar', 60000.00, 1),
    (2, 'Neha', 'Sharma', 55000.00, 2),
    (3, 'Krishna', 'Singh', 62000.00, 1),
    (4, 'Pooja', 'Verma', 58000.00, 3),
    (5, 'Rohan', 'Gupta', 59000.00, 2);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(255),
    budget DECIMAL(10, 2),
    start_date DATE,
    end_date DATE
);

INSERT INTO projects (project_id, project_name, budget, start_date, end_date)
VALUES 
    (101, 'ProjectA', 100000.00, '2023-01-01', '2023-06-30'),
    (102, 'ProjectB', 80000.00, '2023-02-15', '2023-08-15'),
    (103, 'ProjectC', 120000.00, '2023-03-20', '2023-09-30');
