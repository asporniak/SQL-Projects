SELECT TOP(10) PERCENT

SalesOrderNumber AS InvoiceNumber, 
OrderDate, 
SUM(SalesAmount) AS InvoiceSubTotal, 
SUM(TaxAmt) AS TaxAmount, 
SUM(OrderQuantity) AS TotalQuantity, 
SUM(SalesAmount) + SUM(TaxAmt) AS InvoiceTotal

FROM FactInternetSales
WHERE SalesTerritoryKey = 6

GROUP BY SalesOrderNumber, OrderDate
HAVING SUM(SalesAmount) > 1000

ORDER BY InvoiceSubTotal DESC

--This query is retrieving data from the "FactInternetSales" table. 
--It selects the top 10 percent of rows based on the highest values of the calculated column "InvoiceSubTotal," which represents the sum of the sales amount for each sales order.

--The selected columns are renamed using aliases: "SalesOrderNumber" is renamed as "InvoiceNumber," "OrderDate" remains the same, "SUM(SalesAmount)" is renamed as "InvoiceSubTotal, 
--"SUM(TaxAmt)" is renamed as "TaxAmount," "SUM(OrderQuantity)" is renamed as "TotalQuantity," and the sum of sales amount and tax amount is calculated and renamed as "InvoiceTotal."

--The data is filtered by the condition "SalesTerritoryKey = 6," which retrieves only the rows where the sales territory key is 6.
--Next, the data is grouped by the "SalesOrderNumber" and "OrderDate" columns, which means that the calculations are performed for each unique combination of these two columns.
--The "HAVING" clause is applied to the grouped data, filtering out the groups where the sum of sales amounts is not greater than 1000.
--Finally, the result set is ordered in descending order based on the "InvoiceSubTotal" column.