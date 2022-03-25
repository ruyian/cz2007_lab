-- Find shops that made the most revenue in August 2021.

WITH shop_revenue AS (
  SELECT t2.shop_name, SUM(t2.dealing_price * t2.order_quantity) AS revenue
  FROM orders as t1 JOIN product_on_order as t2
  ON t1.order_id = t2.order_id
  WHERE YEAR(t1.order_placing_timestamp) = 2021 AND MONTH(t1.order_placing_timestamp) = 8
  GROUP BY t2.shop_name
)

SELECT shop_name, revenue
FROM shop_revenue
WHERE revenue = (SELECT MAX(revenue) FROM shop_revenue);



