-- part 1 select where maker = 'Samsung'
SELECT product_name
FROM product
WHERE maker = 'Samsung';

SELECT product_name, COUNT(DISTINCT shop_name) AS shopcount
FROM product_in_shop
WHERE product_name IN (
   SELECT product_name
   FROM product
   WHERE maker = 'Samsung'   
)
GROUP BY product_name
