-- For users that made the most amount of complaints, find the most expensive products he/she has
-- ever purchased.

-- Clarification: all the steps are deemed necessary for the desired outcome
-- Counts the total number of complaints each user has made

--Assumption: the tie condition may happens.(examples: 1.two users make the same amount of complaints 
--and this number is the largest. 2.Two products have the same price and they are all the most expensive products of a specific user).

WITH A1 AS(
    -- Select the users that have made the most complaints 
    --We GROUP BY user id, and aggregate the no. of complaints as: COUNT(user_id) 
    --(Use "TOP 1 WITH TIES" to deal with the tie condition in choosing users that made the most amount of complaints)
    SELECT TOP 1 WITH TIES user_id, COUNT(user_id) as noOfComplaints
    FROM complaint
    GROUP BY user_id
    ORDER BY noOfComplaints DESC
    ),
    
    -- Split to multiple subqueries for efficiency (too many joins at one query lose efficiency)
    
    -- Select the users in A1 that has made the most complaints 
    -- and their orderID through joining A1 with orders according to same user_id
    A2 AS(
        SELECT t1.user_id, t2.order_id
        FROM A1 as t1 JOIN orders as t2
        ON t1.user_id = t2.user_id
    ),
    
    -- Find all products that these users in A2 has ever purchased
    -- and dealing price through joining A2 with product_on_order according to same order_id
    A3 AS (
        SELECT t1.user_id, t2.order_id, t2.product_name, t2.dealing_price
        FROM A2 as t1 JOIN product_on_order as t2 
        ON t1.order_id = t2.order_id
    ),
    
    -- Find the most expensive product that each user in A3 has purchased 
    -- this step is necessary for finding the most expensive products in the last part
    A4 AS(
        SELECT user_id, MAX(dealing_price) as maxProductPrice
        FROM A3
        GROUP BY user_id
    )

-- Result: Get the most expensive products' name through joining A4 and A3 by matching user_id and the Product price.
-- show the user_id, corresponding most expensive product name and prices
SELECT t1.user_id, t2.product_name, t2.dealing_price
FROM A4 as t1 JOIN A3 as t2
ON t1.user_id = t2.user_id AND t1.maxProductPrice = t2.dealing_price;