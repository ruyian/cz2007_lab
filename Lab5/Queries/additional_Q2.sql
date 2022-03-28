-- Assume 2021.9.1
DROP TABLE IF EXISTS A2
DROP TABLE IF EXISTS A3

SELECT t1.shop_name as shop_name 
INTO A2
FROM product_on_order as t1 JOIN orders as t2 ON t1.order_id = t2.order_id
WHERE DATEDIFF(day, t2.order_placing_timestamp, '2021/09/01') <= 30
--MONTH(t2.order_placing_timestamp) = 8
--  AND YEAR(t2.order_placing_timestamp) = 2021
Group BY t1.shop_name
HAVING sum(order_quantity) > 3


SELECT t1.shop_name, t2.user_id, SUM(t1.order_quantity) AS purchased_items
INTO A3
FROM product_on_order as t1 JOIN orders as t2 ON t1.order_id = t2.order_id 
WHERE t1.shop_name in (
   SELECT shop_name 
   FROM A2
)
GROUP BY t1.shop_name, t2.user_id

SELECT *
FROM A3 as t1
WHERE (
   SELECT count(*)
   FROM A3 as t2
   WHERE t1.user_id <> t2.user_id
      AND t1.shop_name = t2.shop_name
      AND t1.purchased_items < t2.purchased_items
   ) <= 2
ORDER BY t1.shop_name, t1.purchased_items DESC