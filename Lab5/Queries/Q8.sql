-- Find products that have never been purchased by some users, but are the top 5 most purchased
-- products by other users in August 2021.

-- Assumption: We think the products that have never been purchased by some users and the top 5 most purchased
-- products by other users are both in the same condtion that time in August 2021

--We first join product_on_order and orders by matching the same order id to get the timestamp of each product on order.
--Then we filter records in August 2021.
--We find the products that never been purchased in Aug 2021 by aggregating on product_name 
--and select the product that has less number of corresponding user_ids than the total number of users.
--Finally, we use "TOP 5 WITH TIES" to choose the top 5 most purchased products by other users in August 2021.
--(Use "TOP 5 WITH TIES" to deal with the tie conditions in choosing the top 5 most purchased product)

SELECT TOP 5 WITH TIES t1.product_name, SUM(t1.order_quantity) AS purchased_amount
FROM product_on_order as t1
JOIN orders as t2 ON t1.order_id = t2.order_id 
WHERE YEAR(t2.order_placing_timestamp) = 2021 
AND MONTH(t2.order_placing_timestamp) = 8
GROUP BY t1.product_name
HAVING count(distinct t2.user_id) < (SELECT count(distinct user_id) FROM users)
ORDER BY purchased_amount DESC;
