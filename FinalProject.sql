-- Create database
CREATE DATABASE SkoolFinance;

-- Use the database created
USE SkoolFinance;

-- Create Classes Table 
CREATE TABLE Classes (
    class_id INT PRIMARY KEY AUTO_INCREMENT,
    class_name VARCHAR(100) NOT NULL UNIQUE
);

-- Create Students Table 
CREATE TABLE Students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    class_id INT,
    admission_date DATE NOT NULL,
    date_of_birt DATE NOT NULL,
    FOREIGN KEY (class_id) REFERENCES Classes(class_id)
);

-- Create Fee Structure Table(School Fees)
CREATE TABLE FeeStructure (
    fee_id INT PRIMARY KEY AUTO_INCREMENT,
    class_id INT,
    term ENUM('First Term', 'Second Term', 'Third Term') NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    session_year YEAR NOT NULL,
    FOREIGN KEY (class_id) REFERENCES Classes(class_id),
    UNIQUE (class_id, term, session_year)
);

-- Create Payments Table
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    fee_id INT,
    amount_paid DECIMAL(10, 2) NOT NULL,
    payment_date DATE NOT NULL,
    payment_method ENUM('Cash', 'Bank Transfer', 'POS') NOT NULL,
    transaction_ref VARCHAR(100),
    receipt_number VARCHAR(50) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (fee_id) REFERENCES FeeStructure(fee_id)
);

-- Create Staff Table
CREATE TABLE Staff (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    designation VARCHAR(50) NOT NULL,
    hire_date DATE NOT NULL
);

-- Create Salaries Table
CREATE TABLE Salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT,
    salary_amount DECIMAL(10, 2) NOT NULL,
    salary_month VARCHAR(20) NOT NULL,
    payment_date DATE NOT NULL,
    due_date DATE,
    paid_status ENUM('Pending', 'Paid') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id)
);

-- Create Expenses Table e.g stationaries, 
CREATE TABLE Expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,
    expense_type VARCHAR(100) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    expense_date DATE NOT NULL,
    description_of_expense TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Income Table(Other than school fees such as examination fees, textbook...)
CREATE TABLE Income (
    income_id INT PRIMARY KEY AUTO_INCREMENT,
    source_of_income VARCHAR(100) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    income_date DATE NOT NULL,
    description_of_income TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Update Reminders Table
CREATE TABLE UpdateReminders (
    reminder_id INT PRIMARY KEY AUTO_INCREMENT,
    reminder_type ENUM('Payment', 'Expense', 'Salary') NOT NULL,
    reminder_date DATE NOT NULL,
    status ENUM('Pending', 'Done') DEFAULT 'Pending'
);

-- Create View for Daily Financial Summary Table
CREATE VIEW daily_financial_summary AS
SELECT 
    CURDATE() AS report_date,
    (SELECT SUM(amount_paid) FROM Payments WHERE DATE(payment_date) = CURDATE()) AS total_fees_collected,
    (SELECT SUM(amount) FROM Income WHERE DATE(income_date) = CURDATE()) AS other_income,
    (SELECT SUM(amount) FROM Expenses WHERE DATE(expense_date) = CURDATE()) AS total_expenses,
    (SELECT SUM(salary_amount) FROM Salaries WHERE DATE(payment_date) = CURDATE()) AS salaries_paid;



-- Insertion of Data

-- Insert Into Classes
INSERT INTO Classes (class_name) VALUES 
('Basic 1'), ('Basic 2'), ('Basic 3'), ('Basic 4'), ('Basic 5');


-- Insert Into Students
INSERT INTO Students (full_name, class_id, admission_date) VALUES
('Aisha Bello', 1, '2023-09-01'),
('John Okafor', 2, '2022-09-05'),
('Fatima Musa', 3, '2021-09-03');


-- Insert Into Fee Structure
INSERT INTO FeeStructure (class_id, term, amount, session_year) VALUES
(1, 'First Term', 15000.00, 2024),
(2, 'First Term', 17000.00, 2024),
(3, 'First Term', 18000.00, 2024);


-- Insert Into Payments
INSERT INTO Payments (student_id, fee_id, amount_paid, payment_date, payment_method, transaction_ref, receipt_number) VALUES
(1, 1, 15000.00, '2024-09-10', 'Cash', 'TXN001', 'RCPT001'),
(2, 2, 17000.00, '2024-09-12', 'Bank Transfer', 'TXN002', 'RCPT002'),
(3, 3, 18000.00, '2024-09-15', 'POS', 'TXN003', 'RCPT003');


-- Insert Into Staff
INSERT INTO Staff (full_name, designation, hire_date) VALUES
('Mrs. Grace Ade', 'Teacher', '2020-01-15'),
('Mr. Yusuf Ibrahim', 'Bursar', '2019-07-20');

-- Insert Into Salaries
INSERT INTO Salaries (staff_id, salary_amount, salary_month, payment_date, due_date, paid_status) VALUES
(1, 50000.00, 'September', '2024-09-30', '2024-09-30', 'Paid'),
(2, 70000.00, 'September', '2024-09-30', '2024-09-30', 'Paid');


-- Insert Expenses
INSERT INTO Expenses (expense_type, amount, expense_date, description_of_income) VALUES
('Stationery', 12000.00, '2024-09-05', 'Purchase of notebooks and pens'),
('Electricity Bill', 8000.00, '2024-09-10', 'PHCN bill for September');


-- Insert Income
INSERT INTO Income (source_of_income, amount, income_date, description_of_income) VALUES
('Donation', 25000.00, '2024-09-08', 'Community support donation'),
('Event Ticket Sales', 10000.00, '2024-09-20', 'Cultural day event');

-- Insert Reminders
INSERT INTO UpdateReminders (reminder_type, reminder_date, status) VALUES
('Payment', '2024-09-21', 'Pending'),
('Salary', '2024-09-30', 'Done');

