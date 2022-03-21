select avg(delivery_date - order_timestsmp) 
from PRODUCTS-IN-ORDER left join ORDERS on PRODUCTS-IN-ORDERS.order_id=ORDERS.order_id
where order_timestsmp >= '2021-6-1' AND order_timestsmp <= '2021-6-30' AND delivery_date <= now() 
