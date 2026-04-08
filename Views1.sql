/* Provide a view that combines details from 
orders, products, customers, and employees */
IF OBJECT_ID('Sales.V_Order_Details','V') IS NOT NULL
	DROP VIEW Sales.V_Order_Details;
GO
CREATE VIEW Sales.V_Order_Details AS (
SELECT
	O.OrderID AS OrderID,
	O.OrderDate,
	P.Product,
	P.Category,
	COALESCE(C.FirstName, '') + ' '+ COALESCE(C.LastName,'') AS CustomerName,
	C.Country AS CustomerCountry,
	COALESCE(E.FirstName, '') + ' '+ COALESCE(E.LastName,'') AS SalesName,
	E.Department,
	O.Sales,
	O.Quantity
FROM
	Sales.Orders AS O
	LEFT JOIN Sales.Products AS P
		ON O.ProductID = P.ProductID
	LEFT JOIN Sales.Customers AS C
		ON C.CustomerID = O.CustomerID
	LEFT JOIN Sales.Employees AS E
		ON E.EmployeeID = O.SalesPersonID
)
