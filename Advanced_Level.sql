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
--- NON-CORRELATED can run independtly from the Main Query

--- CORRELATED relays on values from the Main Query
