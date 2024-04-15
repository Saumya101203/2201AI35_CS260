-- Comment in MYSQL 
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255),
    location VARCHAR(255),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
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
-- 1
DELIMITER //

CREATE PROCEDURE CalculateAverageSalary(IN department_id INT)
BEGIN
    DECLARE avg_salary DECIMAL(10,2);
    SELECT AVG(salary) INTO avg_salary FROM employees WHERE department_id = department_id;
    SELECT avg_salary;
END//

DELIMITER ;
-- 2
DELIMITER //

CREATE PROCEDURE UpdateEmployeeSalaryByPercentage(IN employee_id INT, IN percentage DECIMAL(5,2))
BEGIN
    UPDATE employees SET salary = salary * (1 + percentage/100) WHERE emp_id = employee_id;
END//

DELIMITER ;
-- 3
DELIMITER //

CREATE PROCEDURE ListEmployeesInDepartment(IN department_id INT)
BEGIN
    SELECT * FROM employees WHERE department_id = department_id;
END//

DELIMITER ;
-- 4
DELIMITER //

CREATE PROCEDURE CalculateTotalProjectBudget(IN project_id INT)
BEGIN
    DECLARE total_budget DECIMAL(10,2);
    SELECT budget INTO total_budget FROM projects WHERE project_id = project_id;
    SELECT total_budget;
END//

DELIMITER ;
-- 5
DELIMITER //

CREATE PROCEDURE FindEmployeeWithHighestSalary(IN department_id INT)
BEGIN
    SELECT * FROM employees WHERE department_id = department_id ORDER BY salary DESC LIMIT 1;
END//

DELIMITER ;
-- 6
DELIMITER //

CREATE PROCEDURE ListProjectsEndingWithinDays(IN num_days INT)
BEGIN
    SELECT * FROM projects WHERE end_date <= DATE_ADD(CURDATE(), INTERVAL num_days DAY);
END//

DELIMITER ;
-- 7
DELIMITER //

CREATE PROCEDURE CalculateTotalSalaryExpenditure(IN department_id INT)
BEGIN
    DECLARE total_salary DECIMAL(10,2);
    SELECT SUM(salary) INTO total_salary FROM employees WHERE department_id = department_id;
    SELECT total_salary;
END//

DELIMITER ;
-- 8
DELIMITER //

CREATE PROCEDURE GenerateEmployeeReport()
BEGIN
    SELECT e.*, d.department_name, d.location FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id;
END//

DELIMITER ;
-- 9
DELIMITER //

CREATE PROCEDURE FindProjectWithHighestBudget()
BEGIN
    SELECT * FROM projects ORDER BY budget DESC LIMIT 1;
END//

DELIMITER ;
-- 10
DELIMITER //

CREATE PROCEDURE CalculateOverallAverageSalary()
BEGIN
    DECLARE avg_salary DECIMAL(10,2);
    SELECT AVG(salary) INTO avg_salary FROM employees;
    SELECT avg_salary;
END//

DELIMITER ;
-- 11
DELIMITER //

CREATE PROCEDURE AssignNewManager(IN department_id INT, IN new_manager_id INT)
BEGIN
    UPDATE departments SET manager_id = new_manager_id WHERE department_id = department_id;
END//

DELIMITER ;
-- 12
DELIMITER //

CREATE PROCEDURE CalculateRemainingProjectBudget(IN project_id INT)
BEGIN
    DECLARE remaining_budget DECIMAL(10,2);
    SELECT budget - SUM(salary) INTO remaining_budget FROM projects p
    INNER JOIN employees e ON p.project_id = e.department_id
    WHERE p.project_id = project_id;
    SELECT remaining_budget;
END//

DELIMITER ;
-- 13
DELIMITER //

CREATE PROCEDURE GenerateEmployeeJoinReport(IN join_year YEAR)
BEGIN
    SELECT * FROM employees WHERE YEAR(joined_date) = join_year;
END//

DELIMITER ;
-- 14
DELIMITER //

CREATE PROCEDURE UpdateProjectEndDate(IN project_id INT, IN duration_days INT)
BEGIN
    UPDATE projects SET end_date = DATE_ADD(start_date, INTERVAL duration_days DAY) WHERE project_id = project_id;
END//

DELIMITER ;
-- 15
DELIMITER //

CREATE PROCEDURE CalculateTotalEmployeesPerDepartment()
BEGIN
    SELECT department_id, COUNT(*) AS total_employees FROM employees GROUP BY department_id;
END//

DELIMITER ;
