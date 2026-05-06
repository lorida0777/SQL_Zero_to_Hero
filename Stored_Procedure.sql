
-- For US Customers Find the Total Number of Customers and the Average Score
/*
Step 1: Write a Query
*/
SELECT 
	COUNT(*) AS NbCustomers,
	AVG(Score) AS AverageScore
FROM 
	Sales.Customers
WHERE
	Country = 'USA'
/*
Step 2: Turning the Query into a Stored Procedure
*/
CREATE PROCEDURE GetCustomerSummary AS
BEGIN
SELECT 
	COUNT(*) AS NbCustomers,
	AVG(Score) AS AverageScore
FROM 
	Sales.Customers
WHERE
	Country = 'USA'
END

/*
Step 3: Execute the Stored Procedure
*/
EXEC GetCustomerSummary

-------------------------------------
------------- PARAMETERS ------------
-------------------------------------
-- For German Customers Find the Total Number of Customers and the Average Score

/*
1 Step : Define the paramater
2 Step : Use the parameter
3 Step : Pass the Parameter's Value at Execution
*/
ALTER PROCEDURE GetCustomerSummary
@Country NVARCHAR(50)
AS
BEGIN
SELECT 
	@Country AS Country,
	COUNT(*) AS NbCustomers,
	AVG(Score) AS AverageScore
FROM 
	Sales.Customers
WHERE
	Country = @Country
END

EXEC GetCustomerSummary @Country='Germany'
EXEC GetCustomerSummary @Country='USA'

-------------------------------------
-------- MULTIPLE STATEMENTS --------
-------------------------------------
ALTER PROCEDURE GetCustomerSummary
@Country NVARCHAR(50)
AS
BEGIN
SELECT 
	@Country AS Country,
	COUNT(*) AS NbCustomers,
	AVG(Score) AS AverageScore
FROM 
	Sales.Customers
WHERE
	Country = @Country;
-- Find the total Nb of Orders and Total Sales
SELECT 
	COUNT(OrderID) AS NbOrders,
	SUM(Sales) AS TotalgeScore
FROM 
	Sales.Orders AS o
	JOIN Sales.Customers AS c
		ON c.CustomerID = o.CustomerID
WHERE
	c.Country = @Country;
END

-------------------------------------
-------------- VARIABLE -------------
-------------------------------------
-- Total Customers from Country : ?
-- Average Score from Country : ?
/*
1 Step : Declare Variables
2 Step : Assign Values to Variables
3 Step : USe Variables
*/

ALTER PROCEDURE GetCustomerSummaryVar
@Country NVARCHAR(50)='USA'
AS
BEGIN
DECLARE 
	@TotatCustomers INT ,
	@AvgScore FLOAT;

SELECT 
	@TotatCustomers = COUNT(*) ,
	@AvgScore = AVG(Score) 
FROM 
	Sales.Customers
WHERE
	Country = @Country;

PRINT 'Total Customers from '+@Country+': ' + CAST(@TotatCustomers AS NVARCHAR);
PRINT 'Average Score from '+@Country+': ' + CAST(@AvgScore AS NVARCHAR);
-- Find the total Nb of Orders and Total Sales
SELECT 
	COUNT(OrderID) AS NbOrders,
	SUM(Sales) AS TotalgeScore
FROM 
	Sales.Orders AS o
	JOIN Sales.Customers AS c
		ON c.CustomerID = o.CustomerID
WHERE
	c.Country = @Country;
END


EXEC GetCustomerSummaryVar @Country='Germany'


-------------------------------------
------------ CONTROL FLOW -----------
-------------------------------------
ALTER PROCEDURE GetCustomerSummaryVar
@Country NVARCHAR(50)='USA'
AS
BEGIN
DECLARE 
	@TotatCustomers INT ,
	@AvgScore FLOAT;
-- Prepare & Cleanup Data 
IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country=@Country)
BEGIN
	PRINT('Updating NULL Scores to 0');
	UPDATE Sales.Customers
	SET Score = 0
	WHERE
		Score IS NULL AND Country =@Country;
END

ELSE 
BEGIN
	PRINT('No NULL Scores found');
END;
-- Generating reports

SELECT 
	@TotatCustomers = COUNT(*) ,
	@AvgScore = AVG(Score) 
FROM 
	Sales.Customers
WHERE
	Country = @Country;

PRINT 'Total Customers from '+@Country+': ' + CAST(@TotatCustomers AS NVARCHAR);
PRINT 'Average Score from '+@Country+': ' + CAST(@AvgScore AS NVARCHAR);
-- Find the total Nb of Orders and Total Sales
SELECT 
	COUNT(OrderID) AS NbOrders,
	SUM(Sales) AS TotalgeScore
FROM 
	Sales.Orders AS o
	JOIN Sales.Customers AS c
		ON c.CustomerID = o.CustomerID
WHERE
	c.Country = @Country;
END

EXEC GetCustomerSummaryVar
EXEC GetCustomerSummaryVar @Country='Germany'

-------------------------------------
----------- ERROR HANDLING ----------
-------------------------------------

ALTER PROCEDURE GetCustomerSummaryVar
@Country NVARCHAR(50)='USA'
AS
BEGIN
	BEGIN TRY
		DECLARE 
			@TotatCustomers INT ,
			@AvgScore FLOAT;

		-- ****************************** --
		-- Step 1: Prepare & Cleanup Data --
		-- ****************************** --
		IF EXISTS (SELECT 1 FROM Sales.Customers WHERE Score IS NULL AND Country=@Country)
		BEGIN
			PRINT('Updating NULL Scores to 0');
			UPDATE Sales.Customers
			SET Score = 0
			WHERE
				Score IS NULL AND Country =@Country;
		END

		ELSE 
		BEGIN
			PRINT('No NULL Scores found');
		END;

		-- ********************************** --
		-- Step 2: Generating Summary Reports --
		-- ********************************** --
		-- Calaculate Total Customers and Average Score for specific Country
		SELECT 
			@TotatCustomers = COUNT(*) ,
			@AvgScore = AVG(Score) 
		FROM 
			Sales.Customers
		WHERE
			Country = @Country;

		PRINT 'Total Customers from '+@Country+': ' + CAST(@TotatCustomers AS NVARCHAR);
		PRINT 'Average Score from '+@Country+': ' + CAST(@AvgScore AS NVARCHAR);
		
		--Calculate total Nb of Orders and Total Sales for specific Country
		SELECT 
			COUNT(OrderID) AS NbOrders,
			SUM(Sales) AS TotalgeScore
		FROM 
			Sales.Orders AS o
			JOIN Sales.Customers AS c
				ON c.CustomerID = o.CustomerID
		WHERE
			c.Country = @Country;
	END TRY

	BEGIN CATCH
		-- ************** --
		-- Error Handling --
		-- ************** --
		PRINT ('An error occured.');
		PRINT ('Error Message: '+ ERROR_MESSAGE());
		PRINT ('Error Number: '+ CAST(ERROR_NUMBER()AS VARCHAR));
		PRINT ('Error Line: '+ CAST(ERROR_LINE()AS VARCHAR));
		PRINT ('Error Procedure: '+ ERROR_PROCEDURE());
	END CATCH
END
GO

EXEC GetCustomerSummaryVar