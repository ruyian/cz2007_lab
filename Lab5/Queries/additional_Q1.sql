-- Assume 2021.9.1
DROP TABLE IF EXISTS A1

SELECT t2.user_id as user_id, t1.shop_name as shop_name 
INTO A1
FROM product_on_order as t1 JOIN orders as t2 ON t1.order_id = t2.order_id
WHERE DATEDIFF(day, t2.order_placing_timestamp, '2021/09/01') <= 30
--MONTH(t2.order_placing_timestamp) = 8
--  AND YEAR(t2.order_placing_timestamp) = 2021
Group BY t2.user_id, t1.shop_name
HAVING sum(order_quantity) > 2


/*
SELECT user_id 
INTO A2
FROM A1
Group BY user_id
HAVING count(shop_name) > = 5
*/

SELECT TOP 3 WITH TIES t2.user_id, 
   SUM(t1.order_quantity * t1.dealing_price) AS purchased_amount
FROM product_on_order as t1 JOIN orders as t2 ON t1.order_id = t2.order_id 
WHERE t2.user_id in (
   SELECT user_id 
   FROM A1
   Group BY user_id
   HAVING count(shop_name) > = 2
)
GROUP BY t2.user_id
ORDER BY purchased_amount DESC;