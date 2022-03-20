SELECT shop_name, MAX(revenue)
FROM (
   SELECT shop_name, SUM(order_quantity * dealing_price) AS revenue
   FROM product_on_order
   GROUP BY shop_name
)
