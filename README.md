Q3 2021 Retail Performance Analysis
Project Overview
This project analyzes the retail performance for the third quarter of 2021 to identify key challenges and provide data-driven recommendations. The primary goal is to 

maximize sales performance and capital efficiency in the upcoming quarter. The analysis involved cleaning and transforming raw sales and inventory data, conducting an in-depth exploratory data analysis using SQL, and visualizing the findings in a Power BI dashboard.

Data Analysis & Transformation Pipeline
The project followed a three-step process to convert raw data into actionable business insights.

1. Data Cleaning and Transformation (SQL)
The initial raw data from multiple sources required significant cleaning and restructuring. The Data Cleaning & Transformation.sql script performed the following key actions:

Schema Creation: Established clean tables (ProductClassification, Inventory, Sales) with appropriate data types.

Data Cleansing: Removed extraneous characters and whitespace using TRIM(), handled inconsistent location naming conventions with REPLACE(), and standardized customer names using a combination of CONCAT(), UPPER(), and LOWER() functions.

Data Unpivoting: Transformed the RawInventory table from a wide format (where each store location was a separate column) into a long, normalized format using the UNPIVOT function. This made the data suitable for aggregation and analysis across all locations.

2. Exploratory Data Analysis (SQL)
Using the cleaned tables, a series of complex SQL queries were executed to answer key business questions outlined in Management Objectives.sql. The analysis focused on:

Sales Performance: Aggregated total sales revenue and volume by store location.

Product Analysis: Identified best-selling products, categories, subcategories, and vendors using window functions like ROW_NUMBER().

Time-Based Trends: Analyzed monthly, weekly, and daily sales patterns to identify peak shopping periods.

Inventory Optimization: Calculated stock-to-sales ratios by both value and volume to measure inventory efficiency at each location.

Customer Behavior: Assessed sales per order and identified locations with high return rates.

3. Visualization (Power BI)
The final insights and KPIs were compiled into an interactive dashboard using Power BI (Vevoa Dashboard.pbix). The dashboard provides a comprehensive overview of the key findings, allowing stakeholders to filter data and drill down into specific areas of interest, such as products with zero sales.


Key Findings and Business Recommendations
The analysis uncovered four primary challenges limiting performance, detailed in the Presentation Deck.docx:

Finding 1: Underperforming Sell-Out Rates

Insight: The company-wide sell-out rate is 66%, with the own brand at 69% and major vendors mostly below 60%, falling short of the universal 80% target.


Recommendation: Implement targeted end-of-week promotions to capitalize on historical sales peaks and optimize the product mix to focus on high-demand items.

Finding 2: Declining New Customer Acquisition

Insight: While repeat customers are driving a growing share of sales, the number of new customers is declining month-on-month.


Recommendation: Launch a loyalty program to further capitalize on repeat buyers and introduce targeted first-purchase promotions to reverse the decline in new customer acquisition.

Finding 3: Store and Inventory Mismatch

Insight: The bottom 5 store locations hold 30.84% of inventory value but only generate 18.68% of revenue. This misalignment ties up capital in slow-moving regions.


Recommendation: Rebalance inventory by shifting excess stock to high-performing locations and run region-specific marketing campaigns to boost traffic in underperforming stores.

Finding 4: Stock-Outs on Best Sellers

Insight: The top-selling product has only 3 units left in stock across 15 stores, while over KSh 4M is tied up in products with zero sales in the last three months.



Recommendation: Implement automated replenishment triggers based on sales forecasts to prevent stock-outs and liquidate non-moving inventory through clearance discounts or bundling.

Technical Stack
Database: SQL Server

Analysis & Transformation: T-SQL

Initial Data Structuring: Microsoft Excel (VBA)

Visualization: Power BI
