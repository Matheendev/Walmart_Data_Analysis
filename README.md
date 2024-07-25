# Exploratory Data Analysis (EDA) Walmart_Data_Analysis

## About

This project involved a comprehensive Exploratory Data Analysis (EDA) of Walmart sales data using SQL. The primary focus was to extract valuable insights through data manipulation and analysis, addressing a range of business questions. To ensure data accuracy and consistency, rigorous data wrangling processes were implemented within the MySQL environment.

## Purposes Of The Project

The primary objective of this project was to gain practical experience in SQL query development by delving into Walmart's sales data.

By conducting in-depth analysis, the project aimed to uncover key trends, patterns, and relationships within the data, including identifying top-performing branches and products, understanding sales patterns, and analyzing customer behavior. These insights can serve as a foundation for developing effective sales strategies and optimization initiatives.

## About Data

The dataset was obtained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting). This dataset contains sales transactions from a three different branches of Walmart, respectively located in Mandalay, Yangon and Naypyitaw. The data contains 17 columns and 1000 rows:

### Analysis List

1. Product Analysis

> Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.

2. Sales Analysis

> This analysis aims to answer the question of the sales trends of product. The result of this can help use measure the effectiveness of each sales strategy the business applies and what modificatoins are needed to gain more sales.

3. Customer Analysis

> This analysis aims to uncover the different customers segments, purchase trends and the profitability of each customer segment.

## Approach Used

1. **Data Wrangling**
2. **Feature Engineering** 
3. **Exploratory Data Analysis (EDA)** 

## Revenue And Profit Calculations

COGS = unitsPrice * quantity 

VAT = 5\% * COGS

VAT is added to the $COGS$ and this is what is billed to the customer.

total(gross_sales) = VAT + COGS 

grossProfit(grossIncome) = total(gross_sales) - COGS

**Gross Margin:** It represents the portion of revenue remaining after deducting the cost of goods sold (COGS).

Gross Margin = gross profit / total revenue
