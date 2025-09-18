-- In this table, the headers were not recognized so I had to delete values in the data that were meant to be the headers
	SELECT TOP * 
	FROM RawProductClassification;

	DELETE FROM RawProductClassification
	WHERE Subcategory = 'Subcategory' AND Category = 'Category';

-- Clean the RawProductClassification table
	-- Create a clean table
	CREATE TABLE dbo.ProductClassification (
		Product_Subcategory NVARCHAR(50) NOT NULL,
		Product_Category NVARCHAR(50) NOT NULL,
	);

	-- Insert only unique, trimmed pairs
	INSERT INTO dbo.ProductClassification (Subcategory, Category)
	SELECT DISTINCT
		TRIM(Subcategory),
		TRIM(Category)
	FROM RawProductClassification

-- Clean the RawInventory table
	-- Create a clean table
	CREATE TABLE dbo.Inventory (
		Product_Category NVARCHAR(50),
		Product_Subcategory NVARCHAR(50),
		Product_Name NVARCHAR(100),
		SKU NVARCHAR(50),
		Barcode NVARCHAR(50),
		Vendor NVARCHAR(50),
		Option2 NVARCHAR(50),
		Price DECIMAL(10,2),
		POS_Location NVARCHAR(50),
		Stock_Quantity INT
	);

	-- Insert cleaned & unpivoted data
	INSERT INTO Inventory (Product_Category, Product_Subcategory, Product_Name, SKU, Barcode, Vendor, Option2, Price, POS_Location, Stock_Quantity)
	SELECT 
		TRIM(Category),
		TRIM(Subcategory),
		TRIM(Style_Name),
		TRIM(SKU),
		TRIM(Barcode),
		TRIM(Vendor),
		TRIM(Option_2),
		Price,
		TRIM(POS_Location),
		TRY_CAST(Stock_Quantity AS INT)
	FROM (
		SELECT 
			Category, Subcategory, Style_Name, SKU, Barcode, Vendor, Option_2, Price,
			Garden_City, Sarit, Two_Rivers, Capital_Centre, T_Mall,
			Galleria, Nakuru, Eldoret, City_Mall, Vivo_Village_Market, 
			Junction, Hub, Yaya, Mama_Ngina_St, Kisumu
		FROM RawInventory
	) AS SourceTable
	UNPIVOT (
		Stock_Quantity FOR POS_Location IN (
			Garden_City, Sarit, Two_Rivers, Vivo_Capital_Centre, Vivo_T_Mall,
			Galleria, Nakuru, Eldoret, City_Mall, Village_Market, 
			Junction, Hub, Yaya, Mama_Ngina_St, Kisumu
		)
	) AS Unpivoted;

--- Clean the RawSales table
	-- Create a clean table *Write date as SalesDate (Avoid using keywords)
	CREATE TABLE Sales (
		Date DATE,
		POS_Location NVARCHAR(50),
		Sale_Type NVARCHAR(50),
		Vendor NVARCHAR(50),
		Product_Category NVARCHAR(50),
		Product_Subcategory NVARCHAR(50),
		Product_Name NVARCHAR(100),
		Order_Name NVARCHAR(50),
		Customer_Name NVARCHAR(50),
		Net_Quantity INT,
		Total_Sales DECIMAL(10,2)
	);

	-- Insert cleaned data
	INSERT INTO Sales (POS_Location, Sale_Type, Vendor, Product_Category, Product_Subcategory, Product_Name, Order_Name, Customer_Name, Net_Quantity, Total_Sales)
	SELECT
		Date,
		TRIM(POS_Location_Name),
		TRIM(Sales_Kind),
		TRIM(Product_Vendor),
		TRIM(Category),
		TRIM(Subcategory),
		TRIM(Style_Name),
		TRIM(Order_Name),
    -- Combine and clean names **try without the len function
		CONCAT(
			UPPER(LEFT(CleanedFirstName, 1)) + LOWER(SUBSTRING(CleanedFirstName, 2, LEN(CleanedFirstName))),' ',
			UPPER(LEFT(CleanedLastName, 1)) + LOWER(SUBSTRING(CleanedLastName, 2, LEN(CleanedLastName)))
		) AS Customer_Name,
		Net_Quantity,
		Total_Sales
	FROM (
		SELECT *,
        -- Remove numbers/symbols from first and last names using TRANSLATE + REPLACE
			REPLACE(
				TRANSLATE(TRIM([Customer_First_Name]), '0123456789+', REPLICATE(' ', 11)),
			' ', '') AS CleanedFirstName,

			REPLACE(
				TRANSLATE(TRIM([Customer_Last_Name]), '0123456789+', REPLICATE(' ', 11)),
			' ', '') AS CleanedLastName
		FROM RawSales
	)AS CleanedNames;

-- Found POS_Location in Sales and Inventory Table differ (Inventory Tbale had an underscore)
	-- Fixed this and added a - for Vivo T-Mall
	UPDATE Inventory
	SET POS_Location = 
			CASE 
				WHEN POS_Location = 'Vivo_T_Mall' THEN 'Vivo T-Mall'
				ELSE REPLACE(POS_Location, '_', ' ')
			END;
			
	-- Updated Sales table as well to make Vivo T- Mall into Vivo T-Mall
	UPDATE Sales
	SET POS_Location = 'Vivo T-Mall'
	WHERE POS_Location = 'Vivo T- Mall'