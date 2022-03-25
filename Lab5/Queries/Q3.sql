-- For all products purchased in June 2021 that have been delivered, find the average time from the
-- ordering date to the delivery date.
-- Clarification: both 'order_placing_timestamp' and 'delivery_date' are timestamps with an accuracy of 1 milisecond

-- calculate average time of delivery in hours
SELECT CAST(AVG(DATEDIFF(second, order_placing_timestamp, delivery_date)) AS FLOAT) / 3600 AS AvgTimeOnDelivery
-- calculate average time of delivery in days
-- SELECT CAST(AVG(DATEDIFF(day, order_placing_timestamp, delivery_date)) AS FLOAT)  AS AvgTimeOnDelivery 
FROM orders,
     product_on_order
WHERE orders.order_id = product_on_order.order_id
  AND order_placing_timestamp >= '2021-06-01 00:00:00'
  AND order_placing_timestamp < '2021-07-01 00:00:00'
  AND (product_on_order_status = 'delivered' OR product_on_order_status = 'returned');