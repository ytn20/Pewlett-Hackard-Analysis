-- Creating tables for PH-EmployeeDB
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

-- Creating table for employeees
CREATE TABLE employees (
  emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

-- Creating table for dept manager
CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
    emp_no INT NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
    PRIMARY KEY (emp_no, dept_no)
);

-- Creating table for salaries
CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

-- Creating table for titles
CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no)
);

-- fix 'titles' table problem
DROP TABLE titles CASCADE;
DROP TABLE dept_emp CASCADE;

CREATE TABLE titles (
  emp_no INT NOT NULL,
  title VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (emp_no, from_date, title)
);

CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
  FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
  PRIMARY KEY (dept_no, emp_no, to_date)
);

SELECT * FROM titles;
SELECT * FROM dept_emp;
SELECT * FROM employees;

DROP TABLE retirement_titles CASCADE;

SELECT e.emp_no,
  e.first_name, 
  e.last_name, 
  ti.title, 
  ti.from_date, 
  ti.to_date  
INTO retirement_titles
FROM employees as e
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
  WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

SELECT * FROM retirement_titles;

SELECT DISTINCT ON (rt.emp_no) 
  rt.emp_no,
  rt.first_name,
  rt.last_name,
  rt.title
INTO unique_titles
FROM retirement_titles as rt
ORDER BY rt.emp_no, rt.to_date DESC;

SELECT * FROM unique_titles;

SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY count DESC;

SELECT * FROM retiring_titles;

-- Deliverable 2

-- Mentorship Program Eligible Employees
SELECT DISTINCT ON (e.emp_no)
  e.emp_no,
  e.first_name, 
  e.last_name, 
  e.birth_date,
  de.from_date,
  de.to_date,
  ti.title
INTO mentorship_eligibilty
FROM employees as e
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
INNER JOIN titles as ti
ON (e.emp_no = ti.emp_no)
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no, ti.from_date DESC;

SELECT * FROM mentorship_eligibilty;

