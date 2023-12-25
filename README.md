## Northwind Database Querying with MSSQL
MSSQL Studies by Azure Data Studio

Related Query Files:
-----------------------
*Questions & Answers - Part 01

*Questions & Answers  - Part 02

------------------------------------------------------------------------------------------------------------
- The Northwind database, created by Microsoft for training and educational purposes, and its E-R diagram present numerous business drivers that can be derived as follows:

   - *Sales Reporting*: Monitor sales metrics related to customers, employees, products, and suppliers.
   - *Order Fulfillment Reporting*: Analyze order delivery times to improve efficiency.
   - *Employee Performance Reporting*: Evaluate employee performance for potential improvement through rewards or training.
   - *Order Distribution & Product Inventory Analysis*: Optimize global order distribution, track inventory levels, and manage re-order processes.

Relevant tables from the Northwind E-R include: 
- Orders, Order Details, Employees, Customers, and Time Dimension table.
  
Key stakeholders include:
- Employees, Marketing, Finance, and Logistics.

The vision is to ensure customer satisfaction through superior order management and refined inventory analysis practices.

The purpose of this study is to provide insight into:

Identify top-selling products and optimize their storage.
Track inventory levels for all products.
Predict potential product shortages for proactive management.
Evaluate underperforming products and strategize improvements or discontinuation.
Evaluate discounting strategies for stagnant inventory to stimulate buying interest".

NORTHWIND Data Model
--------------------
All of the questions and queries in this assignment refer to Northwind DB

![image](https://github.com/BedirK/Data-Analytics-Bootcamp---SQL/assets/103532330/764a1929-f232-457a-bda1-51c0a67fee77)

SQL Topics Covered
-----------------------
- SELECT/SELECT DISTINCT, ALIAS
- Filtering: WHERE, AND, OR, NOT, HAVING, BETWEEN, IN, LIKE, Wildcards, TOP, EXCEPT
- Grouping: GROUP BY
- Sorting: ORDER BY, ROW_NUMBER
- Aggregations: MAX, MIN, AVG, SUM, COUNT, COUNT DISTINCT
- Joining: INNER JOIN, LEFT JOIN, UNION
