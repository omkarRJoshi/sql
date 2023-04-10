# Run the following command to add and update dob column in employee table
alter table  employee add dob date;
update employee set dob = date_add(curdate(), Interval -1 * emp_age year);

select * from employee;

# 1.write a query to print emp name , their manager name and diffrence in their age (in days) 
# for employees whose year of birth is before their managers year of birth
select emp1.emp_name, emp2.emp_name as manager_name, emp1.dob, emp2.dob, datediff(emp1.dob, emp2.dob) as age_diff
from 
employee as emp1
inner join 
employee as emp2
on emp1.manager_id = emp2.emp_id
where datediff(emp1.dob, emp2.dob) > 0;

# 2. write a query to find subcategories who never had any return orders in the month of november (irrespective of years)
select * from superstore_orders;
select * from returns;

select s.Sub_Category, date_format(s.order_date, '%m') 
from
superstore_orders as s
left join
returns as r
on s.order_id = r.order_id
where date_format(s.order_date, '%m')  = 11
group by s.Sub_Category
having count(r.order_id) = 0
;

# 3. orders table can have multiple rows for a particular order_id when customers buys more than 1 product in an order.
# write a query to find order ids where there is only 1 product bought by the customer.
select order_id, count(*)
from
superstore_orders
group by order_id
having count(1) = 1;

# 4. write a query to print manager names along with the comma separated list(order by emp salary) of all employees directly reporting to him.
select emp2.emp_name as manager_name, group_concat(emp1.emp_name, '|', emp1.salary order by emp1.salary) as emp_list
from
employee as emp1
inner join 
employee as emp2
on emp1.manager_id = emp2.emp_id
group by emp2.emp_name;

# 5. write a query to get number of business days between order_date and ship_date (exclude weekends). 
# Assume that all order date and ship date are on weekdays only
select * from superstore_orders limit 5;
select 
order_date, str_to_date(ship_date, '%d-%m-%Y'), 
(
	datediff(str_to_date(ship_date, '%d-%m-%Y'), order_date) - 
	(week(str_to_date(ship_date, '%d-%m-%Y')) - week(Order_Date)) - 
    (case when weekday(order_date) = 6 then 1 else 0 end) - 
    (case when weekday(str_to_date(ship_date, '%d-%m-%Y')) = 5 then 1 else 0 end)
) as date_dff
from 
superstore_orders;

# 6. write a query to print 3 columns : category, total_sales and (total sales of returned orders)
select s.Category, sum(s.sales)
,sum(case when r.order_id is null then 0 else s.sales end) as returned_orders_sum
from 
superstore_orders as s
left join 
returns as r
on s.order_id = r.order_id
group by s.Category;

# 7. write a query to print below 3 columns
# category, total_sales_2019(sales in year 2019), total_sales_2020(sales in year 2020)
select category, 
sum(case when year(order_date) = 2019 then sales else 0 end) as sales_2019,
sum(case when year(order_date) = 2020 then sales else 0 end) as sales_2020
from 
superstore_orders
where year(order_date) in (2019, 2020)
group by category
;

# 8. write a query print top 5 cities in west region by average no of days between order date and ship date.
select city, avg(datediff(str_to_date(ship_date, '%d-%m-%Y'), order_date)) as date_diff
from 
superstore_orders
where Region = 'west'
group by city
order by date_diff desc
limit 5
;

# 9. write a query to print emp name, manager name and senior manager name (senior manager is manager's manager)
## my solution: needs 3 joins | less efficient
select j1.emp_name, j1.manager_name, j2.manager_name as super_manager_name from 
(
	select emp1.emp_id, emp1.emp_name, emp2.emp_id as manager_id, emp2.emp_name as manager_name
	from 
	employee as emp1
	inner join 
	employee as emp2
	on emp1.manager_id = emp2.emp_id
) as j1
inner join 
(
	select emp1.emp_id, emp1.emp_name, emp2.emp_id as manager_id, emp2.emp_name as manager_name
	from 
	employee as emp1
	inner join 
	employee as emp2
	on emp1.manager_id = emp2.emp_id
) as j2
on j1.manager_id = j2.emp_id;

## course solution: needs 2 joins | more efficient
select emp1.emp_name, emp2.emp_name as manager_name, emp3.emp_name as super_manager_name
from 
employee as emp1 
inner join employee as emp2 on emp1.manager_id = emp2.emp_id
inner join employee as emp3 on emp2.manager_id = emp3.emp_id

