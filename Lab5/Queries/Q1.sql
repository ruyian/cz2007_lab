-- Find the average price of “iPhone Xs” on Shiokee from 1 August 2021 to 31 August 2021.

SELECT product_name, ROUND(AVG(Cast(actual_price as Float)), 2) AS AvgPrice
FROM price_history
WHERE product_name = 'iPhone X'
  AND ((start_date >= '2021.08.01 00:00:00' AND start_date < '2021.09.01 00:00:00')
    OR (end_date >= '2021.08.01 00:00:00' AND end_date < '2021.09.01 00:00:00'))
GROUP BY product_name; -- Additional Group By clause added to print the product name 'iPhone X'
