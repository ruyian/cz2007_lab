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
-- Proof Check 
SELECT product_name
FROM product
WHERE maker = 'Samsung'
*/