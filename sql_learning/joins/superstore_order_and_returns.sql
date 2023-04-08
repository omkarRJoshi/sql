select * from superstore_orders limit 5;
select * from returns limit 5;

# 1. write a query to get region wise count of return orders
## corrected my solution by providing distinct to s.order_id
select s.region, count(distinct s.order_id) from 
returns as r
inner join 
superstore_orders as s 
on r.order_id = s.order_id
group by s.region
;

# 2. write a query to get category wise sales of orders that were not returned
## approach 1 (my approach)
select category, sum(sales) from(
	select s.order_id as order_id, category, sales, r.order_id as returned_id from 
	superstore_orders as s 
	left join 
	returns as r
	on s.order_id = r.order_id
	) as t
where returned_id is null
group by category
;

## approach 2 (solution)
select category,sum(o.sales) as total_sales
from superstore_orders o
left join returns r on o.order_id=r.order_id
where r.order_id is null
group by category;


# 3. write a query to print sub categories 
#	 where we have all 3 kinds of returns (others,bad quality,wrong items)
select s.sub_category, count(distinct r.return_reason) 
from 
superstore_orders as s
inner join
returns as r
on s.order_id = s.order_id
group by s.sub_category
having count(distinct r.return_reason) = 3;

# 4. write a query to find cities where not even a single order was returned.
## my soltion - wrong ans
select distinct(city) from(
	select s.order_id as order_id, city, r.order_id as returned_id from 
	superstore_orders as s 
	left join 
	returns as r
	on s.order_id = r.order_id
	) as t
where returned_id is null
order by city;

## right ans - reason: same oarder_id can have return item
select city
from superstore_orders o
left join returns r on o.order_id=r.order_id
group by city
having count(r.order_id)=0
order by city;

# 5. write a query to find top 3 subcategories by sales of returned orders in east region
select s.Sub_Category, sum(s.sales) as total_sum
from 
superstore_orders as s
inner join
returns as r
on s.order_id = r.order_id
where region = 'east'
group by s.Sub_Category
order by total_sum desc
limit 3
;