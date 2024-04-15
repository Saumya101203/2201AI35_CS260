-- General Instructions
-- 1.	The .sql files are run automatically, so please ensure that there are no syntax errors in the file. If we are unable to run your file, you get an automatic reduction to 0 marks.
-- Comment in MYSQL 

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255),
    location VARCHAR(255),
    manager_id INT
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    salary DECIMAL(10, 2),
    department_id INT
);


ALTER TABLE employees
ADD CONSTRAINT fk_department_id
FOREIGN KEY (department_id) REFERENCES departments(department_id);

ALTER TABLE departments
ADD CONSTRAINT fk_manager_id
FOREIGN KEY (manager_id) REFERENCES employees(emp_id);

CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(255),
    budget DECIMAL(10,2),
    start_date DATE,
    end_date DATE
);


INSERT INTO projects (project_id, project_name, budget, start_date, end_date) VALUES
(101, 'ProjectA', 100000, '2023-01-01', '2023-06-30'),
(102, 'ProjectB', 80000, '2023-02-15', '2023-08-15'),
(103, 'ProjectC', 120000, '2023-03-20', '2023-09-30');


-- 2
SELECT first_name, salary FROM employees;
-- 4
SELECT * FROM employees
WHERE salary > 60000;
-- 6
SELECT * FROM employees, projects;
-- 8
SELECT * FROM departments
NATURAL JOIN projects;
-- 10
SELECT * FROM projects
WHERE budget > 100000;
-- 12
(SELECT * FROM employees WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Engineering'))
UNION
(SELECT * FROM employees WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Finance'));
-- 14
SELECT * FROM employees
LEFT JOIN employee_projects ON employees.emp_id = employee_projects.emp_id;
