# Superstore Sales Analysis (SQL)
Using SQL to transform raw Superstore data into revenue-driving insights.

This project showcases how I used SQL to clean and analyze sales and return data from the Superstore dataset — answering key business questions and uncovering profit-driving insights.

## Project Summary
- Cleaned raw data using `ALTER TABLE` and converted key columns (Sales, Profit, Dates)
- Analyzed sales, profits, returns, customer trends, and shipping modes
- Delivered insights that help businesses increase revenue and reduce loss
- Tools used: SQL Server, Excel, GitHub

## Key Insights
- Central and West regions had the highest profit
- High discounts often led to low or negative profits
- Office Supplies and Technology were top-selling categories
- Standard Class shipping was both most used and fastest
- Some sub-categories had high return rates

## Sample SQL Query
```sql
-- Found which products we should stop discounting
SELECT 
    [Sub-Category],
    AVG(Discount) AS avg_discount,
    AVG(Profit) AS avg_profit
FROM Superstore_Orders
GROUP BY [Sub-Category]
HAVING AVG(Profit) < 0  -- Only show money-losing products
ORDER BY avg_discount DESC;
```
## Files
- File	Description
- superstore_analysis.sql	is for all SQL queries used in analysis
- README.md; This file (project summary)

## Author
- Jimoh Rokeeb
- Email: jrokeeb5@gmail.com
- Location: Nigeria
- LinkedIn: www.linkedin.com/in/jimoh-rokeeb
