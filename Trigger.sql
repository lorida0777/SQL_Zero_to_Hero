/*
TRIGGERS
Special stored procedure that automatically runs in response to 
a specific envent on a table ar view
*/

--- LOGGING
/* 
1 Step: Create Log Table
2 Step: Create Trigger on Employees Table 
3 Step: Insert New Data Into Employees
*/
CREATE TABLE Sales.EmployeeLogs(
	LogID INT IDENTITY(1,1) PRIMARY KEY,
	EmployeeID INT,
	LogMessage VARCHAR (255),
	LogDate DATE
)


SELECT * FROM Sales.EmployeeLogs

INSERT INTO Sales.Employees
VALUES
(6, 'Maria', 'Doe', 'HR', '1988-01-12', 'F', 80000,3)