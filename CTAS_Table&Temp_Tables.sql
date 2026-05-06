-------------------------------------------------------------------------------------
------------------------------------CTAS & TEMP--------------------------------------
-------------------------------------------------------------------------------------
--------------------------------------------
----------CREATE / INSERT VS CTAS-----------
--------------------------------------------
/* CREATE / INSERT
1. Create | Define the structure of table
2. Insert | Insert Data into the table

	CREATE TABLE Table-Name
	(
		ID INT, 
		Name VARCHAR (50)
	)
	INSERT INTO  Table-Name
	VALUES (1, 'Fi')
*/

/* CTAS
Create a new table based on the result of an SQL query
=> MySQL, Postgres, Oracle
	CREATE TABLE Name AS
	(
		SELECT ...
		FROM ...
		WHERE ...
	)  

=> SQL Server
	SELECT ...
	INTO New-Table
	FROM ...
	WHERE ...
*/
--------------------------------------------
----------------CTAS VS VIEWS---------------
--------------------------------------------
/* VIEW
The query of view has not yet been executed
Querying Slower
Fresh data
*/
/* CTAS
The query of CTAS has been already
Old data
*/
--------------------------------------------
----------------CTAS USE CASE---------------
--------------------------------------------
USE SalesDB
--- OPTIMIZE PERFORMANCE
IF OBJECT_ID('Sales.MonthlyOrders','U') IS NOT NULL
	DROP TABLE Sales.MonthlyOrders;
GO 
SELECT
	DATENAME(month, OrderDate) OrderMonth, 
	COUNT(OrderID) TotalOrders
INTO Sales.MonthlyOrders
FROM 
	Sales.Orders
GROUP BY DATENAME(month, OrderDate)

SELECT * FROM Sales.MonthlyOrders

/* USE CASE
--- CREATING A SNAPSHOT
--- Physical Data Marts in DWH 
*/


--------------------------------------------
--------------- TEMPORARY TABLES -----------
--------------------------------------------
/*
1- Loaf Data to TEMP Table
2- Transform Data in TEMP Table
3- Load TEMP Table into Permanet Table
*/
SELECT 
	*
INTO #Orders
FROM 
	Sales.Orders

DELETE FROM #Orders
WHERE OrderStatus='Delivered'

SELECT 
	*
INTO Sales.OrdersTest
FROM #Orders

SELECT 
	*
FROM Sales.OrdersTest

/* USE CASE
--- INTERMEDIATE RESULTS
--- Nerver Use  
*/
s