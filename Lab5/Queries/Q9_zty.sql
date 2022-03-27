WITH Monthly_count AS(
SELECT t1.product_name, 
   YEAR(t2.order_placing_timestamp) AS Purchased_year, 
   MONTH(t2.order_placing_timestamp) AS Purchased_Month, 
   SUM(order_quantity) AS Purchased_amount
FROM product_on_order as t1 JOIN orders as t2 ON t1.order_id = t2.order_id
GROUP BY t1.product_name, 
   YEAR(t2.order_placing_timestamp), 
   MONTH(t2.order_placing_timestamp)
)

SELECT t1.product_name
FROM Monthly_count AS t1, Monthly_count AS t2, Monthly_count AS t3
WHERE t1.product_name = t2.product_name
   AND ( -- Deal with consecutive months
      (t1.Purchased_year = t2.Purchased_year AND t2.Purchased_year = t3.Purchased_year AND t1.Purchased_Month = t2.Purchased_Month + 1 AND t2.Purchased_Month = t3.Purchased_Month + 1)
      OR
      (t1.Purchased_year = t2.Purchased_year + 1 AND t2.Purchased_year = t3.Purchased_year AND t1.Purchased_Month = 1 AND t2.Purchased_Month = 12 AND t3.Purchased_Month = 11)
      OR
      (t1.Purchased_year = t2.Purchased_year AND t2.Purchased_year = t3.Purchased_year + 1 AND t1.Purchased_Month = 2 AND t2.Purchased_Month = 1  AND t3.Purchased_Month = 12)
   )
   AND t1.Purchased_amount > t2.Purchased_amount
   AND t2.Purchased_amount > t3.Purchased_amount
GROUP BY t1.product_name
HAVING count(t1.Purchased_Month) >= 3