-- Find shops that made the most revenue in August 2021.

-- We first join order with product on order to achieve dealing_price and qorder_quantity
-- and use WHERE clause to filter records in Aug 2021
-- We then GROUP BY each shop, and aggregate the revenue as: SUM(t2.dealing_price * t2.order_quantity)
-- Finally, we select the shop(s) made most revenue by clauses TOP 1 WITH TIES and ORDER BY
-- Note: We use WITH TIES to allow multiple results

SELECT TOP 1 WITH TIES t2.shop_name, SUM(t2.dealing_price * t2.order_quantity) AS revenue
FROM orders as t1 JOIN product_on_order as t2
ON t1.order_id = t2.order_id
WHERE YEAR(t1.order_placing_timestamp) = 2021 
  AND MONTH(t1.order_placing_timestamp) = 8
GROUP BY t2.shop_name
ORDER BY revenue DESC

/*
-- Version with subquery
-- less compact than the single-query version

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
*/
