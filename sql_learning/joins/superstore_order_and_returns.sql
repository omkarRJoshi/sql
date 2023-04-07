select count(*) from superstore_orders;
select * from returns limit 5;

# 1. write a query to get region wise count of return orders

select s.region, count(1) from 
returns as r
inner join 
superstore_orders as s 
on r.order_id = s.order_id
group by s.region
;

# 2. write a query to get category wise sales of orders that were not returned
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

