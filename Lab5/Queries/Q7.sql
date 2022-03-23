-- For users that made the most amount of complaints, find the most expensive products he/she has
-- ever purchased.

-- Counts the total number of complaints each user has made
WITH A1 AS
         (
             SELECT user_id, COUNT(user_id) as noOfComplaints
             FROM complaint
             GROUP BY user_id
         ),
     -- Select the users in A1 that has made the most complaints and their orderID
     A2 AS
         (
             SELECT t1.user_id, t2.order_id
             FROM A1 as t1
                      LEFT JOIN orders as t2
                                ON t1.user_id = t2.user_id
             WHERE noOfComplaints = (SELECT MAX(noOfComplaints) FROM A1)
         ),
     -- Find all products that these users in A2 has ever purchased
     A3 AS
         (
             SELECT t1.user_id, t2.order_id, t2.product_name, t2.dealing_price
             FROM A2 as t1
                      LEFT JOIN product_on_order as t2
                                ON t1.order_id = t2.order_id
         ),
     -- Find the most expensive product that each user in A3 has purchased
     A4 AS
         (
             SELECT user_id, MAX(dealing_price) as maxProductPrice
             FROM A3
             GROUP BY user_id
         )

-- Get the product name by matching UserID and the Product price
SELECT t1.user_id, t2.product_name, t2.dealing_price
FROM A4 as t1
         LEFT JOIN A3 as t2
                   ON t1.user_id = t2.user_id AND t1.maxProductPrice = t2.dealing_price;
