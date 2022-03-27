-- For all products purchased in June 2021 that have been delivered, find the average time from the
-- ordering date to the delivery date.
-- Clarification: both 'order_placing_timestamp' and 'delivery_date' are timestamps with an accuracy of 1 milisecond

-- calculate average time of delivery in hours
SELECT ROUND(AVG(CAST(DATEDIFF(second, order_placing_timestamp, delivery_date) AS FLOAT)) / 3600, 2) AS AvgHoursOnDelivery
-- calculate average time of delivery in days
-- SELECT ROUND(AVG(CAST(DATEDIFF(day, order_placing_timestamp, delivery_date) AS FLOAT)), 2)  AS AvgDaysOnDelivery 
FROM orders,
     product_on_order
WHERE orders.order_id = product_on_order.order_id
  AND order_placing_timestamp >= '2021-06-01 00:00:00' -- start from 06.01
  AND order_placing_timestamp < '2021-07-01 00:00:00' -- until 07.01 (07.01 not included)
  AND (product_on_order_status = 'delivered' OR product_on_order_status = 'returned'); -- select all the products that have been delivered or the products that have been delivered to the customer and returned to the store
