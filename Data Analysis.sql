
-- SALES PERFORMANCE & REVENUE
-- 1. Total Sales Revenue and Volume by POS Location`
SELECT 
    POS_Location,
    SUM(Total_Sales) AS 'Total Sales Revenue',
    SUM(Net_Quantity) AS 'Total Volume'
FROM Sales
WHERE Sale_Type = 'order'
GROUP BY POS_Location
ORDER BY [Total Sales Revenue] DESC;

-- 2a. Best-Selling Categories by POS Location
WITH RankedSales AS (
SELECT
	POS_Location,
	Product_Category,
	SUM(Net_Quantity) AS 'Units Sold',
    SUM(Total_Sales) AS 'Total Sales Revenue',
    ROW_NUMBER() OVER (PARTITION BY POS_Location
                        ORDER BY SUM(Net_Quantity) DESC) AS rn
FROM Sales
WHERE Sale_Type = 'order'
GROUP BY POS_Location, Product_Category
)

SELECT
    POS_Location,
    Product_Category,
    [Units Sold],
    [Total Sales Revenue]
FROM RankedSales
WHERE rn <=5
ORDER BY POS_Location, [Units Sold] DESC;

-- 2b.Best-Selling Subcategories by POS Location
WITH RankedSales AS (
SELECT
	POS_Location,
	Product_Category,
	Product_Subcategory,
	SUM(Net_Quantity) AS 'Units Sold',
    SUM(Total_Sales) AS 'Total Sales Revenue',
    ROW_NUMBER() OVER (PARTITION BY POS_Location
                        ORDER BY SUM(Net_Quantity) DESC) AS rn
FROM Sales
WHERE Sale_Type = 'order'
GROUP BY POS_Location, Product_Category, Product_Subcategory
)

SELECT
    POS_Location,
    Product_Category,
    Product_Subcategory,
    [Units Sold],
    [Total Revenue]
FROM RankedSales
WHERE rn <=5
ORDER BY POS_Location, [Units Sold] DESC;

-- 3. Best-Selling Product Name by POS Location
WITH RankedSales AS (
SELECT
	POS_Location,
	Product_Name,
	SUM(Net_Quantity) AS 'Units Sold',
    SUM(Total_Sales) AS 'Total Sales Revenue',
    ROW_NUMBER() OVER (PARTITION BY POS_Location
                        ORDER BY SUM(Net_Quantity) DESC) AS rn
FROM Sales
WHERE Sale_Type = 'order'
GROUP BY POS_Location, Product_Name
)

SELECT
    POS_Location,
    Product_Name,
    [Units Sold],
	[Total Sales Revenue]
FROM RankedSales
WHERE rn <=5
ORDER BY POS_Location, [Units Sold] DESC;


WITH RankedSales AS (
SELECT
	POS_Location,
    MONTH([Date]) AS 'Month Number',
    DATENAME(MONTH,[Date]) AS 'Sales Month',
	Product_Name,
	SUM(Net_Quantity) AS 'Units Sold',
    SUM(Total_Sales) AS 'Total Sales Revenue',
    ROW_NUMBER() OVER (PARTITION BY POS_Location, DATENAME(MONTH,[Date])
                        ORDER BY SUM(Net_Quantity) DESC) AS rn
FROM Sales
WHERE Sale_Type = 'order'
GROUP BY POS_Location, DATENAME(MONTH,[Date]), MONTH([Date]), Product_Name
)

SELECT
    POS_Location,
    [Sales Month],
    Product_Name,
    [Units Sold],
	[Total Sales Revenue]
FROM RankedSales
WHERE rn <=5
ORDER BY POS_Location, [Month Number], [Units Sold] DESC;


SELECT 
    POS_Location,
    Vendor,
    COUNT(DISTINCT Product_Name) AS 'Number of Products',
    SUM(Net_Quantity) AS 'Quantity Sold',
    1.0 * SUM(Net_Quantity)/COUNT(DISTINCT Product_Name) AS 'Quantity to Product Ratio'
FROM Sales
WHERE Sale_Type = 'order'
GROUP BY POS_Location, Vendor
ORDER BY POS_Location, [Quantity to Product Ratio] DESC

-- 4. Best-Selling Vendors by POS Location
WITH RankedSales AS (
SELECT
	POS_Location,
	Vendor,
	SUM(Net_Quantity) AS 'Units Sold',
	SUM(Total_Sales) AS 'Total Sales Revenue',
    ROW_NUMBER() OVER (PARTITION BY POS_Location
                        ORDER BY SUM(Net_Quantity) DESC) AS rn
FROM Sales
WHERE Sale_Type = 'order'
GROUP BY POS_Location, Vendor
)

SELECT
    POS_Location,
    Vendor,
    [Units Sold],
	[Total Sales Revenue]
FROM RankedSales
WHERE rn <=5
ORDER BY POS_Location, [Units Sold] DESC;

-- TIME-BASED STORE TRENDS
-- 1. Monthly Sales Trend by POS Location
SELECT
    POS_Location,
    DATENAME(MONTH,[Date]) AS 'Month',
    SUM(Total_Sales) AS 'Total Sales Revenue'
FROM Sales
WHERE Sale_Type = 'order'
GROUP BY POS_Location,  DATENAME(MONTH,[Date]), MONTH([Date])
ORDER BY POS_Location, MONTH([Date])

-- 2. Weekly Sales Trend  by POS Location
SELECT
    POS_Location,
    DATENAME(WEEK,[Date]) AS 'Week',
    COUNT(DISTINCT [Date]) AS "Days in the Week",
    SUM(Total_Sales) AS 'Total Sales Revenue'
FROM Sales
WHERE Sale_Type = 'order'
GROUP BY POS_Location, DATENAME(WEEK,[Date]), DATEPART(WEEK,[Date])
ORDER BY POS_Location, DATEPART(WEEK,[Date])

-- 3. Day of Week Sales Trend by POS Location 
SELECT
    POS_Location,
    DATENAME(WEEKDAY,[Date]) AS 'Day of the Week',
    SUM(Net_Quantity) AS 'Units Sold',
    SUM(Total_Sales) AS 'Total Sales Revenue'
FROM Sales
WHERE Sale_Type = 'order'
GROUP BY POS_Location, DATENAME(WEEKDAY,[Date]), DATEPART(WEEKDAY,[Date])
ORDER BY POS_Location, DATEPART(WEEKDAY,[Date]);

	--Product_Category
		WITH RankedSales AS (
		SELECT
			POS_Location,
			DATENAME(WEEKDAY,[Date]) AS 'Day of the Week',
            DATEPART(WEEKDAY,[Date]) AS 'Day Number',
			Product_Category,
			SUM(Net_Quantity) AS 'Units Sold',
			SUM(Total_Sales) AS 'Total Sales Revenue',
			ROW_NUMBER() OVER (PARTITION BY POS_Location, DATENAME(WEEKDAY,[Date])
								ORDER BY SUM(Total_Sales) DESC) AS rn
		FROM Sales
		WHERE Sale_Type = 'order'
		GROUP BY POS_Location, DATENAME(WEEKDAY,[Date]), DATEPART(WEEKDAY,[Date]), Product_Category
		)
	
	SELECT
		POS_Location,
		[Day of the Week],
		Product_Category,
		[Units Sold],
		[Total Sales Revenue]
	FROM RankedSales
	WHERE rn <=5
	ORDER BY POS_Location, [Day Number], [Total Sales Revenue] DESC;
	
	--Product_Subcategory
	WITH RankedSales AS (
		SELECT
			POS_Location,
			DATENAME(WEEKDAY,[Date]) AS 'Day of the Week',
			DATEPART(WEEKDAY,[Date]) AS 'Day Number',
			Product_Subcategory,
			SUM(Net_Quantity) AS 'Units Sold',
			SUM(Total_Sales) AS 'Total Sales Revenue',
			ROW_NUMBER() OVER (PARTITION BY POS_Location, DATENAME(WEEKDAY,[Date])
								ORDER BY SUM(Total_Sales) DESC) AS rn
		FROM Sales
		WHERE Sale_Type = 'order'
		GROUP BY POS_Location, DATENAME(WEEKDAY,[Date]), DATEPART(WEEKDAY,[Date]), Product_Subcategory
		)

	SELECT
		POS_Location,
		[Day of the Week],
		Product_Subcategory,
		[Units Sold],
		[Total Sales Revenue]
	FROM RankedSales
	WHERE rn <=5
	ORDER BY POS_Location, [Day Number], [Total Sales Revenue] DESC;

	--Product_Name
	WITH RankedSales AS (
		SELECT
			POS_Location,
			DATENAME(WEEKDAY,[Date]) AS 'Day of the Week',
			DATEPART(WEEKDAY,[Date]) AS 'Day Number',
			Product_Name,
			SUM(Net_Quantity) AS 'Units Sold',
			SUM(Total_Sales) AS 'Total Sales Revenue',
			ROW_NUMBER() OVER (PARTITION BY POS_Location, DATENAME(WEEKDAY,[Date])
								ORDER BY SUM(Total_Sales) DESC) AS rn
		FROM Sales
		WHERE Sale_Type = 'order'
		GROUP BY POS_Location, DATENAME(WEEKDAY,[Date]), DATEPART(WEEKDAY,[Date]), Product_Name
		)

	SELECT
		POS_Location,
		[Day of the Week],
		Product_Name,
		[Units Sold],
		[Total Sales Revenue]
	FROM RankedSales
	WHERE rn <=5
	ORDER BY POS_Location, [Day Number], [Total Sales Revenue] DESC;


-- INVENTORY OPTIMIZATION 
-- 1. Stock Level and Sale Rate Comparison by POS Location (by Quantity)
	-- CTE: Aggregate total inventory per POS location
	WITH TotalInventory AS (
		SELECT 
			POS_Location,
			SUM(Stock_Quantity) AS 'Total Inventory'
		FROM Inventory
		WHERE Stock_Quantity >= 0
		GROUP BY POS_Location
	),
	-- CTE: Aggregate units sold per POS location
	TotalSales AS (
		SELECT 
			POS_Location,
			SUM([Net_Quantity]) AS 'Total Quantity Sold'
		FROM Sales
		WHERE Sale_Type = 'order'
		GROUP BY POS_Location
	)
	SELECT 
		i.POS_Location,
        1.0*[Total Inventory]/[Total Quantity Sold] AS 'Stock to Sales Ratio (Units)',
		s.[Total Quantity Sold],
		i.[Total Inventory]
	FROM TotalInventory i
	FULL JOIN TotalSales s ON i.POS_Location = s.POS_Location
	ORDER BY [Stock to Sales Ratio (Units)] DESC;
	
-- 2. Stock Level and Sale Rate Comparison by POS Location (by Value) 
-- Analyze stock-to-sales ratio by POS:
	-- CTE: Aggregate total inventory value per POS location
	WITH TotalInventory AS (
		SELECT 
			POS_Location,
			SUM(Stock_Quantity * Price) AS 'Total Stock Value'
		FROM Inventory
		WHERE Stock_Quantity >= 0
		GROUP BY POS_Location
	),
	-- CTE: Aggregate total sales value per POS location
	TotalSales AS (
		SELECT 
			POS_Location,
			SUM([Total_Sales]) AS 'Total Sales'
		FROM Sales
		WHERE Sale_Type = 'order'
		GROUP BY POS_Location
	)
	SELECT 
		i.POS_Location,
        1.0*[Total Stock Value]/[Total Sales] AS 'Stock to Sales Ratio (Value)',
		s.[Total Sales],
		i.[Total Stock Value]
	FROM TotalInventory i
	FULL JOIN TotalSales s ON i.POS_Location = s.POS_Location
	ORDER BY [Stock to Sales Ratio (Value)] DESC;

-- LOGISITICS & STOCK DISTRIBUTION
-- 1. Stock Distribution Across POS Location
SELECT
	POS_Location,
	Product_Category,
	SUM(Stock_Quantity) AS 'Inventory Available'
FROM Inventory
WHERE Stock_Quantity >=0
GROUP BY POS_Location, Product_Category
ORDER BY POS_Location, [Inventory Available] DESC;

-- 2. Inventory Value across Locations
SELECT
	POS_Location,
	SUM(Price * Stock_Quantity) AS 'Total Inventory Value',
	SUM(Stock_Quantity) AS 'Inventory Available'
FROM Inventory
WHERE Stock_Quantity >=0
GROUP BY POS_Location
ORDER BY [Total Inventory Value] DESC;

-- CUSTOMER BEHAVIOR 
-- 1. Sales per Order (high value customers)
SELECT 
    POS_Location,
    (SUM(Total_Sales)/COUNT(DISTINCT Order_Name)) AS 'Sales per Order'
FROM Sales
WHERE Sale_Type = 'order'
GROUP BY POS_Location
ORDER BY [Sales per Order] DESC;

-- 2. POS Locations with High Returns **Return Ratio as the 5th column
SELECT 
    POS_Location,
    SUM(Total_Sales) AS 'Total Return Value',
    SUM(Net_Quantity) AS 'Total Return Volume'
FROM Sales
WHERE Sale_Type = 'return'
GROUP BY POS_Location
ORDER BY [Total Sales Revenue] ASC;

-- VENDOR & PRODUCT MIX AT POS LOCATION
-- 1. Vendor Perfomance by POS Location
SELECT
    POS_Location,
    Vendor,
    SUM(Total_Sales) AS 'Revenue',
    SUM(Net_Quantity) AS 'Units Sold' 
FROM Sales
GROUP BY POS_Location, Vendor
ORDER BY POS_Location, Revenue DESC;


Specifcs -- 1. CHECK IF ONE PRODUCT IN ONE POS_LOCATION IS THE SAME PRICE IN ANOTHER POS_LOCATION.
	WITH OneInventoryRowPerProduct AS (
    SELECT 
        Product_Name,
        POS_Location,
        MAX(Price) AS 'Inventory Price'     
    FROM Inventory 
    GROUP BY Product_Name, POS_Location
)

SELECT 
    [Date],
    s.POS_Location,
    s.Product_Category,
    s.Product_Subcategory,
    s.Product_Name,
    Order_Name,
    s.Customer_Name,
    Net_Quantity,
    Total_Sales,
    FORMAT(Total_Sales/Net_Quantity,'N2') AS 'Price per Product',
    i.[Inventory Price]
FROM Sales AS s
LEFT JOIN OneInventoryRowPerProduct AS i
ON s.Product_Name = i.Product_Name
AND s.POS_Location = i.POS_Location
WHERE s.Sale_Type = 'order'AND (s.Total_Sales/s.Net_Quantity) <> i.[Inventory Price]
ORDER BY s.Product_Name

