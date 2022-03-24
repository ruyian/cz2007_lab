-- Find shops that made the most revenue in August 2021.

WITH A1 AS
         (
             SELECT t2.shop_name, SUM(t2.dealing_price * t2.order_quantity) AS revenue
             FROM orders as t1

                      -- Left join on common attribute OrderID of both tables
                      LEFT JOIN product_on_order AS t2
                                ON t1.order_id = t2.order_id

                  -- OrderDateTime should fall under 2021/08
             WHERE MONTH(t1.order_placing_timestamp) = 8
               AND YEAR(t1.order_placing_timestamp) = 2021
               -- Group by Shop name with aggregate function SUM of all revenue(OrderPrice*OrderQuantity) by this shop
             GROUP BY shop_name
         )

SELECT shop_name
FROM A1
WHERE revenue = (SELECT MAX(revenue) FROM A1);