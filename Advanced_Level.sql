-------------------------------------------------------------------------------------
----------------------------------INFORMATION SCHEMA---------------------------------
-------------------------------------------------------------------------------------

SELECT
	DISTINCT TABLE_NAME
FROM
	INFORMATION_SCHEMA.COLUMNS

-------------------------------------------------------------------------------------
------------------------------------SUBQUERY------------------------------------
-------------------------------------------------------------------------------------
--------------------------------------------
---------------SCALER SUBQUERY--------------
--------------------------------------------
SELECT 
	AVG(Sales)
FROM
	Sales.Orders

--------------------------------------------
-----------------ROW SUBQUERY---------------
--------------------------------------------
SELECT
	CustomerID
FROM
	Sales.Orders

--------------------------------------------
-----------------TABLE SUBQUERY-------------
--------------------------------------------
SELECT
	OrderID,
	OrderDate,
	OrderStatus
FROM
	Sales.Orders

--------------------------------------------
-------------FROM CLAUSE SUBQUERY-----------
--------------------------------------------
/* Find the products that have a price higher 
than the average price of all products */
SELECT 
	*
FROM (
	SELECT 
		Product,
		Price,
		AVG(Price) OVER() AS AvgPrice
	FROM
		Sales.Products
)t 
WHERE Price > AvgPrice

/* Rank Customers based on their total amount of sales */
SELECT
	*,
	RANK() OVER(ORDER BY SumSales DESC) AS RankSales
FROM(
	SELECT
		CustomerID,
		SUM(Sales) AS SumSales
	FROM
		Sales.Orders
	GROUP BY 
		CustomerID 
)t 


--------------------------------------------
------------SELECT CLAUSE SUBQUERY----------
--------------------------------------------
/* Show the product IDs, names, prices 
and total number of orders */
--only a scaler is allowed

SELECT
	ProductID,
	Product,
	Price,
	(SELECT
		COUNT(*) 
	FROM
		Sales.Orders) AS [Total number of orders]
FROM
	Sales.Products

--------------------------------------------
--------------JOIN CLAUSE SUBQUERY----------
--------------------------------------------
/* Show all customer details and find the 
total orders for each customer */
SELECT 
	c.*,
	ToltalOrders
FROM
	Sales.Customers AS c
	LEFT JOIN (
		SELECT 
			CustomerID,
			COUNT(*) AS ToltalOrders
		FROM
			Sales.Orders
		GROUP BY 
			CustomerID) AS o
	ON
		c.CustomerID = o.CustomerID

--------------------------------------------
-------------WHERE CLAUSE SUBQUERY----------
--------------------------------------------
/* Find the products that have a price higher than the average 
price of all products.*/
SELECT
	*
FROM
	Sales.Products
WHERE
	Price > (SELECT AVG(Price) FROM Sales.Products)

--------------------------------------------
--------------IN OPERATOR SUBQUERY----------
--------------------------------------------
/* Show the details of orderes made by customers in Germani */

SELECT
	*
FROM
	Sales.Orders
WHERE
	CustomerID IN(
					SELECT
						CustomerID
					FROM
						Sales.Customers
					WHERE Country='Germany')

/* Show the details of orderes for customers who are not from Germani */
SELECT
	*
FROM
	Sales.Orders
WHERE
	CustomerID IN(
					SELECT
						CustomerID
					FROM
						Sales.Customers
					WHERE Country!='Germany')

SELECT
	*
FROM
	Sales.Orders
WHERE
	CustomerID NOT IN(
					SELECT
						CustomerID
					FROM
						Sales.Customers
					WHERE Country='Germany')

--------------------------------------------
-------------- ANY | ALL SUBQUERY ----------
--------------------------------------------
-- ANY at least
/* Find female employees whose salaries are greater 
than the salaries of any male employees */
SELECT
	*
FROM
	Sales.Employees
WHERE
	Gender='F' AND 
	Salary > ANY (
					SELECT
						Salary
					FROM	
						Sales.Employees
					WHERE
						Gender='M')
/* Find female employees whose salaries are greater 
than the salaries of all male employees */
SELECT
	*
FROM
	Sales.Employees
WHERE
	Gender='F' AND 
	Salary > ALL (
					SELECT
						Salary
					FROM	
						Sales.Employees
					WHERE Gender='M')

--------------------------------------------
--- NON-CORRELATED | CORRELATED SUBQUERY ---
--------------------------------------------
/* Show all customer details and find the total orders for each customers.*/

--- NON-CORRELATED can run independtly from the Main Query

--- CORRELATED relays on values from the Main Query
SELECT
	*,
	(SELECT 
		COUNT(*) 
	FROM 
		Sales.Orders o
	WHERE o.CustomerID = c.CustomerID) AS TotalSales
FROM
	Sales.Customers c

--------------------------------------------
-------- EXISTS CORRELATED SUBQUERY ---------
--------------------------------------------
/* Show the order details for customers in Germany. */
SELECT
	*
FROM
	Sales.Orders O
WHERE  EXISTS (
					SELECT
						1
					FROM 
						Sales.Customers C
					WHERE 
						C.Country ='Germany'
						AND O.CustomerID = C.CustomerID)

-------------------------------------------------------------------------------------
------------------------- CTE COMMON TABLE EXPRESSION -------------------------------
------------------------------------------------------------------------------------- 
-------------NON RECUSIVE CTE ---------------------
/* is executed only once without any repetition */
--------------------------------------------
-------------- STANDALONE CTE --------------
--------------------------------------------
-- Define and used independently 

-------------- SIMPLE STANDALONE CTEs -----------------
/*
STEP 1: Find the total Sales per Customer
*/
WITH CTE_Total_Sales AS 
(
	SELECT
		CustomerID,
		SUM(Sales) AS TotalSales
	FROM
		Sales.Orders
	GROUP BY 
		CustomerID
)
SELECT
	C.CustomerID,
	C.FirstName,
	C.LastName,
	cts.TotalSales
FROM 
	Sales.Customers C
	LEFT JOIN CTE_Total_Sales cts
	ON cts.CustomerID = C.CustomerID
ORDER BY 
	TotalSales

-------------- MULTIPLE STANDALONE CTEs -----------------
/*
STEP 2: Find the last order date per Customer
*/
WITH CTE_Total_Sales AS 
(
	SELECT
		CustomerID,
		SUM(Sales) AS TotalSales
	FROM
		Sales.Orders
	GROUP BY 
		CustomerID
)
, CTE_Last_Order_Date AS
(
	SELECT
		MAX(OrderDate) AS Last_Order,
		CustomerID
	FROM
		Sales.Orders
	GROUP BY
		CustomerID
)
SELECT
	C.CustomerID,
	C.FirstName,
	C.LastName,
	cts.TotalSales,
	ctd.Last_Order
FROM 
	Sales.Customers C
	LEFT JOIN CTE_Total_Sales cts
		ON cts.CustomerID = C.CustomerID
	LEFT JOIN CTE_Last_Order_Date ctd
		ON ctd.CustomerID = C.CustomerID
ORDER BY 
	TotalSales 

--------------------------------------------
---------------- NESTED CTE ----------------
--------------------------------------------
-- CTE inside another CTE 
/*
STEP 3: Rank Customers based on total sales per customer.
STEP 4: Segment customers based on their total sales.
*/
WITH CTE_Total_Sales AS 
(
	SELECT
		CustomerID,
		SUM(Sales) AS TotalSales
	FROM
		Sales.Orders
	GROUP BY 
		CustomerID
)
, CTE_Last_Order_Date AS
(
	SELECT
		MAX(OrderDate) AS Last_Order,
		CustomerID
	FROM
		Sales.Orders
	GROUP BY
		CustomerID
)
, CTE_Rank_Total_Sales AS 
(
	SELECT 
		*,
		RANK() OVER(ORDER BY TotalSales DESC) AS Rank_Sales
	FROM
		CTE_Total_Sales
)
, CTE_Customer_Segment AS 
(
	SELECT 
		CustomerID,
		CASE 
			WHEN TotalSales > 100
				THEN 'High'
			WHEN TotalSales > 80
				THEN 'Medium'
			Else
				'Low'
		END AS CustomerSegment
	FROM
		CTE_Total_Sales
)

SELECT
	C.CustomerID,
	C.FirstName,
	C.LastName,
	cts.TotalSales,
	ctd.Last_Order,
	ctr.Rank_Sales,
	ccs.CustomerSegment
FROM 
	Sales.Customers C
	LEFT JOIN CTE_Total_Sales cts
		ON cts.CustomerID = C.CustomerID
	LEFT JOIN CTE_Last_Order_Date ctd
		ON ctd.CustomerID = C.CustomerID
	LEFT JOIN CTE_Rank_Total_Sales ctr
		ON ctr.CustomerID = C.CustomerID
	LEFT JOIN CTE_Customer_Segment ccs
		ON ccs.CustomerID = C.CustomerID
ORDER BY 
	COALESCE(Rank_Sales, 999999)

--------------------------------------------
-------------- RECUSIVE CTE ----------------
--------------------------------------------
/*self-rederencing query that repeatedly processes data 
until a specific condition is met */

/* Generate a Sequence of Numbers from 1 to 20 */
WITH Series AS
(
	 -- Anchor Query
	SELECT 
		1 AS [My Number]
	UNION ALL
	-- Recursive Query
	SELECT 
		[My Number] + 1 AS [My Number]
	FROM 
		Series
	WHERE 
		[My Number] < 1000
		
)
-- Main Query
SELECT	*
FROM Series
OPTION (MAXRECURSION 10000)

/* 
Show the employee hierarchy by displaying
each employee's level within the organization.
*/
WITH CTE_Eployee_Hierarchy AS 
(
	--Anchor Query
	SELECT
		EmployeeID,
		FirstName,
		ManagerID,
		1 AS Levels
	FROM 
		Sales.Employees
	WHERE ManagerID IS NULL

	UNION ALL
	-- Recursive Query
	SELECT
		e.EmployeeID,
		e.FirstName,
		e.ManagerID,
		Levels + 1 
	FROM 
		Sales.Employees AS e
		INNER JOIN CTE_Eployee_Hierarchy ceh
			ON e.ManagerID= ceh.EmployeeID
)
-- Main Query
SELECT
	*
FROM 
	CTE_Eployee_Hierarchy


-------------------------------------------------------------------------------------
--------------------------------------------VIEWS------------------------------------
-------------------------------------------------------------------------------------
/* Find the running total of sales for each month */
WITH CTE_Monthly_Summary AS 
(
	SELECT
		MONTH(OrderDate) AS OrderMonth,
		SUM(Sales) AS TotalSales,
		COUNT(OrderID) AS TotalOrders,
		SUM(Quantity) AS TotalQuantities
	FROM
		Sales.Orders 
	GROUP BY MONTH(OrderDate)
)
SELECT
	OrderMonth,
	TotalSales,
	SUM(TotalSales) OVER (ORDER BY OrderMonth) AS RunningTotal
FROM	
	CTE_Monthly_Summary 


SELECT
	OrderMonth,
	TotalSales
FROM	
	Sales.V_MonthlySummary

--DROP VIEW V_MonthlySummary

/* Views use case:
hide complexity of database and easy-to-consume objects*/
SELECT
	*
FROM
	Sales.V_Order_Details;

/* Views use case:
Data security */

SELECT
	*
FROM
	Sales.EU_Order_Details

/* Views use case:
Flexibility & Dynamic
Multiple Languages
Virtual Data Marts in DWH
*/