create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;

# 1. write a query to produce below output from icc_world_cup table.
# team_name, no_of_matches_played , no_of_wins , no_of_losses

## approach 1
select team_name, total_matches, coalesce(no_of_wins, 0) as no_of_wins, total_matches - coalesce(no_of_wins, 0) as no_of_losses from
(select team_name, count(1) as total_matches from(
select team_1 as team_name from icc_world_cup
union all
select team_2 as team_name from icc_world_cup
) as nt
group by team_name) as m
left join
(select winner, count(1) as no_of_wins from icc_world_cup
group by winner) as w
on m.team_name = w.winner;

## approach 2
select team_name, count(1) as total_matches, sum(win_flag) as no_of_wins, count(1) - sum(win_flag) as no_of_loss from
(
	select 
	team_1 as team_name
	, case when team_1 = winner then 1 else 0 end as win_flag 
	from icc_world_cup
	union all
	select
	team_2 as team_name
	, case when team_2 = winner then 1 else 0 end as win_flag 
	from icc_world_cup
) as t
group by team_name;

select * from icc_world_cup;

#Run below script to create drivers table:
create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');

select * from drivers;

# 2. write a query to print below output using drivers table. 
# Profit rides are the no of rides where end location of a ride is same as start location of immediate next ride for a driver
# id, total_rides , profit_rides
# dri_1,5,1
# dri_2,2,0

select d1.id, count(1) as total_rides, count(d2.id) as profit_rides from 
drivers as d1
left join
drivers as d2
on d1.end_time = d2.start_time AND d1.end_loc = d2.start_loc
group by d1.id
;

# 3. write a query to print below output from orders data. example output
-- hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region
-- category , Technology, ,
-- category, Furniture, ,
-- category, Office Supplies, ,
-- sub_category, Art , ,
-- sub_category, Furnishings, ,
-- and so on all the category ,subcategory and ship_mode hierarchies

select * from superstore_orders;

select 'category' as hierarchy_type, category as hierarchy_name
, sum(case when region = 'east' then sales else 0 end) as 'total_sales_in_east_region'
, sum(case when region = 'west' then sales else 0 end) as 'total_sales_in_west_region'
from 
superstore_orders
where region in ('east', 'west')
group by category

union

select 'sub_category' as hierarchy_type, sub_category as hierarchy_name
, sum(case when region = 'east' then sales else 0 end) as 'total_sales_in_east_region'
, sum(case when region = 'west' then sales else 0 end) as 'total_sales_in_west_region'
from 
superstore_orders
where region in ('east', 'west')
group by sub_category
;