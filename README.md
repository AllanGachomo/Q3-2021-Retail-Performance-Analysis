# Q3 2021 Retail Performance Analysis

# 📌 Project Overview

This project analyzes retail performance for Q3 2021 with the objective of identifying key challenges and providing data-driven recommendations to maximize sales performance and capital efficiency.

The workflow involved:

Cleaning and transforming raw sales and inventory data using SQL

Conducting an exploratory data analysis (EDA) to answer management objectives

Building an interactive Power BI dashboard to visualize insights and KPIs

# 🔄 Data Analysis & Transformation Pipeline

The project followed a three-step process to convert raw data into actionable insights:

1. Data Cleaning & Transformation (SQL)

Schema Creation: Designed normalized tables (ProductClassification, Inventory, Sales) with appropriate data types.

Data Cleansing: Standardized customer and location names using TRIM(), REPLACE(), CONCAT(), UPPER(), and LOWER().

Data Unpivoting: Restructured RawInventory from wide format into long format using UNPIVOT for aggregation across all locations.

2. Exploratory Data Analysis (SQL)

Key analyses executed via complex T-SQL queries:

Sales Performance: Aggregated sales revenue and volume by store.

Product Analysis: Ranked top products, categories, subcategories, and vendors with ROW_NUMBER().

Time-Based Trends: Identified peak shopping periods across months, weeks, and days.

Inventory Optimization: Measured stock-to-sales ratios (value & volume) per store.

Customer Behavior: Analyzed sales/order averages and return rates per location.

3. Visualization (Power BI)

Developed the Vevoa Dashboard.pbix, an interactive Power BI report.

Enabled filtering, drill-downs, and focused views (e.g., zero-sales products).

# 📊 Key Findings & Recommendations
1. Underperforming Sell-Out Rates

Insight: Company-wide sell-out rate = 66% (own brand: 69%, vendors: <60%) vs. 80% target.

Recommendation: Run end-of-week promotions & optimize product mix for high-demand items.

2. Declining New Customer Acquisition

Insight: Repeat customers growing, but new customers declining MoM.

Recommendation: Launch loyalty program & targeted first-purchase promotions.

3. Store & Inventory Mismatch

Insight: Bottom 5 stores = 30.84% of inventory value but only 18.68% of revenue.

Recommendation: Rebalance stock to top stores & run region-specific marketing.

4. Stock-Outs on Best Sellers

Insight: Top product = only 3 units left across 15 stores, while KSh 4M stuck in zero-sales products.

Recommendation: Use automated replenishment triggers & clear dead stock with discounts/bundling.

# 🛠️ Tech Stack

Database: SQL Server

Data Transformation: T-SQL

Initial Structuring: Microsoft Excel (VBA)

Visualization: Power BI
