-- Find products that have never been purchased by some users, but are the top 5 most purchased
-- products by other users in August 2021.

GO
CREATE VIEW AllProducts AS
(
SELECT product_name, SUM(order_quantity) AS TotalQuantity
FROM product_on_order PIO
         JOIN orders O ON PIO.order_id = O.order_id AND
                          (O.OrderDateTime >= '2021.08.01 00:00:00' AND
                           O.OrderDateTime < '2021.09.01 00:00:00')
GROUP BY product_name);

GO
-- View that excludes top product in August
CREATE VIEW NonTop1Products AS
(
SELECT *
FROM AllProducts AP
WHERE AP.TotalQuantity <> (SELECT MAX(TotalQuantity)
                           FROM Allproducts AP2));

GO
-- View that excludes top 2 product in August
CREATE VIEW NonTop2Products AS
(
SELECT *
FROM NonTop1Products NT
WHERE NT.TotalQuantity <> (SELECT MAX(TotalQuantity)
                           FROM NonTop1Products NT1));

GO
-- View that excludes top 3 product in August
CREATE VIEW NonTop3Products AS
(
SELECT *
FROM NonTop2Products NT
WHERE NT.TotalQuantity <> (SELECT MAX(TotalQuantity)
                           FROM NonTop2Products NT1));

GO
-- View that excludes top 4 product in August
CREATE VIEW NonTop4Products AS
(
SELECT *
FROM NonTop3Products NT
WHERE NT.TotalQuantity <> (SELECT MAX(TotalQuantity)
                           FROM NonTop3Products NT1));

GO
-- View that excludes top 5 product in August
CREATE VIEW NonTop5Products AS
(
SELECT *
FROM NonTop4Products NT
WHERE NT.TotalQuantity <> (SELECT MAX(TotalQuantity)
                           FROM NonTop4Products NT1));

GO
-- View that get top 5 product in August
-- Assume that there can be more than 5 products if products have the same order quantity.
CREATE VIEW TopProducts AS
(
SELECT *
FROM AllProducts
    EXCEPT
SELECT *
FROM NonTop5Products);

GO
-- View that gets the number of unique users
CREATE VIEW UserCount AS
SELECT COUNT(*) AS NumUniqueUsers
FROM users;

GO
-- View that gets the number of unique purchases for each product
CREATE VIEW UniquePurchases AS
SELECT product_name, Count(user_id) AS NumUniquePurchases
FROM (SELECT DISTINCT U.user_id, product_name
      FROM users U,
           orders O,
           product_on_order PIO
      WHERE U.UserID = O.UserID
        AND O.oID = PIO.oID) AS UniquePurchase
GROUP BY product_name;

GO
-- View that gets the products that are not bought by some users, but are top 5 products
SELECT DISTINCT TP.product_name
FROM TopProducts TP,
     UserCount UC,
     UniquePurchases UP
WHERE TP.product_name = UP.product_name
  AND NumUniquePurchases < NumUniqueUsers;

GO

-- additional commands to visualise views : not the query answer, but additional visualisation for clarity
-- All products
SELECT *
FROM AllProducts
ORDER BY TotalQuantity DESC;

-- Top 5 products
SELECT *
FROM TopProducts
ORDER BY TotalQuantity DESC;

-- Number of unique users
SELECT *
FROM UserCount;

-- Number of  unique purchases for each product
SELECT *
FROM UniquePurchases;

-- Number of  unique purchases for each product with number of unique users added
SELECT TP.product_name, NumUniquePurchases, NumUniqueUsers
FROM TopProducts TP,
     UserCount UC,
     UniquePurchases UP
WHERE TP.product_name = UP.product_name;