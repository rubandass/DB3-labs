/*
Using Transact-SQL : Exercises
------------------------------------------------------------

Exercises for section 15 : UDF

Create a UDF on your database that references the AdventureWorks2016 database. Note you will have to reference AdventureWorks2016 using the FQDN as you only have select over it
AdventureWorks2016 is a large and complex Microsoft training database.
The function takes one input parameter, a customer (store) ID, and returns the columns ProductID, Name, and the aggregate of year-to-date sales as YTD Total for each product sold to the store.

You will need to use the following tables:

Production.Product
Sales.SalesOrderDetail
Sales.SalesOrderHeader
Sales.Customer

	CREATE OR ALTER FUNCTION getSales(@storeID int)
	RETURNS TABLE
	AS
	RETURN
			SELECT s.ProductID, p.Name, s.YTD FROM AdventureWorks2016.Production.Product AS p
			JOIN (
					SELECT sod.ProductID, SUM(sod.OrderQty) AS YTD FROM AdventureWorks2016.Sales.Customer c
					JOIN AdventureWorks2016.Sales.SalesOrderHeader AS so ON c.CustomerID = so.CustomerID
					JOIN AdventureWorks2016.Sales.SalesOrderDetail AS sod ON so.SalesOrderID = sod.SalesOrderID
					WHERE c.StoreID = @storeID
					GROUP BY sod.ProductID
				) AS s ON p.ProductID = s.ProductID

	GO
	SELECT * FROM getSales(934)


	***************	For my reference	*************************
	Manually Checking the query output

		SELECT * FROM AdventureWorks2016.Sales.Customer
		WHERE storeID = 934
		Outputs:
		customerID = 1,29773

		SELECT * FROM AdventureWorks2016.Sales.SalesOrderHeader
		where CustomerID IN (1,29773)
		Outputs:
		SalesOrderID = 43860, 44501, 45283, 46042

		SELECT SUM(OrderQty) FROM AdventureWorks2016.Sales.SalesOrderDetail
		where SalesOrderID IN (43860, 44501, 45283, 46042)
	*******************************************************