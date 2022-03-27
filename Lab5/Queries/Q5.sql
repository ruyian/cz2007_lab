-- Produce a list that contains
-- (i) all products made by Samsung, and
-- (ii) for each of them, the number of shops on Shiokee that sell the product.

SELECT product_name, COUNT(DISTINCT shop_name) AS shop_count
FROM product_in_shop
WHERE product_name IN (
    SELECT product_name
    FROM product
    WHERE maker = 'Samsung'
)
GROUP BY product_name


/*
--if there is product made by Samsung and no shop sell it.

SELECT p.product_name, SUM(CASE WHEN pis.product_name IS NULL THEN 0 ELSE 1 END) AS shop_count
FROM product AS p
LEFT JOIN product_in_shop AS pis 
ON p.product_name = pis.product_name
WHERE p.maker = 'Samsung'
GROUP BY p.product_name
*/

/*
-- Proof Check 
SELECT product_name
FROM product
WHERE maker = 'Samsung'
*/