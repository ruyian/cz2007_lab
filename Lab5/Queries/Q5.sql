-- Produce a list that contains
-- (i) all products made by Samsung, and
-- (ii) for each of them, the number of shops on Shiokee that sell the product.

-- Part(i) --
SELECT product_name
FROM product
WHERE maker = 'Samsung';

-- Part(ii) --
SELECT product_name, COUNT(DISTINCT shop_name) AS shopcount
FROM product_in_shop
WHERE product_name IN (
    SELECT product_name
    FROM product
    WHERE maker = 'Samsung'
)
GROUP BY product_name