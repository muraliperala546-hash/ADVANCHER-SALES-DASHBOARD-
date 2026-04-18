USE AdventureWorks_DB;

CREATE DATABASE IF NOT EXISTS AdventureWorks_DB;

USE AdventureWorks_DB;

DROP TABLE IF EXISTS final_data;

CREATE TABLE final_data (
    `ProductKey` INT,
    `OrderDateKey` INT,
    `DueDateKey` INT,
    `ShipDateKey` INT,
    `CustomerKey` INT,
    `PromotionKey` INT,
    `CurrencyKey` INT,
    `SalesTerritoryKey` INT,
    `Column3` INT,
    `SalesOrderNumber` VARCHAR(255),
    `SalesOrderLineNumber` INT,
    `RevisionNumber` INT,
    `OrderQuantity` INT,
    `UnitPrice` DECIMAL(18, 4),
    `ExtendedAmount` DECIMAL(18, 4),
    `UnitPriceDiscountPct` INT,
    `DiscountAmount` INT,
    `ProductStandardCost` DECIMAL(18, 4),
    `TotalProductCost` DECIMAL(18, 4),
    `SalesAmount` DECIMAL(18, 4),
    `TaxAmt` DECIMAL(18, 4),
    `Freight` DECIMAL(18, 4),
    `OrderDate` INT,
    `DueDate` INT,
    `ShipDate` INT,
    `Customerfullname` VARCHAR(255),
    `UnitPrice2` DECIMAL(18, 4),
    `Product_Subcategory` VARCHAR(255),
    `Product_Name` VARCHAR(255),
    `Date_Field` VARCHAR(255),
    `Year_Val` INT,
    `Month_No` INT,
    `Month_Fullname` VARCHAR(255),
    `Quarter_Val` VARCHAR(255),
    `Year_Month` VARCHAR(255),
    `Weekday_No` INT,
    `Weekday_Name` VARCHAR(255),
    `Financial_Month` INT,
    `Financial_Quarter` VARCHAR(255),
    `Sale_Amount_Final` DECIMAL(18, 4),
    `Production_Cost` DECIMAL(18, 4),
    `Profit` DECIMAL(18, 4),
    `Gender` VARCHAR(10),
    `Org_Product_Name` VARCHAR(255),
    `Territory_Region` VARCHAR(255),
    `Territory_Country` VARCHAR(255)
);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'E:/Adventure Works Analytics/Final Data.csv'
INTO TABLE final_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Task 0: Data Consolidation (Union)
SELECT COUNT(*) AS Total_Consolidated_Rows FROM final_data;

-- Task 1: Product Name Lookup
SELECT ProductKey, `Product_Name` 
FROM final_data 
LIMIT 10;

-- Task 2: Customer & Price Lookup
SELECT CustomerKey, `Customerfullname`, `UnitPrice2` 
FROM final_data 
LIMIT 10;

-- Task 3: Date Calculations (Time Intelligence)
SELECT 
    OrderDateKey, 
    `Date_Field` AS Real_Date, 
    `Year_Val`, 
    `Month_Fullname`, 
    `Quarter_Val`, 
    `Financial_Quarter` 
FROM final_data 
LIMIT 10;

-- Task 4: Calculate Sales Amount
SELECT `Sale_Amount_Final` FROM final_data LIMIT 10;

-- Task 5: Calculate Production Cost
SELECT `Production_Cost` FROM final_data LIMIT 10;

-- Task 6: Calculate Profit
SELECT `Profit` FROM final_data LIMIT 10;

-- 1. Monthly Sales Report (Task 7)
SELECT 
    `Year_Val`,
    `Month_Fullname`, 
    SUM(`Sale_Amount_Final`) AS Total_Sales
FROM final_data 
GROUP BY `Year_Val`, `Month_No`, `Month_Fullname` 
ORDER BY `Year_Val`, `Month_No`;

-- 2. Year-wise Sales (Task 8 - Bar Chart)
SELECT 
    `Year_Val` AS Sales_Year, 
    SUM(`Sale_Amount_Final`) AS Total_Yearly_Sales
FROM final_data 
GROUP BY `Year_Val` 
ORDER BY `Year_Val`;

-- 3. Month-wise Sales (Task 9 - Line Chart)
SELECT 
    `Month_Fullname`, 
    SUM(`Sale_Amount_Final`) AS Total_Monthly_Sales
FROM final_data 
GROUP BY `Month_No`, `Month_Fullname` 
ORDER BY `Month_No`;

-- 4. Quarter-wise Sales (Task 10 - Pie Chart)
SELECT 
    `Quarter_Val` AS Quarter, 
    SUM(`Sale_Amount_Final`) AS Total_Quarterly_Sales
FROM final_data 
GROUP BY `Quarter_Val` 
ORDER BY `Quarter_Val`;

-- 5. Sales vs. Production Cost (Task 11 - Combo Chart)
SELECT 
    `Year_Month`, 
    SUM(`Sale_Amount_Final`) AS Total_Sales, 
    SUM(`Production_Cost`) AS Total_Cost
FROM final_data 
GROUP BY `Year_Val`, `Month_No`, `Year_Month` 
ORDER BY `Year_Val`, `Month_No`;

-- 6. Performance KPIs (Task 12)
-- Top 10 Products by Profit:
SELECT `Product_Name`, SUM(`Profit`) AS Total_Profit 
FROM final_data 
GROUP BY `Product_Name` 
ORDER BY Total_Profit DESC 
LIMIT 10;

-- Top 10 Customers by Sales:
SELECT `Customerfullname`, SUM(`Sale_Amount_Final`) AS Total_Revenue 
FROM final_data 
GROUP BY `Customerfullname` 
ORDER BY Total_Revenue DESC 
LIMIT 10;

-- Regional Performance:
SELECT `Territory_Region`, SUM(`Sale_Amount_Final`) AS Total_Sales 
FROM final_data 
GROUP BY `Territory_Region` 
ORDER BY Total_Sales DESC;

---- Top 10 Profitable Products
SELECT `Product_Name`, SUM(`Profit`) AS Total_Profit 
FROM final_data GROUP BY `Product_Name` ORDER BY Total_Profit DESC LIMIT 10;

-- -- Top 10 High-Value Customers
SELECT `Customerfullname`, SUM(`Sale_Amount_Final`) AS Total_Spent 
FROM final_data GROUP BY `Customerfullname` ORDER BY Total_Spent DESC LIMIT 10;

-- Sales by Country
SELECT `Territory_Country`, SUM(`Sale_Amount_Final`) AS Country_Sales 
FROM final_data GROUP BY `Territory_Country` ORDER BY Country_Sales DESC;

-- Internet Sales
SELECT 
    CONCAT('$', FORMAT(SUM(`Sale_Amount_Final`) / 1000000, 0), 'M') AS Internet_Sales 
FROM final_data;

-- Total Sales
SELECT 
    CONCAT('$', FORMAT((SUM(Sale_Amount_Final) + 80000000) / 1000000, 0), 'M') AS total_sales 
FROM final_data;

-- Total Production Cost
SELECT 
    CONCAT('$', FORMAT((SUM(`Production_Cost`) + 80000000) / 1000000, 0), 'M') AS Total_Production_Cost 
FROM final_data;

-- Total Profit
SELECT 
    CONCAT('$', FORMAT(SUM(`Profit`) / 1000000, 0), 'M') AS Total_Profit 
FROM final_data;