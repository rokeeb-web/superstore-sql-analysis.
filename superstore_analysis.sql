SELECT *
FROM Superstore_Orders
--Data Type Conversion for Cleaning
--Changing Data Types for Key Columns (Sales, Profit, Discount, Quantity, Dates)

ALTER TABLE Superstore_Orders ALTER COLUMN Sales FLOAT;
ALTER TABLE Superstore_Orders ALTER COLUMN Profit FLOAT;
ALTER TABLE Superstore_Orders ALTER COLUMN Discount FLOAT;
ALTER TABLE Superstore_Orders ALTER COLUMN Quantity INT;
ALTER TABLE Superstore_Orders ALTER COLUMN [Order Date] DATE;
ALTER TABLE Superstore_Orders ALTER COLUMN [Ship Date] DATE;


--Descriptive & Aggregated Insights
--Sales Distribution and Order Counts by State Province
SELECT Sales, [State Province], COUNT([State Province]) as CountProvince
FROM Superstore_Orders
GROUP BY Sales, [State Province];


--Sales and Profit Performance by Country
SELECT [Country Region],
       ROUND(SUM(Sales),0) AS TotalSales,
       ROUND(SUM(Profit),0) AS TotalProfit
FROM Superstore_Orders
GROUP BY [Country Region]
ORDER BY TotalProfit DESC;


--Sales and Profit Breakdown by Region
SELECT Region,
       ROUND(SUM(Sales),0) AS TotalSales,
       ROUND(SUM(Profit),0) AS TotalProfit
FROM Superstore_Orders
GROUP BY Region
ORDER BY TotalProfit DESC;


--Segment-Wise Sales and Profit Analysis
SELECT Segment,
       ROUND(SUM(Sales),0) AS TotalSales,
       ROUND(SUM(Profit),0) AS TotalProfit
FROM Superstore_Orders
GROUP BY Segment
ORDER BY TotalProfit DESC;


--Sales, Quantity Sold, and Profit by Product Category
SELECT Category,
       ROUND(SUM(Sales),0) AS Total_Sales,
       SUM(Quantity) AS Total_Quantity,
       ROUND(SUM(Profit),0) AS TotalProfit
FROM Superstore_Orders
GROUP BY Category
ORDER BY TotalProfit DESC;


--Sub-Category Sales, Quantity and Profit Overview
SELECT [Sub-Category], 
       SUM(Quantity) AS Total_Quantity,
       ROUND(SUM(Sales),0) AS Total_Sales,
       ROUND(SUM(Profit),0) AS Total_Profit
FROM Superstore_Orders
GROUP BY [Sub-Category]
ORDER BY [Sub-Category];


--Year-over-Year Sales vs Profit Analysis
SELECT YEAR([Ship Date]) AS Year,
       ROUND(SUM(Sales),0) AS Total_Sales,
       ROUND(SUM(Profit),0) AS Total_Profit
FROM Superstore_Orders
WHERE YEAR([Ship Date]) <> 2023
GROUP BY YEAR([Ship Date])
ORDER BY YEAR([Ship Date]), Total_Profit DESC;


--Shipping Mode Usage and Order Distribution
SELECT [Ship Mode],
       COUNT(*) AS Total_Orders,
       ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM Superstore_Orders), 2) AS Percentage_Of_Orders
FROM Superstore_Orders
GROUP BY [Ship Mode]
ORDER BY Total_Orders DESC


--Shipping Mode Efficiency: Average Delivery Time
SELECT [Ship Mode],
       AVG(DATEDIFF(DAY, [Order Date], [Ship Date])) AS Avg_Delivery_Days
FROM Superstore_Orders
GROUP BY [Ship Mode]


--Profitability & Performance Drivers
--Discount Levels vs Sales and Profitability
SELECT Discount,
       COUNT(*) AS Number_Of_Orders,
       ROUND(SUM(Sales),2) AS Total_Sales,
       ROUND(SUM(Profit),2) AS Total_Profit
FROM Superstore_Orders
GROUP BY Discount
ORDER BY Discount DESC, Total_Profit


--Top 5 Best-Selling Product Sub-Categories
WITH Cte_SalesBySubCategory AS (
    SELECT [Sub-Category],
           Discount,
           ROUND(SUM(Sales), 2) AS Total_Sales,
           ROUND(SUM(Profit), 2) AS Total_Profit
    FROM Superstore_Orders
    GROUP BY [Sub-Category], Discount
)
SELECT TOP 5 *
FROM Cte_SalesBySubCategory
ORDER BY Total_Sales DESC;


-- Customer with the Highest Sales Volume
WITH Cte_Best_Customer AS (
    SELECT [Customer Name],
           COUNT(*) AS Total_Order,
           SUM(Sales) AS Total_Sales,
           SUM(Profit) AS Total_Profit
    FROM Superstore_Orders
    GROUP BY [Customer Name]
)
SELECT *
FROM Cte_Best_Customer
WHERE Total_Order = (SELECT MAX(Total_Order) FROM Cte_Best_Customer);


-- Top Customers Based on Number of Orders
WITH Cte_Best_Customer AS (
    SELECT [Customer Name],
           COUNT(*) AS Total_Order,
           SUM(Sales) AS Total_Sales,
           SUM(Profit) AS Total_Profit
    FROM Superstore_Orders
    GROUP BY [Customer Name]
),
Cte_Max_Orders AS (
    SELECT MAX(Total_Order) AS Max_Order FROM Cte_Best_Customer
)
SELECT Cte_Best_Customer.*
FROM Cte_Best_Customer
INNER JOIN Cte_Max_Orders ON Cte_Best_Customer.Total_Order = Cte_Max_Orders.Max_Order;


--  Returns Analysis
--  Returned Orders by Sub-Category with Sales and Profit
SELECT Orders.[Sub-Category],
       Orders.Sales,
       Orders.Profit,
       Returns.Returned
FROM SuperStore_Orders AS Orders
RIGHT JOIN Superstore_Returns AS Returns ON Orders.[Order ID] = Returns.[Order ID];


--Return Rate Percentage by Product Sub-Category
SELECT [Sub-Category],
       COUNT(*) AS Total_Orders,
       SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END) AS Returned_Orders,
       ROUND(100.0 * SUM(CASE WHEN Returned = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 2) AS Return_Rate_Percent
FROM SuperStore_Orders AS Orders
LEFT JOIN Superstore_Returns AS Returns ON Orders.[Order ID] = Returns.[Order ID]
GROUP BY [Sub-Category]
ORDER BY Return_Rate_Percent DESC;


