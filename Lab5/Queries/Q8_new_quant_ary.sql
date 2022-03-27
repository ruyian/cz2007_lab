drop view if exists UniqueUsers
drop view if exists UsersOfProducts
drop view if exists PdtsNotBoughtByAll
drop view if exists UnpopularPdts
drop view if exists PdtPurchasesInAugust
drop view if exists Top5MostPurchasedPdts

CREATE VIEW UniqueUsers AS --this view has the total number of unique users in the system
(SELECT COUNT(user_id) AS NoOfUniqueUsers
FROM Users);
GO
SELECT * FROM UniqueUsers;

GO
CREATE VIEW UsersOfProducts AS -- this view has the names of the products and the number of unique users who have purchased them at some point
(SELECT product_name, Count(user_id) AS NumUniquePurchasers
FROM (SELECT DISTINCT U.user_id, product_name
      FROM Users U, Orders O ,product_on_order PIO
      WHERE U.user_id=O.user_id AND O.order_id=PIO.order_id) AS UniquePurchase
GROUP BY product_name);
GO
SELECT * FROM UsersOfProducts;


GO
CREATE VIEW PdtsNotBoughtByAll AS -- this view shows the product_name, no. of unique purchasers for that product, and the total number of unique users on Sharkee
--it only selects those products which have never been purchased by some users
(SELECT product_name, NumUniquePurchasers, NoOfUniqueUsers FROM UsersOfProducts, UniqueUsers
WHERE UsersOfProducts.NumUniquePurchasers<UniqueUsers.NoOfUniqueUsers);
GO
SELECT * FROM PdtsNotBoughtByAll;

GO
CREATE VIEW UnpopularPdts AS -- this view stores only the names of those products which have never been purchased by some users
(SELECT product_name FROM PdtsNotBoughtByAll);
GO
SELECT * FROM UnpopularPdts;


GO
CREATE VIEW PdtPurchasesInAugust AS --this view stores product names with the number of their purchases in the month of august
(SELECT product_name, SUM(order_quantity) AS TotalQuantity
FROM product_on_order PIO
JOIN Orders O ON PIO.order_id =O.order_id AND
(O.order_placing_timestamp >= '2021.08.01 00:00:00' AND O.order_placing_timestamp < '2021.09.01 00:00:00')
GROUP BY product_name
);
GO
SELECT * FROM PdtPurchasesInAugust ORDER BY TotalQuantity DESC;

GO
CREATE VIEW Top5MostPurchasedPdts AS -- creating a view of the top 5 most purchased products in August
(SELECT TOP 5 * FROM PdtPurchasesInAugust ORDER BY TotalQuantity DESC); 
GO
SELECT * FROM Top5MostPurchasedPdts;

--this is the final query that returns those products which have never been purchased by some users but are the top 5 products purchased by others in August 2020.
SELECT product_name
FROM Top5MostPurchasedPdts 
INTERSECT
SELECT product_name
FROM UnpopularPdts;