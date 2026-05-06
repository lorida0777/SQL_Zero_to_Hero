CREATE TRIGGER trg_AfterInsertEmployee ON Sales.Employees
AFTER INSERT
AS
BEGIN
	INSERT INTO Sales.EmployeeLogs (EmployeeID, LogMessage, LogDate)
	SELECT
		EmployeeID, 
		'New Employee Addes = ' + CAST(EmployeeID AS VARCHAR),
		GETDATE()
	FROM inserted
END