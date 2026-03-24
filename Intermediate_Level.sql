----------------------------------------------------------

------------------------- FILTERING DATA 

----------------------------------------------------------
USE MyDatabase

--- COMPARISON OPERATORS---

--- Retrieve all customers from Germany
SELECT * 
FROM customers
WHERE country = 'Germany'

--- Retrieve all customers who are not from 
SELECT * 
FROM customers
WHERE country != 'Germany'

--- Retrieve all customers  with a score greater than 500
SELECT * 
FROM customers
WHERE score > 500

--- Retrieve all customers  with a score of 500 or more
SELECT * 
FROM customers
WHERE score >= 500

--- Retrieve all customers  with a score less than 500 
SELECT * 
FROM customers
WHERE score < 500

--- Retrieve all customers  with a score of 500 or less
SELECT * 
FROM customers
WHERE score <= 500


------------------------------------------------------------------

--- LOGICAL OPERATORS---

--- Retrieve all customers who are from the USA AND  have a score greater than 500
SELECT * 
FROM customers
WHERE 
	country = 'USA'
	AND score > 500

--- Retrieve all customers who are from the USA OR  have a score greater than 500
SELECT * 
FROM customers
WHERE 
	country = 'USA'
	OR score > 500

--- Retrieve all customers whith a score NOT less than 500
SELECT * 
FROM customers
WHERE  NOT score < 500

----------------------------------------------------------

--- RANGE OPERATOR---

--- Retrieve all customers whose scaore falls in the range between 100 and 500
SELECT * 
FROM customers
WHERE  score BETWEEN  100 AND 500


SELECT * 
FROM customers
WHERE  score >= 100 AND score <= 500

----------------------------------------------------------

--- MEMBERSHIP OPERATOR---

--- Retrieve all customers from either Gemany OR USA
SELECT * 
FROM customers
WHERE country = 'Germany' OR country = 'USA'

SELECT * 
FROM customers 
WHERE country IN('Germany','USA') 

----------------------------------------------------------

--- SEARCH  OPERATOR---

--- Find all customers whose first name starts with 'M'
SELECT * 
FROM customers 
WHERE first_name LIKE 'M%'

--- Find all customers whose first name ends with 'n'
SELECT * 
FROM customers 
WHERE first_name LIKE '%n'

--- Find all customers whose first name contains 'r'
SELECT * 
FROM customers 
WHERE first_name LIKE '%r%'

--- Find all customers whose first name has 'r' in the third position
SELECT * 
FROM customers 
WHERE first_name LIKE '__r%'

----------------------------------------------------------

---------------------- COMBINING DATA 

----------------------------------------------------------

--- NO JOIN ---
--- Retrieve all data from customers and orders as separates results

SELECT *
FROM customers; 

SELECT *
FROM orders

----------------------------------------------------------

--- INNER JOIN ---

--- Get all customers along with their orders, but only for the customers who have placed an order
SELECT 
	c.id, 
	c.first_name, 
	o.order_id, 
	o.sales
FROM 
	customers AS c
	INNER JOIN orders AS o
ON 
	c.id = o.customer_id

----------------------------------------------------------

--- LEFT JOIN ---

--- Get all customers along with their orders, including those without orders

SELECT 
	c.id, 
	c.first_name, 
	o.order_id, 
	o.sales
FROM 
	customers AS c
	LEFT JOIN orders AS o
ON 
	c.id = o.customer_id 

SELECT 
	c.id, 
	c.first_name, 
	o.order_id, 
	o.sales
FROM 
	orders AS o
	RIGHT JOIN customers AS c
ON 
	c.id = o.customer_id

----------------------------------------------------------

--- RIGHT JOIN ---

--- Get all customers along with their orders, including orders without matching customers
SELECT 
	c.id, 
	c.first_name, 
	o.order_id, 
	o.sales
FROM 
	customers AS c
	RIGHT JOIN orders AS o
ON 
	c.id = o.customer_id 

 
 ----------------------------------------------------------

--- FULL JOIN ---

---  Get all customers and all orders, even if there's no match

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM
	customers AS c
	FULL JOIN orders AS o
ON 
	c.id = o.customer_id

----------------------------------------------------------

--- LEFT ANTI JOIN ---

---  Get all customers who haven't placed any order

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM
	customers AS c
	LEFT JOIN orders AS o
ON 
	c.id = o.customer_id

WHERE o.customer_id IS NULL

 ----------------------------------------------------------

--- LEFT ANTI JOIN ---

---  Get all orders without matching customers

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM
	customers AS c
	RIGHT JOIN orders AS o
ON 
	c.id = o.customer_id

WHERE c.id IS NULL

 ----------------------------------------------------------

--- FULL  ANTI JOIN ---

---   Find customers without orders and orders without customers

SELECT *
FROM 
	customers AS c 
	FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE
	c.id IS NULL
	OR o.customer_id IS NULL 
 
---   Get all customers along with their orders, but only for customres who have placed on order without using INNER JOIN 

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM 
	customers AS c
	FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE c.id = o.customer_id

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM 
	customers AS c
	FULL JOIN orders AS o
ON c.id = o.customer_id
WHERE o.customer_id IS NOT NULL

 ----------------------------------------------------------

--- CROSS JOIN ---

---   Generate all possible combinations of customers and orders

SELECT *
FROM 
	customers 
	CROSS JOIN orders



-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


USE SalesDB

 ----------------------------------------------------------

--- MULTI TABLE JOIN ---

/* Using SalesDB
Retrieve a list of all orders,
along with the related customer,
product, and employee details
For each order, display:
	- Order ID
	- Customer's name
	- Product name
	- Sales amount
	- Product price
	- Salesperson's name
*/

SELECT * 
FROM Sales.Orders 

SELECT * 
FROM Sales.Customers 

SELECT * 
FROM Sales.Products 

SELECT * 
FROM Sales.Employees 


SELECT 
	O.OrderID,
	O.Sales,
	C.FirstName AS CustomerFristName,
	C.LastName AS CustomerLastName,
	P.Product AS ProductName,
	P.Price,
	E.FirstName AS EmployeeFirstName,
	E.LastName AS EmployerLastName,
	Total_Price = P.Price * O.Sales
FROM 
	Sales.Orders AS O
	LEFT JOIN Sales.Customers AS C
		ON O.CustomerID = C.CustomerID
	LEFT JOIN Sales.Products AS P
		ON O.ProductID = P.ProductID
	LEFT JOIN Sales.Employees AS E
		ON O.SalesPersonID = E.EmployeeID

----------------------------------------------------------

-------------------------SET OPERATOR---------------------

----------------------------------------------------------

--- UNION ---

SELECT
	CustomerID AS ID,
	FirstName AS First_name,
	LastName
FROM 
	Sales.Customers
UNION
SELECT  
	EmployeeID,
	FirstName,
	LastName
FROM 
	Sales.Employees
ORDER BY First_name ASC

--- Combine the data from employees and customers into one table
SELECT
	FirstName,
	LastName
FROM 
	Sales.Customers
UNION 
SELECT   
	FirstName,
	LastName
FROM 
	Sales.Employees

--- Combine the data from employees and customers into one table, including duplicates

SELECT
	FirstName,
	LastName
FROM 
	Sales.Customers
UNION ALL
SELECT   
	FirstName,
	LastName
FROM 
	Sales.Employees

--- Find employees who are not customers at the same time

SELECT
	FirstName,
	LastName
FROM 
	Sales.Employees
EXCEPT
SELECT   
	FirstName,
	LastName
FROM 
	Sales.Customers 

 --- Find employees who are also customer

SELECT
	FirstName,
	LastName
FROM 
	Sales.Employees
INTERSECT
SELECT   
	FirstName,
	LastName
FROM 
	Sales.Customers
	
--- Orders are stored in separate tables (orders and ordersArchive)
-- Combine all orders into one report without duplicates
SELECT
	'Order' AS SourceTable,
	[OrderID]
	,[ProductID]
	,[CustomerID]
	,[SalesPersonID]
	,[OrderDate]
	,[ShipDate]
	,[OrderStatus]
	,[ShipAddress]
	,[BillAddress]
	,[Quantity]
	,[Sales]
	,[CreationTime]
FROM 
	Sales.Orders
UNION
SELECT  
	'OrderArchive' AS SourceTable,
	[OrderID]
	,[ProductID]
	,[CustomerID]
	,[SalesPersonID]
	,[OrderDate]
	,[ShipDate]
	,[OrderStatus]
	,[ShipAddress]
	,[BillAddress]
	,[Quantity]
	,[Sales]
	,[CreationTime]
FROM 
	Sales.OrdersArchive
ORDER BY OrderID




-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


----------------------------------------------------------

----------------------- STRING FUNCTION ------------------

----------------------------------------------------------

--- CONCAT ---
USE MyDatabase

--- Concatenate first name and country into one column 

SELECT 
	first_name,
	country,
	CONCAT(first_name, ' ',country) AS FullName
 FROM customers

----------------------------------------------------------

--- LOWER ---

 -- Convert the first name to lowercase
 SELECT 
	first_name,
	country,
	CONCAT(first_name, ' ',country) AS FullName,
	LOWER(first_name) AS low_name
 FROM customers

----------------------------------------------------------

--- UPPER ---

-- Convert the first name to uppercase

 SELECT 
	first_name,
	country,
	CONCAT(first_name, ' ',country) AS FullName,
	UPPER(first_name) AS up_name
 FROM customers

----------------------------------------------------------

--- TRIM ---

-- Find customers whose first name contains leading or trailing spaces

 SELECT 
	first_name
 FROM customers
 WHERE 
	 first_name != TRIM(first_name)


SELECT 
	first_name,
	LEN(first_name) len_name,
	LEN(TRIM(first_name)) len_trim_name,
	LEN(first_name) - LEN(TRIM(first_name)) flag
FROM customers
WHERE 
	--LEN(first_name) != LEN(TRIM(first_name))
	first_name != TRIM(first_name)


----------------------------------------------------------

--- REPLACE ---

-- Remove dashes (-) from a phone number

SELECT 
	'123-456-7890' AS phone,
REPLACE('123-456-7890', '-', '') AS clean_phone

-- Replace File Extence from txt to csv
SELECT
	'report.txt' old_filename,
REPLACE('report.txt', '.txt', '.csv') AS new_filename

----------------------------------------------------------

--- LEN ---

-- Calculate the length of each customer's first name

SELECT 
	first_name,
	LEN(first_name) AS len_name
 FROM customers


----------------------------------------------------------

--- LEFT ---

-- Retrive the first 2 characters of each first name

SELECT
	first_name,
	LEFT(first_name, 2) first_2_char,
	LEFT(TRIM(first_name), 2) first_2_char
FROM customers

----------------------------------------------------------

--- RIGHT ---

-- Retrive the last 2 characters of each first name

SELECT
	first_name,
	RIGHT(first_name, 2) last_2_char
FROM customers 

----------------------------------------------------------

--- SUBSTRING ---

-- Retrieve a list of customers'first names removing the first character

SELECT
	first_name,
	SUBSTRING(TRIM(first_name), 2, LEN(first_name)) AS sub_name
FROM customers 


----------------------------------------------------------

----------------------- NUMERIC FUNCTIONS ------------------

----------------------------------------------------------

--- ROUND ---

SELECT 3.516,
ROUND(3.516, 2) AS round2,
ROUND(3.516, 1) AS round1,
ROUND(3.516, 0) AS round0

----------------------------------------------------------

--- ABS ---

SELECT
-10,
ABS(-10),
ABS(10)

----------------------------------------------------------

----------------------- DATE & TIME ------------------

----------------------------------------------------------

----------------------- PART EXTRACTION ------------------

USE SalesDB

SELECT 
	OrderID,
	OrderDate,
	ShipDate,
	CreationTime
FROM Sales.Orders

----------------------------------------------------------

--- VALUES---

SELECT 
	OrderID,
	CreationTime,
	'2026-01-28' AS HardCoded,
	GETDATE() AS Today
FROM Sales.Orders

----------------------------------------------------------

--- DAY | MONTH | YEAR ---

SELECT 
	OrderID,
	CreationTime,
	DAY(CreationTime) AS Day,
	MONTH(CreationTime) AS Month,
	YEAR(CreationTime) AS Year
FROM Sales.Orders
 
----------------------------------------------------------

--- DATEPART ---

SELECT 
	OrderID,
	CreationTime,
	DATEPART(year, CreationTime) AS Year_dp,
	DATEPART(month, CreationTime) AS Month_dp,
	DATEPART(day, CreationTime) AS Day_dp,
	DATEPART(quarter, CreationTime) AS Quarter_dp,
	DATEPART(weekday, CreationTime) AS Weekday_dp,
	DATEPART(week, CreationTime) AS Week_dp,
	DATEPART(hour, CreationTime) AS Hour_dp,
	DATEPART(minute, CreationTime) AS Minute_dp,
	DATEPART(second, CreationTime) AS second_dp
FROM Sales.Orders

----------------------------------------------------------

--- DATENAME ---

SELECT 
	OrderID,
	CreationTime,
	DATENAME(year, CreationTime) AS Year_dn,
	DATENAME(month, CreationTime) AS Month_dn,
	DATENAME(weekday, CreationTime) AS Weekday_dn,
	DATENAME(day, CreationTime) AS Day_dn,
	DATENAME(quarter, CreationTime) AS Quarter_dn, 
	DATENAME(week, CreationTime) AS Week_dn,
	DATENAME(hour, CreationTime) AS Hour_dn,
	DATENAME(minute, CreationTime) AS Minute_dn,
	DATENAME(second, CreationTime) AS second_dn
FROM Sales.Orders

----------------------------------------------------------

--- DATETRUNK ---

SELECT 
	OrderID,
	CreationTime,
	DATETRUNC(year, CreationTime) AS Year_dt,
	DATETRUNC(month, CreationTime) AS Month_dt,
	DATETRUNC(day, CreationTime) AS Day_dt,
	DATETRUNC(hour, CreationTime) AS Hour_dt,
	DATETRUNC(minute, CreationTime) AS Minute_dt,
	DATETRUNC(second, CreationTime) AS Second_dt
FROM Sales.Orders

SELECT
	DATETRUNC(year,CreationTime) AS Creation,
	COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(year,CreationTime) 

SELECT
	DATETRUNC(month,CreationTime) AS Creation,
	COUNT(*)
FROM Sales.Orders
GROUP BY DATETRUNC(month,CreationTime)

----------------------------------------------------------

--- EOMONTH ---
SELECT
	OrderID,
	CreationTime,
	EOMONTH(CreationTime) AS EndOfMonth,
	CAST(DATETRUNC(month, CreationTime)AS DATE)AS StartOfMonth
FROM Sales.Orders

----------------------------------------------------------

--- YEAR ---
--- How many orders were placed each year?

SELECT 
	YEAR(OrderDate),
	COUNT(*) AS NbOfOrder
FROM 
	Sales.Orders
GROUP BY 
	YEAR(OrderDate)

----------------------------------------------------------

--- MONTH ---
--- How many orders were placed each month?

SELECT 
	DATENAME(month,OrderDate) AS OrderDate,
	COUNT(*) AS NbOfOrder
FROM 
	Sales.Orders
GROUP BY 
	DATENAME(month,OrderDate)

--- Show all orders that were placed during the month of february

 SELECT
	*
 FROM Sales.Orders
 WHERE 
	MONTH(OrderDate) = 2

----------------------------------------------------------

------------------- FORMAT & CASTING ------------------

--- FROMAT ---

SELECT 
	OrderID,
	CreationTime,
	FORMAT(CreationTime,'MM-dd-yyyy') AS USA_Format,
	FORMAT(CreationTime,'dd-MM-yyyy') AS EURO_Format,
	FORMAT(CreationTime,'ddd') AS ddd,
	FORMAT(CreationTime,'dddd') AS dddd,
	FORMAT(CreationTime,'MM') AS MM,
	FORMAT(CreationTime,'MMM') AS MMM,
	FORMAT(CreationTime,'MMMM') AS MMMM
FROM Sales.Orders

--- Show CreationTime using the following format:
-- Day Wed Jan Q1 2025 12:34:56 PM

SELECT 
	CreationTime,
	FORMAT(CreationTime,'dd ddd MMM  yyyy HH:mm:ss ') AS Creation,
	'Day ' + FORMAT(CreationTime,'ddd MMM') + ' Q' 
	+ DATENAME(quarter, CreationTime) + FORMAT(CreationTime,' yyyy hh:mm:ss tt')
	AS CustomeFormat
FROM Sales.Orders

SELECT 
	FORMAT(OrderDate, 'MMM yy') AS OrderDate,
	Count(*) 
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMM yy')

----------------------------------------------------------

--- CONVERT ---

SELECT 
	CONVERT(INT, '123') AS [String to Int CONVERT],
	CONVERT(DATE, '2025-08-20') AS [String to Date CONVERT],
	CreationTime,
	CONVERT(DATE, CreationTime) AS [DateTime to Date CONVERT]
FROM Sales.Orders


SELECT 
	CreationTime,
	CONVERT(DATE, CreationTime) AS [DateTime to Date CONVERT],
	CONVERT(VARCHAR, CreationTime, 32) AS [USA Std. Style:32],
	CONVERT(VARCHAR, CreationTime, 34) AS [USA Std. Style:34],
	CONVERT(VARCHAR, CreationTime, 0) AS [Style:0]
FROM Sales.Orders


----------------------------------------------------------

--- CAST ---

SELECT
	CAST('123' AS INT) AS [String to Int],
	CAST(123 AS VARCHAR) AS [Int to String],
	CAST('2026-02-09' AS DATE) AS [String to Date],
	CAST('2026-02-09' AS DATETIME2) AS [String to Datetime],
	CreationTime,
	CAST(CreationTime AS DATE) AS [Datetime to Date]
FROM 
	Sales.Orders
  

----------------------------------------------------------

------------------- CALCULATION ------------------

--- DATEADD ---

SELECT 
	OrderID,
	OrderDate, 
	DATEADD(day, -10, OrderDate) AS TenDaysBefore,
	DATEADD(month, 3, OrderDate) AS ThreeMonthsLater,
	DATEADD(year, 2, OrderDate) AS TwoYearsLater
FROM 
	Sales.Orders

----------------------------------------------------------

--- DATEDIFF ---

SELECT
	OrderID,
	OrderDate,
	ShipDate,
	DATEDIFF(year,OrderDate, ShipDate) AS YearDiff,
	DATEDIFF(month,OrderDate, ShipDate)AS MonthDiff,
	DATEDIFF(day,OrderDate, ShipDate) AS DayDiff
FROM 
	Sales.Orders

-- Calculate the age of employees

SELECT
	FirstName,
	LastName,
	DATEDIFF(year, BirthDate, GETDATE()) AS Age,
	DATEDIFF(month, BirthDate, GETDATE()) AS MonthAge,
	DATEDIFF(day, BirthDate, GETDATE()) AS DayAge
FROM 
	Sales.Employees

SELECT
	DATEDIFF(year, '1997-01-28', GETDATE()) AS AgeFidi,
	DATEDIFF(month, '1997-01-28', GETDATE()) AS MonthAgeFidi,
	DATEDIFF(day, '1997-01-28', GETDATE()) AS DayAgeFidi,
	DATEDIFF(year, '2001-10-22', GETDATE()) AS AgeKanto,
	DATEDIFF(month, '2001-10-22', GETDATE()) AS MonthAgeKanto,
	DATEDIFF(day, '2001-10-22', GETDATE()) AS DayAgeKanto

-- Find the average shipping duration in days for each month

SELECT
	OrderDate,
	ShipDate,
	DATEDIFF(day, OrderDate,ShipDate) AS ShippingDuration
FROM 
	Sales.Orders

SELECT 
	FORMAT(OrderDate, 'MMMM yy') AS OrderDate,
	AVG(DATEDIFF(day, OrderDate,ShipDate)) AS AvgShippingDuration
FROM Sales.Orders
GROUP BY FORMAT(OrderDate, 'MMMM yy')

--- LAG ---
-- Find the number of days between each order and previous order

SELECT
	OrderDate AS CurrentOrder,
	LAG(OrderDate)OVER (ORDER BY OrderDate) AS PreviousOrder,
	DATEDIFF(day, LAG(OrderDate)OVER (ORDER BY OrderDate), OrderDate) DayBetween
FROM 
	Sales.Orders

----------------------------------------------------------

--- ISDATE ---

SELECT 
	ISDATE('123') DateCheck1,
	ISDATE('2025-08-20') DateCheck2,
	ISDATE('20-08-2025') DateCheck3,
	ISDATE('2025') DateCheck4,
	ISDATE('08') DateCheck5

SELECT
	--CAST(OrderDate AS DATE) AS OrderDate*
	OrderDate,
	ISDATE(OrderDate),
	CASE WHEN ISDATE(OrderDate)= 0 THEN CAST(OrderDate AS DATE)
	END NewOrderDate
FROM
(
	SELECT '2025-08-20' AS 	OrderDate UNION
	SELECT '2025-08-21' UNION
	SELECT '2025-08-23' UNION
	SELECT '2025-08-24'
)t

----------------------------------------------------------

----------------------- NULL FUNCTION ------------------

----------------------------------------------------------

--- ISNULL ---
 
SELECT 
	ISNULL(ShipAddress, 'unknown')
FROM
	Sales.Orders

SELECT 
	ISNULL(ShipAddress, BillAddress)
FROM
	Sales.Orders

----------------------------------------------------------

--- COALESCE ---
 
SELECT 
	COALESCE(ShipAddress, BillAddress,'N/A')
FROM
	Sales.Orders

-- Find the average scores of the customers

SELECT 
	CustomerID,
	Score,
	AVG(Score) OVER() AvgScores,
	AVG(COALESCE(Score,0)) OVER() AverageScore 
FROM
	Sales.Customers

 /* Display the full name of customers in a single field
 by merging their first and last names,
 and add 10 bonus points to each customer's score */

SELECT 
	CustomerID,
	FirstName + ' ' + COALESCE(LastName, '') AS FullName,
	COALESCE(Score,0)+10 AS Score10
FROM
	Sales.Customers

-- Sort the customers from lowest to highest scores, with NULLs appearing last

SELECT 
	*
FROM
	Sales.Customers
ORDER BY COALESCE(Score,'99999999') ASC

SELECT 
	CustomerID,
	Score
FROM
	Sales.Customers
ORDER BY 
	CASE WHEN Score IS NULL THEN 1 ELSE 0 END,
	Score




----------------------------------------------------------

--- NULLIF ---

-- Find the sales price for each order by dividing the sales by the quantity

SELECT 
	OrderID,
	Quantity,
	Sales, 
	Sales / NULLIF(Quantity,0) AS SalesPrice
FROM 
	Sales.Orders

----------------------------------------------------------

--- IS NULL / IS NOT NULL ---

-- Identify the customers who have no scores

SELECT 
	*
FROM 
	Sales.Customers
WHERE 
	Score IS NULL

-- List all customers who have scores

SELECT 
	*
FROM 
	Sales.Customers
WHERE 
	Score IS NOT NULL

-- List all details for customers who have not palcef any orders

SELECT 
	C.*,
	O.OrderID
FROM 
	Sales.Customers AS C
	LEFT JOIN Sales.Orders AS O
ON 
	C.CustomerID = O.CustomerID
WHERE
	O.CustomerID IS NULL

-- NULL VS EMPTY STRING VS BLANC SPACE

WITH Orders AS (
	SELECT 1 ID, 'A' CATEGORY UNION
	SELECT 2, NULL UNION
	SELECT 3, '' UNION
	SELECT 4, '  ' 
)
SELECT
	*,
	TRIM(CATEGORY) AS POLICY1,
	DATALENGTH(TRIM(CATEGORY)) AS LENPOLICY1,
	DATALENGTH(CATEGORY) AS  LENCATEGORY,
	NULLIF(TRIM(CATEGORY),'') AS POLICY2,
	COALESCE(NULLIF(TRIM(CATEGORY),''), 'unknown') POLICY3
FROM Orders


----------------------------------------------------------

----------------------- CASE STATEMENT ------------------

----------------------------------------------------------

/* Generate a report showing the total sales for each category:
	- High: If the sales higher than 50
	- Medium: If the sales between 20 and 50
	- Low: If the seles equal or lower than 20
Sort the result from lowest to highest */

SELECT 
	OrderID,
	Sales,
	CASE
		WHEN Sales > 50 THEN 'High'
		WHEN Sales > 20 THEN 'Medium'
		ELSE 'Low'
	END AS Category
FROM 
	Sales.Orders
ORDER BY 
	Sales DESC
---------------------------------------------
SELECT
	Category,
	SUM(Sales) AS TotalSales
FROM(
	SELECT 
		OrderID,
		Sales,
		CASE
			WHEN Sales > 50 THEN 'High'
			WHEN Sales > 20 THEN 'Medium'
			ELSE 'Low'
		END AS Category
	FROM 
		Sales.Orders
)t
GROUP BY Category
ORDER BY TotalSales DESC

--- Retrieve employee details with gender displayed as full text

SELECT
	*,
	CASE
		WHEN Gender = 'M' THEN 'Male'
		WHEN Gender = 'F' THEN 'Female'
		ELSE 'Not Avaiable'
	END AS GenderFullText
FROM 
	Sales.Employees

--- Retrieve customer details with abbreviated countty code 
-- Full Form
SELECT
	*,
	CASE
		WHEN Country = 'Germany' THEN 'DE'
		WHEN Country = 'USA' THEN 'US'
		ELSE 'Not Avaiable'
	END AS ContryCode 
FROM 
	Sales.Customers

SELECT DISTINCT 
	Country
FROM Sales.Customers

-- Quick Form
SELECT
	*,
	CASE Country
		WHEN 'Germany' THEN 'DE'
		WHEN 'USA' THEN 'US'
		WHEN 'Italy' THEN 'IT'
		WHEN 'France' THEN 'FR'
		ELSE 'Not Avaiable'
	END AS ContryCode 
FROM 
	Sales.Customers

-- Find rhe average scores of customers and treat NULLs as 0 
-- and additional provide details such CustomerID & LasrName

SELECT
	CustomerID ,
	LastName ,
	Score,
	AVG(CASE  
			WHEN Score IS NULL THEN 0
			ELSE Score
		END) OVER() AS AverageScore 
FROM  
	Sales.Customers

-- Count how manu times each customers has made an order with sales greater than 30
SELECT 
	CustomerID,
	SUM(CASE
			WHEN Sales > 30 THEN 1
			ELSE 0
		END) AS HighSalesOrder,
	COUNT(*) AS TotalOrder
FROM 
	Sales.Orders 
GROUP BY CustomerID

SELECT 
	CustomerID,
	Sales
FROM Sales.Orders


-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------


----------------------------------------------------------------------------
--------------------------- AGGREGATE FUNCTIONS ----------------------------
----------------------------------------------------------------------------
USE MyDatabase

-- Find the total number of order 
SELECT
	COUNT(*) AS NbOrder
FROM
	orders
 
 -- Find the total sales of all orders
SELECT
	SUM(sales) AS TotalSales
FROM
	orders

-- Find the average sales of all orders
SELECT
	AVG(COALESCE(sales,0)) AS AvgSales
FROM
	orders

-- Find the highest score among customers
SELECT 
	MAX(score) AS MaxScore
FROM 
	customers

-- Find the lowest score among customers
SELECT 
	MIN(score) AS MinScore
FROM 
	customers

-- Aggregate
SELECT
	COUNT(*) AS NbOrder,
	SUM(sales) AS TotalSales,
	AVG(COALESCE(sales,0)) AS AvgSales,
	MAX(sales) AS MaxOrder,
	MIN(sales) AS MinOrder
FROM
	orders

-- Analyze the scores in customers table
SELECT 
	country,
	COUNT(*) AS NbScore,
	SUM(score) AS TotalScore,
	AVG(COALESCE(score,0)) AS AvgScore,
	MAX(score) AS MaxScore,
	MIN(score) AS MinScore
FROM
	customers
GROUP BY country

----------------------------------------------------------------------------
------------------------------- WINDOW BASICS ------------------------------
----------------------------------------------------------------------------
USE SalesDB

-- Find the total sales across all orders
SELECT 
	SUM(Sales) AS TotalSales
FROM Sales.Orders
	
-- Find the total sales for each product
SELECT 
	P.Product,
	SUM(O.Sales) AS TotalSales
FROM 
	Sales.Orders AS O
	JOIN Sales.Products AS P
ON 
	O.ProductID = P.ProductID
GROUP BY
	P.Product

/* Find the total sales for each product, 
additionally provide details such order id & order date */
SELECT 
	O.OrderID,
	O.OrderDate,
	P.Product,
	SUM(O.Sales) OVER(PARTITION BY P.ProductID) AS TotalSales
FROM 
	Sales.Orders AS O
	JOIN Sales.Products AS P
ON 
	  O.ProductID = P.ProductID

/* Find the total sales across all orders, 
additionally provide details such order id & order date */
SELECT
	OrderID,
	OrderDate,
	SUM(Sales) OVER() AS TotalSales
FROM 
	Sales.Orders

/*  Find the total sales across all orders, 
Find the total sales for each product, 
additionally provide details such order id & order date */
SELECT
	OrderID,
	OrderDate,
	ProductID, 
	Sales,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct,
	SUM(Sales) OVER() AS TotalSales
	
FROM 
	Sales.Orders

/*   
Find the total sales across all orders,
Find the total sales for each product,
Find the total sales for each combination of product and order status, 
additionally provide details such order id & order date */
SELECT
	OrderID,
	OrderDate,
	ProductID, 
	OrderStatus,
	Sales,
	SUM(Sales) OVER(PARTITION BY ProductID, OrderStatus) AS SalesByProductAndStatus,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesByProduct,
	SUM(Sales) OVER() AS TotalSales
	
FROM 
	Sales.Orders

/* Rank each order based on their sales from highest to lowest, 
additionally provide details such order id & order date */
SELECT 
	OrderID,
	OrderDate,
	Sales,
	RANK() OVER(ORDER BY Sales DESC) AS [Rank Sales]
FROM 
	Sales.Orders

--- FRAME CLAUSE ---
SELECT
	OrderID,
	OrderDate,
	OrderStatus,
	Sales,
	SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate
	ROWS BETWEEN CURRENT ROW AND 2 FOLLOWING ) AS TotalSales,
	SUM(Sales) OVER (PARTITION BY OrderStatus ORDER BY OrderDate) AS TotalSales2
FROM 
	Sales.Orders

-- Find the total sales for each order status, only for two producrs 101 and 102
SELECT 
	Sales,
	OrderStatus,
	ProductID,
	SUM(Sales) OVER(PARTITION BY OrderStatus) AS TotalSales
FROM 
	Sales.Orders
WHERE
	ProductID IN (101,102)

-- Rank customers based on their total sales 
SELECT 
	CustomerID,
	SUM(Sales) AS TotalSales,
	RANK() OVER(ORDER BY SUM(Sales) DESC) AS RankCustomers
FROM 
	Sales.Orders
GROUP BY CustomerID

----------------------------------------------------------------------------
-------------------------- AGGREGATE WINDOW FUNCTION -----------------------
----------------------------------------------------------------------------

----------------------------------------------------------------------------
--- COUNT ---
-- Find the total number of Orders for each product
SELECT
	ProductID,
	OrderID,
	COUNT(Sales) OVER(PARTITION BY ProductID) AS NbOrderProduct
FROM
	Sales.Orders

/* Find the total number of Orders
additionally provide details such order id & order date */
SELECT
	OrderID,
	OrderDate,
	COUNT(*) OVER() AS TotalOrders,
	COUNT(1) OVER() AS TotalOrders1
FROM
	Sales.Orders

/* Find the total number of Orders
Find the total  Orders for each customers
additionally provide details such order id & order date */
SELECT
	OrderID,
	OrderDate,
	COUNT(*) OVER() AS TotalOrders,
	CustomerID,
	COUNT(*) OVER(PARTITION BY CustomerID) AS OrderCustomers
FROM
	Sales.Orders

/* Find the total number of customers,
additionally provide all customer's details */
SELECT	
	*,
	COUNT(CustomerID) OVER() AS TotalCustomers
FROM
	Sales.Customers

/* Find the total number of customers,
Find the total number of scores for the customers,
additionally provide all customer's details */
SELECT	
	*,
	COUNT(CustomerID) OVER() AS TotalCustomers,
	COUNT(Score) OVER() AS TotalScore,
	COUNT(Country) OVER() AS TotalCountries,
	COUNT(LastName) OVER() AS TotalLastName
FROM
	Sales.Customers

/* Check whether the table 'Orders' contains any duplicate rows */
SELECT 
	OrderID,
	COUNT(*) OVER(PARTITION BY OrderID) AS CheckPK 
FROM
	Sales.Orders

SELECT 
	*
FROM (
	SELECT 
		OrderID,
		COUNT(*) OVER(PARTITION BY OrderID) AS CheckPK 
	FROM
		Sales.OrdersArchive
)t WHERE CheckPK > 1 

----------------------------------------------------------------------------
--- SUM ---

/* Find the total sales acrorss all orders
and the total sales for each product.
Additionally, provide details such as order ID and order date */
SELECT 
	OrderID,
	OrderDate,
	Sales,
	SUM(Sales) OVER() TotlalSalesOrders,
	ProductID,
	SUM(Sales) OVER(PARTITION BY ProductID) AS TotalSalesProduct
FROM
	Sales.Orders

/* Find the percentage contribution  of each product's sales 
to the total sales */
SELECT
	OrderID,
	ProductID,
	Sales,
	SUM(Sales) OVER() AS TotalSales,
	ROUND(CAST(Sales AS float) / SUM(Sales) OVER() * 100, 2)AS [Percentage Contribution]
FROM
	Sales.Orders

----------------------------------------------------------------------------
--- AVG  ---

/* Find the average sales across all orders
and find the average saLes for each product
additionally provide details such order ID, order date */
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	AVG(Sales) OVER () AvgSalesOrder,
	AVG(Sales) OVER (PARTITION BY ProductID) AS AvgEachProduct
FROM
	Sales.Orders

/* Find the average scores of customers
Additionally, provide details such as Customer ID and Last Name */
SELECT
	CustomerID,
	LastName,
	Score,
	AVG(COALESCE (Score, 0))  OVER () AS AvgScore
FROM
	Sales.Customers

/* Find all orders where sales are higher than the average sales
across all orders */
SELECT
	*
FROM (
	SELECT 
		OrderID,
		ProductID,
		Sales,
		AVG(Sales) OVER () AS AvgSales

	FROM 
		Sales.Orders
)t
WHERE
	Sales > AvgSales

----------------------------------------------------------------------------
--- MIN / MAX  ---

/* Find the highest and lowest sales of all orders
Find the highest and lowest sales for each product
Additionally provide details such order ID , Order date */
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER () AS MaxOrder,
	MIN(Sales) OVER () AS MinOrder,
	MAX(Sales) OVER (PARTITION BY ProductID) AS MaxProduct,
	MIN(Sales) OVER (PARTITION BY ProductID) AS MinProduct
FROM 
	Sales.Orders

/* Show the employees with the highest salaries */
SELECT
	*
FROM (
	SELECT 
		EmployeeID,
		FirstName,
		Salary,
		MAX(Salary) OVER() AS HighestSalary
	FROM
		Sales.Employees
)t
WHERE
	Salary = HighestSalary

/* Calculate the deviation of each sale from both 
the minimum and maximum sales amounts */
SELECT 
	OrderID,
	OrderDate,
	ProductID,
	Sales,
	MAX(Sales) OVER () HighestSales,
	MIN(Sales) OVER () LowestSales,
	Sales - MIN(Sales) OVER () AS LowestDeviation,
	MAX(Sales) OVER () - Sales AS  HighesttDeviation
FROM
	Sales.Orders

----------------------------------------------------------------------------
-------------------------- ROLLING & RUNNING TOTAL -------------------------
----------------------------------------------------------------------------
/* Calculate the moving avrerage of sales for each product over time 
RUNNING TOTAL
*/

SELECT
	OrderDate,
	Sales,
	ProductID,
	AVG(Sales) OVER (PARTITION BY ProductID) AS AverageByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate) AS MovingAverageByProduct
FROM
	Sales.Orders

/* Calculate the moving avrerage of sales for each product over time, 
including only the next order
ROLLING TOTAL
*/

SELECT
	OrderDate,
	Sales,
	ProductID,
	AVG(Sales) OVER (PARTITION BY ProductID) AS AverageByProduct,
	AVG(Sales) OVER (PARTITION BY ProductID ORDER BY OrderDate ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS RollingAverageByProduct
FROM
	Sales.Orders

----------------------------------------------------------------------------
-------------------------- WINDOW RANKING FUNCTION -------------------------
----------------------------------------------------------------------------

-- Rank the orders based on their sales from highest to lowest
SELECT
	OrderID,
	Sales,
	ROW_NUMBER()	OVER(ORDER BY Sales DESC) AS SalesRank_Row,
	RANK()			OVER(ORDER BY Sales DESC) AS SalesRank_Rank,
	DENSE_RANK()	OVER(ORDER BY Sales DESC) AS SalesRank_DenseRank
FROM
	Sales.Orders

-- Find the top higest sales for each product
SELECT
	*
FROM (
	SELECT
		OrderID,
		Sales,
		ProductID,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS RankByProduct
	FROM
		Sales.Orders
)t WHERE RankByProduct = 1

-- Find the lowest 2 customers based on their total sales
SELECT
	*
FROM (
	SELECT 
		 CustomerID,
		 SUM(Sales) AS TotalSales,
		 ROW_NUMBER() OVER (ORDER BY SUM(Sales)) AS RankOrder
	FROM 
		Sales.Orders
	GROUP BY 
		CustomerID
)t WHERE RankOrder <= 2

-- Assign unique IDs to the rows of the 'Orders Archive' table
SELECT 
	ROW_NUMBER() OVER(ORDER BY OrderID, CreationTime) AS NewIDs,
	*
FROM
	Sales.OrdersArchive

/* Identify ducplicate rows in the table 'Orders Archive' 
and return a clean result without any duplicates */
SELECT
	*
FROM(
	SELECT 
		ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS RowNb,
		*
	FROM
		Sales.OrdersArchive
)t WHERE RowNb = 1

/* Identify ducplicate rows in the table 'Orders Archive' 
and return a bad result with duplicates */
SELECT
	*
FROM(
	SELECT 
		ROW_NUMBER() OVER(PARTITION BY OrderID ORDER BY CreationTime DESC) AS RowNb,
		*
	FROM
		Sales.OrdersArchive
)t WHERE RowNb > 1


--- NTILE ---
SELECT
	OrderID,
	Sales,
	NTILE(1) OVER (ORDER BY Sales DESC) AS Buckets1,
	NTILE(2) OVER (ORDER BY Sales DESC) AS Buckets2,
	NTILE(3) OVER (ORDER BY Sales DESC) AS Buckets3,
	NTILE(4) OVER (ORDER BY Sales DESC) AS Buckets4,
	NTILE(5) OVER (ORDER BY Sales DESC) AS Buckets5
FROM
	Sales.Orders

/* Segment all orders into 3 categories:
	- high
	- medium
	- and low sales 
For data segmentation
*/
SELECT	
	*,
	CASE 
		WHEN Categories = 1	THEN 'High'
		WHEN Categories = 2 THEN 'Medium'
		ELSE 'Low'
	END [Sales Segmentation]
FROM (
	SELECT 
		OrderID,
		Sales,
		NTILE(3) OVER (ORDER BY Sales DESC ) AS Categories
	FROM
		Sales.Orders
)t 

/* In order to export the data,
divide the orders into 2 groups 
For load balancing
*/
SELECT 
	NTILE(2) OVER (ORDER BY OrderID) AS Bucket,
	*
FROM
	Sales.Orders

-----------------------------------------------------------------------------

/* Find the products tha fall within the highest 40% of prices */

--- CUME_DIST ---
SELECT
	*,
	CONCAT(DistRank * 100, '%')
FROM (
	SELECT 
		Product,
		Price,
		CUME_DIST() OVER(ORDER BY Price DESC) AS DistRank
	FROM
		Sales.Products
)t 
WHERE 
	DistRank <= 0.4

--- PERCENT_RANK ---
SELECT
	*,
	CONCAT(DistRank * 100, '%')
FROM (
	SELECT 
		Product,
		Price,
		PERCENT_RANK() OVER(ORDER BY Price DESC) AS DistRank
	FROM
		Sales.Products
)t 
WHERE 
	DistRank <= 0.4

----------------------------------------------------------------------------
---------------------------- VALUE WINDOW FUNCTION -------------------------
----------------------------------------------------------------------------

------------ LEAD & LAG ------------------

 /* Analyze the month-ovre-month (MoM) performance
 by finding the percentage change in sales 
 between the current and previous month */
SELECT
	*,
	LAG(CurrentMonthSales) OVER(ORDER BY MonthOrder) AS PreviousMonth
FROM (
	SELECT 
		MONTH(OrderDate) AS MonthOrder,
		SUM(Sales) AS CurrentMonthSales
	FROM
		Sales.Orders
	GROUP BY 
		MONTH(OrderDate)
)t

SELECT
	*,
	CurrentMonthSales - PreviousMonth AS MoM_Change,
	CONCAT(ROUND(CAST((CurrentMonthSales - PreviousMonth)AS FLOAT)/PreviousMonth*100,2),' %') AS MoMPercentageChange
FROM (
	SELECT 
		MONTH(OrderDate) AS MonthOrder,
		SUM(Sales) AS CurrentMonthSales,
		LAG(SUM(Sales)) OVER (ORDER BY MONTH(OrderDate)) AS PreviousMonth
	FROM
		Sales.Orders
	GROUP BY 
		MONTH(OrderDate)
)t 

/* Analyse customer loyalty by ranking customers
based on the average number of days between orders */
SELECT
	CustomerID,
	AVG(DayBetween) AS AvgDay
FROM (
	SELECT
		*,
		DATEDIFF(day,OrderDate,DayNext) AS DayBetween
	FROM(
		SELECT 
			OrderID,
			CustomerID,
			OrderDate,
			LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS DayNext
		FROM
			Sales.Orders
	)t
)t
GROUP BY 
	CustomerID
	
SELECT
	CustomerID,
	AVG(DaysUntilNextOrder) AS AvgDays,
	RANK() OVER(ORDER BY COALESCE(AVG(DaysUntilNextOrder),999999)) AS CustomerRank
FROM (
	SELECT 
		OrderID,
		CustomerID,
		OrderDate,
		LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS DayNext,
		DATEDIFF(day,OrderDate,LEAD(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate)) DaysUntilNextOrder
	FROM
		Sales.Orders
)t
GROUP BY 
	CustomerID

------------ FIRST_VALUE & LAST_VALUE ------------------

/* Find the lowest and highest sales for each product*/
SELECT
	OrderID,
	ProductID,
	Sales,
	MIN(Sales) OVER(PARTITION BY ProductID) AS MinLowest,
	MAX(Sales) OVER(PARTITION BY ProductID) AS MaxHighest,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ASC) AS FirestLowest,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS FirestHighest,
	LAST_VALUE(Sales) OVER(
		PARTITION BY ProductID ORDER BY Sales DESC
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS LastLowest,
	LAST_VALUE(Sales) OVER(
		PARTITION BY ProductID ORDER BY Sales ASC
		ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS HighLowest
FROM
	Sales.Orders

/* Find the lowest and highest sales for each product
Find the difference in sales between the current and the lowest sales
*/
SELECT
	OrderID,
	ProductID,
	Sales,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ASC) AS FirestLowest,
	FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS FirestHighest,
	Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales ASC) AS DiffCurrent_Lowest,
	Sales - FIRST_VALUE(Sales) OVER(PARTITION BY ProductID ORDER BY Sales DESC) AS DiffCurrent_Hight
FROM
	Sales.Orders
