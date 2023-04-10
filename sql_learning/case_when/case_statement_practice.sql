select * from superstore_orders limit 5;


# 1. categories profit in low-profit, medium_profit, high profit
select order_id, profit,
case
when profit < 0 then 'loss'
when profit < 100 then 'low profit'
when profit < 250 then 'medium profit'
when profit < 400 then 'hight profit'
else 'very high profit'
end as profit_category
from 
superstore_orders;