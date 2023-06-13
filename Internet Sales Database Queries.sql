SELECT 
	
	CustomerKey AS CustomerID, SUM(SalesAmount) AS SalesAmount

FROM FactInternetSales
WHERE year(OrderDate) > 2010

GROUP BY CustomerKey
HAVING SUM(SalesAmount) > 10000

ORDER BY SalesAmount DESC

/*
The query above is retrieving data from the "FactInternetSales" table. 
It calculates the total sales amount for each customer and assigns it to the alias "SalesAmount". 
The "CustomerKey" column is also selected and renamed as "CustomerID" using the alias.
The data is then filtered by the condition "year(OrderDate) > 2010", which retrieves only the rows where the year of the order date is greater than 2010.
Next, the data is grouped by the "CustomerKey" column. This means that the calculations are performed for each unique customer, and the sales amounts are aggregated for each customer.
The "HAVING" clause is applied to the grouped data, filtering out the groups where the sum of sales amounts is not greater than 10000.
Finally, the result set is ordered in descending order based on the "SalesAmount" column.
*/


SELECT

	SalesOrderNumber AS InvoiceNumber, 
	OrderDate, 
	SUM(SalesAmount) AS InvoiceSubTotal, 
	SUM(TaxAmt) AS TaxAmount, 
	SUM(OrderQuantity) AS TotalQuantity, 
	SUM(SalesAmount) + SUM(TaxAmt) AS InvoiceTotal

FROM FactInternetSales

GROUP BY SalesOrderNumber, OrderDate
HAVING SUM(SalesAmount) > 10000

ORDER BY InvoiceSubTotal DESC

OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY

/*
The query above is retrieving data from the "FactInternetSales" table. It selects specific columns from the table and performs aggregations on them.
The selected columns are as follows: "SalesOrderNumber" is selected and renamed as "InvoiceNumber". "OrderDate" remains the same.
The sum of the "SalesAmount" column is calculated and renamed as "InvoiceSubTotal". The sum of the "TaxAmt" column is calculated and renamed as "TaxAmount".
The sum of the "OrderQuantity" column is calculated and renamed as "TotalQuantity". The sum of "SalesAmount" and "TaxAmt" columns is calculated and renamed as "InvoiceTotal".
The data is then grouped by the "SalesOrderNumber" and "OrderDate" columns. This means that the calculations are performed for each unique combination of these two columns.
The "HAVING" clause is applied to the grouped data, filtering out the groups where the sum of sales amounts is not greater than 10000.
Next, the result set is ordered in descending order based on the "InvoiceSubTotal" column.
The "OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY" clause is used for pagination purposes. It retrieves only the first 10 rows from the ordered result set, starting from the offset of 0 rows. 
This allows for retrieving data in chunks or pages, where each page contains a limited number of rows (in this case, 10 rows).
*/


SELECT TOP(10) PERCENT

	SalesOrderNumber AS InvoiceNumber, 
	OrderDate, 

	SUM(SalesAmount) AS InvoiceSubTotal, 
	ROUND(SUM(SalesAmount), 1) AS InvoiceSubTotalRounded,

	SUM(TaxAmt) AS TaxAmount, 
	FLOOR(SUM(TaxAmt)) AS TaxAmountFloor, 

	SUM(OrderQuantity) AS TotalQuantity, 
	SUM(SalesAmount) + SUM(TaxAmt) AS InvoiceTotal

FROM FactInternetSales

GROUP BY SalesOrderNumber, OrderDate
HAVING SUM(SalesAmount) > 10000

ORDER BY InvoiceSubTotal DESC

/*
The query above is retrieving data from the "FactInternetSales" table. It performs calculations and transformations on the selected columns.
The selected columns are: "SalesOrderNumber" is selected and renamed as "InvoiceNumber". "OrderDate" remains the same.
The sum of the "SalesAmount" column is calculated and renamed as "InvoiceSubTotal". The "InvoiceSubTotal" column is rounded to one decimal place using the ROUND function, and the result is renamed as "InvoiceSubTotalRounded".
The sum of the "TaxAmt" column is calculated and renamed as "TaxAmount". The "TaxAmount" column is converted to the nearest lower integer value using the FLOOR function, and the result is renamed as "TaxAmountFloor".
The sum of the "OrderQuantity" column is calculated and renamed as "TotalQuantity". The sum of "SalesAmount" and "TaxAmt" columns is calculated and renamed as "InvoiceTotal".
Next, the data is grouped by the "SalesOrderNumber" and "OrderDate" columns. This means that the calculations are performed for each unique combination of these two columns.
The "HAVING" clause is applied to the grouped data, filtering out the groups where the sum of sales amounts is not greater than 10000. 
Finally, the result set is ordered in descending order based on the "InvoiceSubTotal" column.
*/


SELECT

    FirstName,
    IIF(MiddleName IS NULL, 'UNKN', MiddleName) AS MiddleName,
    ISNULL(MiddleName, 'UNKN') AS MiddleName2,
    COALESCE(MiddleName, 'UNKN') AS MiddleName3,
    LastName,
    YearlyIncome,
    EmailAddress,

    IIF(YearlyIncome > 50000, 'Above Average', 'Below Average') AS IncomeCategory,

    CASE
        WHEN NumberChildrenAtHome = 0 THEN '0'
        WHEN NumberChildrenAtHome = 1 THEN '1'
        WHEN NumberChildrenAtHome BETWEEN 2 AND 4 THEN '2 - 4'
        WHEN NumberChildrenAtHome >= 5 THEN '5+'
        ELSE 'UNKN'
    END AS NumberChildrenCategory, NumberChildrenAtHome AS ActualChildren

FROM DimCustomer
WHERE IIF(YearlyIncome > 50000, 'Above Average', 'Below Average') = 'Above Average'

/*
The query above is retrieving data from the "DimCustomer" table and performs transformations on selected columns.
The "YearlyIncome" column is checked using the IIF function. If it is greater than 50000, the value 'Above Average' is returned; otherwise, 'Below Average' is returned. The result is renamed as "IncomeCategory".
The "NumberChildrenAtHome" column is checked using the CASE statement. Different conditions are evaluated, and based on the value of "NumberChildrenAtHome," corresponding category labels are assigned. T
he result is renamed as "NumberChildrenCategory". The actual value of "NumberChildrenAtHome" is also selected and renamed as "ActualChildren".
The data is filtered by the condition that the "IncomeCategory" column should be 'Above Average'. This means that only customers with yearly income above 50000 will be included in the result set.
*/


SELECT 

	CONCAT(FirstName, ' ', LastName) AS CustomerName,

	CASE
		WHEN NumberCarsOwned BETWEEN 2 AND 3 THEN '2-3'
		WHEN NumberCarsOwned >= 4 THEN '4+'
	END AS NumberOfCarsOwned,
	EmailAddress AS Email

FROM DimCustomer
WHERE NumberCarsOwned > 1 AND HouseOwnerFlag = 1

/*
This query retrieves data from the "DimCustomer" table and performs transformations on selected columns.
The "FirstName" and "LastName" columns are concatenated using the CONCAT function, with a space in between. The result is renamed as "CustomerName".
The "NumberCarsOwned" column is checked using the CASE statement. If the value of "NumberCarsOwned" is between 2 and 3 (inclusive), the label '2-3' is assigned. 
If the value is 4 or greater, the label '4+' is assigned. If none of these conditions are met, no value is returned for the "NumberOfCarsOwned" column.
The data is filtered by the conditions that "NumberCarsOwned" should be greater than 1 and "HouseOwnerFlag" should be 1. 
This means that only customers who own more than one car and have a house (based on the value of "HouseOwnerFlag") will be included in the result set.
*/


SELECT TOP(100)

CONCAT(dc.FirstName, ' ', dc.LastName) AS CustomerName,
dc.EmailAddress AS EmailAddress,
SUM(fs.SalesAmount) AS AmountSpent,
dcy.CurrencyName AS Currency

FROM FactInternetSales AS fs
    INNER JOIN DimCustomer AS dc
    ON fs.CustomerKey = dc.CustomerKey
    INNER JOIN DimCurrency AS dcy
    ON fs.CurrencyKey = dcy.CurrencyKey

GROUP BY dc.FirstName, dc.LastName, dc.EmailAddress, dcy.CurrencyName
HAVING dcy.CurrencyName = N'US Dollar'

ORDER BY AmountSpent DESC

/*
This query retrieves data from the "FactInternetSales," "DimCustomer," and "DimCurrency" tables. 
It performs aggregations and joins to calculate the amount spent by customers in US dollars and retrieves the top 100 records based on the highest amount spent.
The data is obtained through the following joins:
The "FactInternetSales" table is joined with the "DimCustomer" table using the "CustomerKey" column from both tables.
The "FactInternetSales" table is also joined with the "DimCurrency" table using the "CurrencyKey" column from both tables.
The data is then grouped by the "FirstName," "LastName," "EmailAddress," and "CurrencyName" columns. This means that the aggregations are performed for each unique combination of these columns.
The "HAVING" clause is applied to the grouped data, filtering out the groups where the "CurrencyName" is not equal to 'US Dollar'. 
This means that only the groups with the currency name 'US Dollar' will be included in the result set.
Finally, the result set is ordered in descending order based on the "AmountSpent" column. This means that the rows will be sorted from the highest to the lowest "AmountSpent" value. 
The "TOP(100)" clause is used to limit the result to the top 100 records based on the highest amount spent.
*/


SELECT 

dp.EnglishProductName AS ProductName,
dp.Color AS ProductColor,
ISNULL(dp.Size, 'UNKN') AS ProductSize,
ISNULL(SUM(fs.SalesAmount), 0) AS SalesAmount

FROM FactInternetSales AS fs 
    RIGHT JOIN DimProduct AS dp 
    ON fs.ProductKey = dp.ProductKey

WHERE dp.[Status] = N'Current'

GROUP BY dp.EnglishProductName, dp.Color, dp.Size

ORDER BY SalesAmount DESC

/*
This query retrieves data from the "FactInternetSales" and "DimProduct" tables. It performs a right join to combine the data from these tables based on the "ProductKey" column. 
The result set includes information about the product name, color, size, and sales amount.
The data is filtered by the condition that the "Status" column from the "DimProduct" table should be 'Current'. This means that only products with a status of 'Current' will be included in the result set.
The data is then grouped by the "EnglishProductName," "Color," and "Size" columns. This means that the calculations and aggregations are performed for each unique combination of these columns.
Finally, the result set is ordered in descending order based on the "SalesAmount" column. This means that the rows will be sorted from the highest to the lowest "SalesAmount" value.
*/


SELECT

DA.AccountDescription AS AccountDescription,
SUM(FF.Amount) AS Amount,
SUM(FF.Amount) / (SELECT

                    SUM(FF.Amount) AS Amount

                    FROM FactFinance AS FF
                        INNER JOIN DimAccount AS DA
                        ON FF.AccountKey = DA.AccountKey
                        INNER JOIN DimScenario AS S
                        ON FF.ScenarioKey = S.ScenarioKey
                        INNER JOIN DimDate AS DD
                        ON FF.DateKey = DD.DateKey
                        INNER JOIN DimOrganization AS DO
                        ON FF.OrganizationKey = DO.OrganizationKey

                    WHERE S.ScenarioName = N'Actual'
                        AND DA.AccountType = N'Expenditures'
                        AND DD.CalendarYear = 2013
                        AND DO.OrganizationName = N'Canadian Division') AS PctOfTotal

FROM FactFinance AS FF
    INNER JOIN DimAccount AS DA
    ON FF.AccountKey = DA.AccountKey
    INNER JOIN DimScenario AS S
    ON FF.ScenarioKey = S.ScenarioKey
    INNER JOIN DimDate AS DD
    ON FF.DateKey = DD.DateKey
    INNER JOIN DimOrganization AS DO
    ON FF.OrganizationKey = DO.OrganizationKey

WHERE S.ScenarioName = N'Actual'
    AND DA.AccountType = N'Expenditures'
    AND DD.CalendarYear = 2013
    AND DO.OrganizationName = N'Canadian Division'

GROUP BY AccountDescription

ORDER BY SUM(FF.Amount) DESC

/*
This query retrieves data from the "FactFinance," "DimAccount," "DimScenario," "DimDate," and "DimOrganization" tables. 
It calculates the amount and percentage of total expenditures for each account in the "Canadian Division" organization in the year 2013.
The subquery retrieves the sum of the "Amount" column from the "FactFinance" table.
Joins the relevant dimension tables to filter the data.
Filters the data based on the scenario name "Actual," account type "Expenditures," calendar year 2013, and the organization name "Canadian Division."
The data is filtered by the following conditions in the main query:
The scenario name must be "Actual."
The account type must be "Expenditures."
The calendar year must be 2013.
The organization name must be "Canadian Division."
The data is then grouped by the "AccountDescription" column, so the calculations are performed for each unique account description.
Finally, the result set is ordered in descending order based on the sum of the "Amount" column. This means that the accounts will be sorted from the highest to the lowest expenditure amount.

*/