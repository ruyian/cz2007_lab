-- Find products that have never been purchased by some users, but are the top 5 most purchased
-- products by other users in August 2021.

SELECT TOP 5 t1.product_name, SUM(t1.order_quantity) AS purchased_amount
FROM users, 
   product_on_order as t1 JOIN orders as t2 ON t1.order_id = t2.order_id
WHERE YEAR(t2.order_placing_timestamp) = 2021 
   AND MONTH(t2.order_placing_timestamp) = 8
GROUP BY t1.product_name
HAVING count(distinct t2.user_id) < count(users.user_id)
ORDER BY purchased_amount DESC;
