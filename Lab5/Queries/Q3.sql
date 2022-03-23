-- For all products purchased in June 2021 that have been delivered, find the average time from the
-- ordering date to the delivery date.

-- print average time of delivery in hours
SELECT CAST(AVG(DATEDIFF(second, order_placing_timestamp, delivery_date)) AS FLOAT) / 3600 AS AvgTimeOnDelivery
FROM orders,
     product_in_order
WHERE orders.order_id = product_in_order.order_id
  AND order_placing_timestamp >= '2021-06-01 00:00:00'
  AND order_placing_timestamp < '2021-07-01 00:00:00'
  AND (product_on_order_status = 'delivered' OR product_on_order_status = 'returned');