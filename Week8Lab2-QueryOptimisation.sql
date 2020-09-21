

USE AdventureWorks2016

/* Approach 1 */
SELECT MIN(OrderQty) ​

FROM Sales.SalesOrderDetail ​

WHERE OrderQty IN​

	(SELECT   TOP 2 OrderQty ​

	FROM Sales.SalesOrderDetail ​

	ORDER BY OrderQty Desc​

	)​

/* Approach 2 */

SELECT MIN(OrderQty) FROM (SELECT   TOP 2 OrderQty ​

	FROM Sales.SalesOrderDetail ​

	ORDER BY OrderQty Desc​) AS Sales

/* Approach 3 */

SELECT OrderQty ​
FROM Sales.SalesOrderDetail ​
ORDER BY OrderQty Desc
OFFSET 1 ROW 
FETCH NEXT 1 ROW ONLY


