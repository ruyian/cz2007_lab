-- create temporary table which stores product name with more than 100 ratings of "5"
SELECT product_name
INTO good_products
FROM feedback
WHERE rating = 5
  AND MONTH(feedbackDate) = 8
  AND YEAR(feedbackDate) = 2020
GROUP BY pName
HAVING COUNT(rating) >= 100;

-- -- printing the average ratings for these products
SELECT product_name, ROUND(AVG(Cast(rating as Float)), 2) AS AvgRatings
FROM feedback
WHERE product_name IN (SELECT * FROM good_products)
  AND MONTH(feedbackDate) = 8
  AND YEAR(feedbackDate) = 2021
GROUP BY product_name
ORDER BY AVG(rating) DESC;