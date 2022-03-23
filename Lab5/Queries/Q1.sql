SELECT AVG(price) AS AvgPrice
FROM price_history
WHERE product_name = 'iPhone X'
  AND ((start_date >= '2021.08.01 00:00:00' AND start_date < '2021.08.31 00:00:00')
    OR (end_date >= '2021.08.01 00:00:00' AND end_date < '2021.08.31 00:00:00'));