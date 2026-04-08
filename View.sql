IF OBJECT_ID ('Sales.V_MonthlySummary','V') IS NOT NULL
	DROP VIEW Sales.V_MonthlySummary;
GO
CREATE VIEW Sales.V_MonthlySummary AS 
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

