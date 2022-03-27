-- Produce a list that contains
-- (i) all products made by Samsung, and
-- (ii) for each of them, the number of shops on Shiokee that sell the product.

-- Note:
-- We specially engineered the data:
-- No shop sells the Samsung product Galaxy Note 10 even though it appears in the products

-- Left join is adopted to produce list contain all products made by Samsung
-- We use WHERE clause to filter products made by Samsung
-- Then GROUP BY each product name, and COUNT the shops that sell them
-- (NULL is atomatically treated as 0)
 
SELECT p.product_name, COUNT(pis.shop_name)
   -- SUM(CASE WHEN pis.product_name IS NULL THEN 0 ELSE 1 END) AS shop_count
FROM product AS p
    LEFT JOIN product_in_shop AS pis 
    ON p.product_name = pis.product_name
WHERE p.maker = 'Samsung'
GROUP BY p.product_name

/*
-- Version that cannot print out products if no shop sells them
SELECT product_name, COUNT(DISTINCT shop_name) AS shop_count
FROM product_in_shop
WHERE product_name IN (
    SELECT product_name
    FROM product
    WHERE maker = 'Samsung'
)
GROUP BY product_name
*/
