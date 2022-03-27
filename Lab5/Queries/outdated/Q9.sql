-- Find products that are increasingly being purchased over at least 3 months.
DROP VIEW IF EXISTS ProductsInMonthYear 
DROP VIEW IF EXISTS PdtMonthlySales

GO
-- create a view of the products sold, their quantities, month and year
CREATE VIEW ProductsInMonthYear AS
(
SELECT product_name, order_quantity, MONTH(order_placing_timestamp) AS Month, YEAR(order_placing_timestamp) AS Year
FROM product_on_order
         JOIN orders ON product_on_order.order_id = orders.order_id);

GO
-- view showing the total quantity of each product for per month, per year
CREATE VIEW PdtMonthlySales AS
(
SELECT product_name, Month, Year, SUM(order_quantity) AS TotalQuantity
FROM ProductsInMonthYear
GROUP BY product_name, Month, Year);

GO
SELECT DISTINCT P1.product_name
FROM PdtMonthlySales P1,
     PdtMonthlySales P2,
     PdtMonthlySales P3
WHERE (P1.product_name = P2.product_name AND P2.product_name = P3.product_name)
  AND (
        (P1.Year = P2.Year AND (P3.Year - P2.Year) = 1
             AND P1.Month = 11 AND P2.Month = 12 AND P3.Month = 1) --e.g. Nov 2021, Dec 2021 and Jan 2022
        OR ((P2.Year - P1.Year) = 1 AND P2.Year = P3.Year
                AND P1.Month = 12 AND P2.Month = 1 AND P3.Month = 2) --e.g. Dec 2021, Jan 2022 and Feb 2022
        OR (P1.Year = P2.Year AND P2.Year = P3.Year
                AND (P3.Month - P2.Month) = 1 AND (P2.Month - P1.Month) = 1) --any 3 consecutive months in 2021.
    )
  AND (P3.TotalQuantity > P2.TotalQuantity AND P2.TotalQuantity > P1.TotalQuantity);

SELECT *
FROM PdtMonthlySales
ORDER BY product_name, Month, Year;
