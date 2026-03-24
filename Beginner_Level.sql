
USE MyDatabase

INSERT INTO persons (id, person_name, birth_date, phone)

SELECT
	id, 
	first_name,
	NULL, 
	'Unknown'
FROM customers

SELECT * FROM persons

SELECT * FROM customers WHERE id >5

UPDATE customers
SET score = 0
WHERE id = 6

DELETE FROM customers
WHERE id >5

--- Delete all data from table persons
---DELETE FROM persons
TRUNCATE TABLE persons 

SELECT * FROM customers

INSERT INTO customers (id, first_name, country, score)
VALUES 
	(6, 'Anna', 'USA', NULL),
	(7, 'Sam', NULL, 100)


INSERT INTO customers 
VALUES 
	(8, 'Andreas', 'Germany', NULL)


INSERT INTO customers (id, first_name)
VALUES	
	(9, 'Sahra')

INSERT INTO persons (id , person_name, birth_date, phone)	
SELECT 
	id,
	first_name,
	NULL, 
	'Unknown'
FROM customers

SELECT * FROM persons

UPDATE customers
	SET score = 0
	WHERE id = 6 

SELECT * 
FROM customers
WHERE score IS NULL

UPDATE customers
	SET 
		score = 0,
		country = 'UK'
	WHERE id = 9 


UPDATE customers
	SET score = 0
	WHERE score IS NULL 