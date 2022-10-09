
drop table employee;
create table employee
( emp_ID int
, emp_NAME varchar(50)
, DEPT_NAME varchar(50)
, SALARY int);

insert into employee values(101, 'Mohan', 'Admin', 4000);
insert into employee values(102, 'Rajkumar', 'HR', 3000);
insert into employee values(103, 'Akbar', 'IT', 4000);
insert into employee values(104, 'Dorvin', 'Finance', 6500);
insert into employee values(105, 'Rohit', 'HR', 3000);
insert into employee values(106, 'Rajesh',  'Finance', 5000);
insert into employee values(107, 'Preet', 'HR', 7000);
insert into employee values(108, 'Maryam', 'Admin', 4000);
insert into employee values(109, 'Sanjay', 'IT', 6500);
insert into employee values(110, 'Vasudha', 'IT', 7000);
insert into employee values(111, 'Melinda', 'IT', 8000);
insert into employee values(112, 'Komal', 'IT', 10000);
insert into employee values(113, 'Gautham', 'Admin', 2000);
insert into employee values(114, 'Manisha', 'HR', 3000);
insert into employee values(115, 'Chandni', 'IT', 4500);
insert into employee values(116, 'Satya', 'Finance', 6500);
insert into employee values(117, 'Adarsh', 'HR', 3500);
insert into employee values(118, 'Tejaswi', 'Finance', 5500);
insert into employee values(119, 'Cory', 'HR', 8000);
insert into employee values(120, 'Monica', 'Admin', 5000);
insert into employee values(121, 'Rosalin', 'IT', 6000);
insert into employee values(122, 'Ibrahim', 'IT', 8000);
insert into employee values(123, 'Vikram', 'IT', 8000);
insert into employee values(124, 'Dheeraj', 'IT', 11000);
COMMIT;



select * from employee;

-- max salary of an employee in each department using group by
select dept_name, max(salary)
from employee
group by dept_name
order by max(salary)

-- By using MAX as an window function, SQL will not reduce records but the result will be shown corresponding to each record.
select *,
max(salary) over(partition by dept_name) as "max_salary"
from employee


-- row_number(), rank() and dense_rank()
select *,
row_number() over(partition by dept_name) as "row"
from employee


-- Fetch the first 2 employees from each department to join the company.
select emp_name,dept_name, emp_id from 
	(select emp_name,dept_name, emp_id,
	row_number() over(partition by dept_name order by emp_id) as "rnk"
	from employee) as tb
where rnk < 3;


-- Fetch the top 3 employees in each department earning the max salary.
SELECT emp_name, salary, dept_name
FROM (
	SELECT *, row_number() OVER(PARTITION BY dept_name ORDER BY salary DESC) as "max_salary"
	FROM employee) as tb
WHERE max_salary < 4;

select * from (
	select e.*,
	rank() over(partition by dept_name order by salary desc) as rnk
	from employee e) x
where x.rnk < 4;


-- Checking the different between rank, dense_rnk and row_number window functions:
select e.*,
rank() over(partition by dept_name order by salary desc) as rnk,
dense_rank() over(partition by dept_name order by salary desc) as dense_rnk,
row_number() over(partition by dept_name order by salary desc) as rn
from employee e;



-- lead and lag

-- fetch a query to display if the salary of an employee is higher, lower or equal to the previous employee.
select *,
CASE 
	WHEN salary > lag(salary) OVER(ORDER BY emp_id) then 'higher'
	WHEN salary < lag(salary) OVER(ORDER BY emp_id) THEN 'lower'
	WHEN salary = lag(salary) OVER(ORDER by emp_id) THEN 'same'
	ELSE NULL
END AS "compare_salary"
FROM employee

-- fetch a query to display if the salary of an employee is higher, lower or equal to the previous employee in each department.
SELECT *,
CASE
	WHEN salary > lag(salary) OVER(PARTITION BY dept_name order by emp_id) THEN 'higher'
	WHEN salary < lag(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) THEN 'lower'
	WHEN salary = lag(salary) OVER(PARTITION BY dept_name ORDER BY emp_id) THEN 'same'
	ELSE NULL
END AS "compare_salary"
FROM employee

-- Similarly using lead function to see how it is different from lag.
select e.*,
lag(salary) over(partition by dept_name order by emp_id) as prev_empl_sal,
lead(salary) over(partition by dept_name order by emp_id) as next_empl_sal
from employee e;
