--1.	Total Sales by Salesperson 
SELECT Salesperson.Salesperson, SUM(Sales.Sales) AS TotalSales
FROM Sales
JOIN Salesperson ON Sales.EmployeeKey = Salesperson.EmployeeKey
GROUP BY Salesperson.Salesperson

--2.	Sales Performance by Region 
SELECT Region.Region, SUM(Sales.Sales) AS TotalSales
FROM Sales
JOIN Region ON Sales.SalesTerritoryKey = Region.SalesTerritoryKey
GROUP BY Region.Region

--3.	Sales Trend Over Time 
SELECT FORMAT(OrderDate, 'yyyy-MM') AS Month, SUM(Sales) AS TotalSales
FROM Sales
GROUP BY FORMAT(OrderDate, 'yyyy-MM')
ORDER BY FORMAT(OrderDate, 'yyyy-MM')

--4.	Average Sales per Reseller 
SELECT Reseller.Reseller, AVG(Sales.Sales) AS AvgSales
FROM Sales
JOIN Reseller ON Sales.ResellerKey = Reseller.ResellerKey
GROUP BY Reseller.Reseller

--5.	Sales per Product Category 
SELECT Product.Category, SUM(Sales.Sales) AS TotalSales
FROM Sales
JOIN Product ON Sales.ProductKey = Product.ProductKey
GROUP BY Product.Category

--6.	Top 10 Products by Sales
SELECT TOP 10 Product.Product, SUM(Sales.Sales) AS TotalSales
FROM Sales
JOIN Product ON Sales.ProductKey = Product.ProductKey
GROUP BY Product.Product
ORDER BY TotalSales DESC


--7.	Sales by Country 
SELECT Region.Country, SUM(Sales.Sales) AS TotalSales
FROM Sales
JOIN Region ON Sales.SalesTerritoryKey = Region.SalesTerritoryKey
GROUP BY Region.Country

--8.Sales vs Target Performance:--

SELECT Salesperson.Salesperson, SUM(Sales.Sales) AS TotalSales, SUM(Targets.Target) AS TargetAmount
FROM Sales
JOIN Salesperson ON Sales.EmployeeKey = Salesperson.EmployeeKey
JOIN Targets ON Salesperson.EmployeeID = Targets.EmployeeID
GROUP BY Salesperson.Salesperson


--9.Salesperson with Highest Sales Growth:

SELECT Salesperson.Salesperson, (SUM(Sales.Sales) - SUM(PreviousSales.Sales)) AS SalesGrowth
FROM Sales
JOIN Salesperson ON Sales.EmployeeKey = Salesperson.EmployeeKey
JOIN Sales AS PreviousSales ON Sales.EmployeeKey = PreviousSales.EmployeeKey
AND DATEPART(YEAR, Sales.OrderDate) = DATEPART(YEAR, PreviousSales.OrderDate) + 1
GROUP BY Salesperson.Salesperson
ORDER BY SalesGrowth DESC


--10.Sales by Business Type:


SELECT Reseller.BusinessType, SUM(Sales.Sales) AS TotalSales
FROM Sales
JOIN Reseller ON Sales.ResellerKey = Reseller.ResellerKey
GROUP BY Reseller.BusinessType


-- 11.Reseller Performance by Country

SELECT Reseller.CountryRegion, SUM(Sales.Sales) AS TotalSales
FROM Sales
JOIN Reseller ON Sales.ResellerKey = Reseller.ResellerKey
GROUP BY Reseller.CountryRegion

--12.Top Resellers by Sales � Identify resellers contributing the most to sales:

SELECT Reseller.Reseller, SUM(Sales.Sales) AS TotalSales
FROM Sales
JOIN Reseller ON Sales.ResellerKey = Reseller.ResellerKey
GROUP BY Reseller.Reseller
ORDER BY TotalSales DESC


--13.Salesperson Contribution to Company Sales 

SELECT 
    Salesperson.Salesperson, 
    SUM(Sales.Sales) AS TotalSales, 
    (SUM(Sales.Sales) / (SELECT SUM(Sales) FROM Sales)) * 100 AS ContributionPercentage
FROM 
    Sales
JOIN 
    Salesperson ON Sales.EmployeeKey = Salesperson.EmployeeKey
GROUP BY 
    Salesperson.Salesperson
ORDER BY 
    ContributionPercentage DESC
--14.Target Achievement by Salesperson 

SELECT 
    Salesperson.Salesperson, 
    FORMAT(Sales.OrderDate, 'yyyy-MM') AS SalesMonth,
    Targets.TargetMonth, 
    Targets.Target, 
    SUM(Sales.Sales) AS ActualSales, 
    (SUM(Sales.Sales) / Targets.Target) * 100 AS AchievementPercentage
FROM 
    Sales
JOIN 
    Salesperson ON Sales.EmployeeKey = Salesperson.EmployeeKey
JOIN 
    Targets ON Salesperson.EmployeeID = Targets.EmployeeID 
            AND FORMAT(Sales.OrderDate, 'yyyy-MM') = FORMAT(Targets.TargetMonth, 'yyyy-MM')
GROUP BY 
    Salesperson.Salesperson, FORMAT(Sales.OrderDate, 'yyyy-MM'), Targets.TargetMonth, Targets.Target
ORDER BY 
    Salesperson.Salesperson, SalesMonth;


--15.Reseller Sales by Product � Understand which resellers prefer which products:


SELECT Reseller.Reseller, Product.Product, SUM(Sales.Sales) AS TotalSales
FROM Sales
JOIN Reseller ON Sales.ResellerKey = Reseller.ResellerKey
JOIN Product ON Sales.ProductKey = Product.ProductKey
GROUP BY Reseller.Reseller, Product.Product


--16.Reseller Contribution to Salesperson Performance 


SELECT Salesperson.Salesperson, Reseller.Reseller, SUM(Sales.Sales) AS TotalSales
FROM Sales
JOIN Salesperson ON Sales.EmployeeKey = Salesperson.EmployeeKey
JOIN Reseller ON Sales.ResellerKey = Reseller.ResellerKey
GROUP BY Salesperson.Salesperson, Reseller.Reseller


--17.Sales Orders by Reseller Location 


SELECT Reseller.City, Reseller.StateProvince, Reseller.CountryRegion, COUNT(Sales.SalesOrderNumber) AS TotalOrders
FROM Sales
JOIN Reseller ON Sales.ResellerKey = Reseller.ResellerKey
GROUP BY Reseller.City, Reseller.StateProvince, Reseller.CountryRegion

--18.Profit Margin per Product 

SELECT
    Product.Product, product.ProductKey,
    ( Product.StandardCost - Sales.UnitPrice) AS ProfitMargin
FROM 
    Sales
JOIN 
    Product ON Sales.ProductKey = Product.ProductKey



--19.Top 5 Products by Profit Margin

SELECT 
    TOP 5 Product.Product, 
    (Sales.Sales - Sales.Cost) AS ProfitMargin
FROM 
    Sales
JOIN 
    Product ON Sales.ProductKey = Product.ProductKey
ORDER BY 
    ProfitMargin DESC


--20.Cost vs Sales Analysis by Product � Compare cost vs total sales per product:


SELECT 
    Product.Product, 
    SUM(Sales.Sales) AS TotalSales, 
    SUM(Sales.Cost) AS TotalCost
FROM 
    Sales
JOIN 
    Product ON Sales.ProductKey = Product.ProductKey
GROUP BY 
    Product.Product


--21.Sales by Product Subcategory � Analyze sales performance at the subcategory level:


SELECT 
    Product.Subcategory, 
    SUM(Sales.Sales) AS TotalSales
FROM 
    Sales
JOIN 
    Product ON Sales.ProductKey = Product.ProductKey
GROUP BY 
    Product.Subcategory


--22.Product Sales by Region � Compare product performance across regions:

SELECT 
    Product.Product, 
    Region.Region, 
    SUM(Sales.Sales) AS TotalSales
FROM 
    Sales
JOIN 
    Product ON Sales.ProductKey = Product.ProductKey
JOIN 
    Region ON Sales.SalesTerritoryKey = Region.SalesTerritoryKey
GROUP BY 
    Product.Product, 
    Region.Region

--23.Unsold Products 

SELECT 
    Product.Product
FROM 
    Product
LEFT JOIN 
    Sales ON Product.ProductKey = Sales.ProductKey
WHERE 
    Sales.Sales IS NULL


--24.Salesperson Sales per Region 


SELECT 
    Salesperson.Salesperson, 
    Region.Region, 
    SUM(Sales.Sales) AS TotalSales
FROM 
    Sales
JOIN 
    Salesperson ON Sales.EmployeeKey = Salesperson.EmployeeKey
JOIN 
    Region ON Sales.SalesTerritoryKey = Region.SalesTerritoryKey
GROUP BY 
    Salesperson.Salesperson, Region.Region
ORDER BY 
    Salesperson.Salesperson, Region.Region;

--25.Top Performing Salespeople 

SELECT 
    top 20 Salesperson.Salesperson, 
    SUM(Sales.Sales) AS TotalSales
FROM 
    Sales
JOIN 
    Salesperson ON Sales.EmployeeKey = Salesperson.EmployeeKey
GROUP BY 
    Salesperson.Salesperson
ORDER BY 
    TotalSales DESC
