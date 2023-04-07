create table employee(
    emp_id int,
    emp_name varchar(20),
    dept_id int,
    salary int,
    manager_id int,
    emp_age int
);


insert into employee values(1,'Ankit',100,10000,4,39);
insert into employee values(2,'Mohit',100,15000,5,48);
insert into employee values(3,'Vikas',100,10000,4,37);
insert into employee values(4,'Rohit',100,5000,2,16);
insert into employee values(5,'Mudit',200,12000,6,55);
insert into employee values(6,'Agam',200,12000,2,14);
insert into employee values(7,'Sanjay',200,9000,2,13);
insert into employee values(8,'Ashish',200,5000,2,12);
insert into employee values(9,'Mukesh',300,6000,6,51);
insert into employee values(10,'Rakesh',500,7000,6,50);

create table dept(
    dep_id int,
    dep_name varchar(20)
);
insert into dept values(100,'Analytics');
insert into dept values(200,'IT');
insert into dept values(300,'HR');
insert into dept values(400,'Text Analytics');

select * from employee;
select * from dept;

# 1. write a query to print dep name and average salary of employees in that dep
select d.dep_name, avg(e.salary)
from
dept as d
left join
employee as e
on d.dep_id = e.dept_id
group by d.dep_name
;

# 2. write a query to print dep names where none of the emplyees have same salary
select d.dep_name
from
employee as e
inner join 
dept as d
on e.dept_id = d.dep_id
group by d.dep_name
having count(1) = count(distinct e.salary)
;
