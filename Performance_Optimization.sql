 -------------------------------------------------------------------------------------
------------------------------------ SQL INDEXES ------------------------------------
-------------------------------------------------------------------------------------
/*
INDEX
Data structure provides quick access to data, 
optimizing the speed of your queries.
*/
--------------------------------------------
---------------STRUCTURE INDEX--------------
--------------------------------------------
/* HEAP STRUCTURE
HEAP = Table WITHOUT Clustered index 
	Fast write, Slow Read
FULL TABLE SCAN
	Scans the entire tables page by page and row by row, searching for data	
*/
--------- CLUSTERED INDEX ---------
/* 
B-TREE (Balance Tree)
	Hierarchical structure storing data at leaves, 
	to help quickly locate data.
INDEX PAGE 
	It stores key values (Pointers) to another page 
	It doesn't store the actual rows.
A primary key (PK) automatically creates a clustered index by default
Only ONE clustered index can be created per table
*/
SELECT *
INTO Sales.DBCustomers
FROM Sales.Customers

CREATE CLUSTERED INDEX idx_DBCustomers_CustomerID
ON Sales.DBCustomers (CustomerID)

DROP INDEX idx_DBCustomers_CustomerID ON Sales.DBCustomers 

CREATE CLUSTERED INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName)

DROP INDEX idx_DBCustomers_FirstName ON Sales.DBCustomers 

--------- NON-CLUSTERED INDEX ---------
/*
A non-clustered index won't reaorganize or change anything on the data page
*/
CREATE NONCLUSTERED INDEX idx_DBCustomers_LastName
ON Sales.DBCustomers (LastName)

SELECT *
FROM Sales.DBCustomers
WHERE LastName = 'Brown'

CREATE INDEX idx_DBCustomers_FirstName
ON Sales.DBCustomers (FirstName)

SELECT *
FROM Sales.DBCustomers
WHERE FirstName = 'Anna'

--------------------------------------------
---------------COMPOSITE INDEX--------------
--------------------------------------------
/*
RULE: The columns of index order must match the order in your query
Leftmost prefix rule: 
	Index works only if your query filters start from 
	the first column in the index and follox its order.
	A, B, C, D
	Index will be used
		A
		A, B
		A, B, C
	Index won't be used
		B
		A,C
		A, B, D
*/
SELECT *
FROM Sales.DBCustomers
WHERE Country = 'USA' AND Score > 500

CREATE INDEX idx_DBCustomers_CountryScore
ON Sales.DBCustomers (Country, Score)

--------------------------------------------
--------------- STORAGE INDEX --------------
--------------------------------------------
--------- ROWSTORE INDEX ---------
/*
Organizes and stores data row by row
Less efficient in storage
Fair speed for read & write operations
Retrieves all columns
OLTP Transactional: commerce, banking , financial systems, order processing
High-frequency transaction application
Quick access to compete records
*/

--------- COLUMNSTORE INDEX ---------
/*
Organizes and stores data by column 
Highky efficient with compression
Fast read performance
Slow write performance
Retrieves specific columns  
OLAP Analytical : Data warehouse, business intelligence, reporting, analytics
Big Data Analytics
Scanning of large datasets
Fast aggregation
*/

/*
Just one columns stored index
#1 Row Groups
#2 Column segment 
#3 Data compression
	Dictionary replace -> data stream
	Reduce size and increase performance
#4 Store LoB page 
*/
CREATE CLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS
ON Sales.DBCustomers

DROP INDEX [idx_DBCustomers_CustomerID]
ON Sales.DBCustomers

CREATE NONCLUSTERED COLUMNSTORE INDEX idx_DBCustomers_CS_FirstName
ON Sales.DBCustomers(FirstName)

--------------------------------------------
--------------- FUNCTION INDEX --------------
--------------------------------------------
--------- UNIQUE INDEX ---------
/*
Ensures no duplicate values exist in specific column 
Data integrety
Improve performance
Writing slow
Reading fast
Rule: Duplicates in the columns will prevent creating a unique index
*/
SELECT *
FROM Sales.Products

CREATE UNIQUE NONCLUSTERED INDEX idx_Products_Product
ON Sales.Products(Product)

--------- FILTRED INDEX ---------
/* An index that includes only rows meeting the specified conditions
Targeted Optimization
Reduce storage 
NOT ALLOWED ON CLUSTERED INDEX AND COLUMNSTORE INDEX
*/
SELECT * FROM Sales.Customers
WHERE Country = 'USA'

CREATE NONCLUSTERED INDEX idx_Customers_Country
ON Sales.Customers (Country)
WHERE Country = 'USA'


--------------------------------------------
------------- INDEX MANAGEMENT -------------
--------------------------------------------
-- LIST ALL INDEXES ON A SPECIFIC TABLE
sp_helpindex 'Sales.DBCustomers'

-- MONITORING INDEX USAGE
SELECT  
	tbl.name AS TableName, 
	idx.name AS IndexName,
	idx.type_desc AS IndexType, 
	idx.is_primary_key AS IsPrimaryKey,
	idx.is_unique AS IsUnique, 
	idx.is_disabled AS IsDisable,
	 s.user_seeks AS UserSeek,
	 s.user_scans AS UserScans,
	 s.user_lookups AS UserLookups,
	 s.last_user_update AS UserUpdates,
	 COALESCE(s.last_user_seek, s.last_user_scan) AS  LastUpdate
FROM 
	sys.indexes idx
	JOIN sys.tables tbl
		ON idx.object_id = tbl.object_id
	LEFT JOIN sys.dm_db_index_usage_stats s
		ON s.object_id = idx.object_id
		AND s.index_id = idx.index_id
ORDER BY tbl.name, idx.name

SELECT * FROM Sales.Products
WHERE Product = 'Caps'
SELECT * FROM sys.tables

SELECT * FROM sys.dm_db_index_usage_stats

-- MONITORING MISSING INDEXES
-- MONITORING DUPLICATE INDEXES
SELECT  
	tbl.name AS TableName, 
	col.name AS IndexColumn,
	idx.name AS IndexName,
	idx.type_desc AS IndexType,
	COUNT(*) OVER (PARTITION BY tbl.name, col.name) ColumnCount
FROM 
	sys.indexes idx
	JOIN sys.tables tbl
		ON idx.object_id = tbl.object_id
	JOIN sys.index_columns ic
		ON ic.object_id = idx.object_id
		AND ic.index_id = idx.index_id
	JOIN sys.columns col 
		ON ic.object_id = col.object_id
		AND ic.column_id = col.column_id
ORDER BY ColumnCount DESC

-- UPDATE STATISTICS
/*
Weekly job to update statistics on weekends
After Migrating Data
*/

SELECT 
	SCHEMA_NAME(t.schema_id) AS SchemaName, 
	t.name AS TableName,
	s.name AS StatisticName,
	sp.last_updated AS LastUpdate,
	DATEDIFF(day, sp.last_updated, GETDATE()) AS LastUpdateDay,
	sp.rows AS 'Rows',
	sp.modification_counter AS ModificationsSinceLastUpdate
FROM 
	sys.stats AS s
	JOIN sys.tables AS t
		ON s.object_id = t.object_id
	CROSS APPLY sys.dm_db_stats_properties(s.object_id, s.stats_id) AS sp
ORDER BY 
sp.modification_counter DESC;

UPDATE STATISTICS Sales.DBCustomers _WA_Sys_00000003_634EBE90

UPDATE STATISTICS Sales.DBCustomers

EXEC sp_updatestats

-- MONITORING FRAGMENTATION
/*
Unused spaces in data pages
Data pages are out of order
*/

SELECT 
	tbl.name AS TableName, 
	idx.name AS IndexName,
	s.avg_fragmentation_in_percent,
	s.page_count
FROM 
	sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS s
	INNER JOIN sys.tables tbl
		ON s.object_id = tbl.object_id
	INNER JOIN sys.indexes AS idx
		ON idx.object_id = s.object_id
		AND idx.index_id = s.index_id
ORDER BY s.avg_fragmentation_in_percent DESC

ALTER INDEX idx_Customers_Country ON Sales.Customers REORGANIZE
ALTER INDEX idx_Customers_Country ON Sales.Customers REBUILD