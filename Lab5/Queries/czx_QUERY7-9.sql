--Q7
WITH users_with_most_complants AS 
(
SELECT USERID
FROM COMPLAINTS
GROUP BY USERID
WHERE COUNT(*) = (SELECT MAX(COUNT(*)) as maxnumofcomplaints 
		FROM COMPLAINTS
		GROUP BY USERID)
);

WITH top1complaint_1expensive_product AS
(
SELECT UM.user_id,PO.product_name
FROM	(SELECT o.user_id,MAX(p.dealing_price) as maxprice 
	FROM product_on_order AS p
	INNER JOIN orders AS o USING (order_id)  
	WHERE o.user_id IN users_with_most_complants
	GROUP BY o.user_id) AS UM, orders AS O, product_on_order AS PO
WHERE UM.user_id = O.user_id AND PO.dealing_price = UM.maxprice AND O.order_id = PO.order_id
);
 
SELECT U.name AS userName, TP.product_name 
FROM USERS AS U, top1complaint_1expensive_product AS TP
WHERE U.user_id = TP.user_id;


--Q8
SELECT DISTINCT TOP (5) po.product_name, COUNT(DISTINCT o.user_id) as numUsersBought
FROM product_in_order AS po, Orders AS o, Product AS p
WHERE (po.order_id = o.order_id
AND po.product_name = p.product_name
AND o.order_placing_timestamp >= '2021-08-01' AND o.order_placing_timestamp <= '2021-08-31'
AND po.product_name in (SELECT r1.product_name
				FROM(
					SELECT product_name, COUNT(DISTINCT o.user_id) AS numUsersBought
					FROM product_in_order AS po, order AS o, product AS p
					WHERE po.order_id = o.order_id
					AND po.product_name = p.product_name
					GROUP BY po.product_name

				EXCEPT 

					SELECT product_name, COUNT(DISTINCT o.user_id) AS numUsersBought
					FROM product_in_order as po, order as o, product as p
					WHERE po.order_id = o.order_id
					AND po.product_name = p.product_name
					HAVING COUNT(DISTINCT o.user_id) = (SELECT COUNT(DISTINCT user_id) FROM users)
				) AS r1)
)
GROUP BY po.product_name
ORDER BY numUsersBought DESC;


--Q9
WITH ProductsMonthlySales AS
(
SELECT product_on_order.product_name, MONTH(order.order_placing_timestamp) as mon, YEAR(order.order_placing_timestamp) AS yr, SUM(product_on_order. quantity) AS purchases
FROM product_on_order
JOIN order 
ON product_on_order.order_id = order.order_id
GROUP BY product_on_order.product_name, MONTH(order.order_placing_timestamp), YEAR(order.order_placing_timestamp)
);


SELECT  distinct P1.product_name
FROM ProductsMonthlySales P1, ProductsMonthlySales P2, ProductsMonthlySales P3
WHERE (P1.product_name = P2.product_name, AND P3.product_name = P2.product_name)
AND( (P1.yr = P2.yr AND P2.yr = P3.yr AND (P2.mon - P1.mon) = 1 AND (P3.mon - P2.mon) =1 )
OR  (P1.yr = (P2.yr-1) AND P2.yr = P3.yr AND P1.mon = 12 AND P2.mon =1 AND P3.mon = 2 )
OR (P1.yr = P2.yr AND P2.yr = P3.yr-1 AND P1.mon=11 AND P2.mon = 12 AND P3.mon =1 ))
AND (P1.purchases < P2.purchases AND P2.purchases < P3.purchases);
