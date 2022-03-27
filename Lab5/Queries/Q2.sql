-- Find products that received at least 100 ratings of “5” in August 2021, 
-- and order them by their average ratings.

Drop table if exists good_products

-- Clarification: in our implentation, the overall average ratings for desired products are found

-- create temporary table "good_products" which stores product name with more than 100 ratings of "5"
SELECT product_name
INTO good_products
FROM feedback
WHERE rating = 5
  AND MONTH(feedbackDate) = 8
  AND YEAR(feedbackDate) = 2021
GROUP BY product_name
HAVING COUNT(rating) >= 100;

-- -- printing the average ratings for these products
SELECT product_name, ROUND(AVG(Cast(rating as Float)), 2) AS AvgRatings
FROM feedback
WHERE product_name IN (SELECT * FROM good_products) --from the temporary table "good_products"
GROUP BY product_name
ORDER BY AvgRatings DESC; -- AvgRatings in decreasing order 


/*
-- If we refer the "average ratings" as the average ratings received by the desired products in August 2021
-- We can provide the simplified queries as follows:

SELECT product_name, ROUND(AVG(Cast(rating as Float)), 2) AS AvgRatings
FROM feedback
WHERE rating = 5
  AND MONTH(feedbackDate) = 8
  AND YEAR(feedbackDate) = 2021
GROUP BY product_name
HAVING COUNT(rating) >= 100
ORDER BY AvgRatings DESC;
*/
