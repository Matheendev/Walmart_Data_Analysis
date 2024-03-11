-- DATA Wrangling
-- Creting Database, Table and Importing DATA from CSV file

CREATE DATABASE IF NOT EXISTS SalesDataWalmart;
CREATE TABLE IF NOT EXISTS sale(
	invoice_id VARCHAR(50) NOT NULL PRIMARY KEY,
	branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL (10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL (12, 4) NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
	payment_metod VARCHAR(15) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_prct FLOAT(11, 9),
    gross_income DECIMAL(12, 4) NOT NULL,
    rating FLOAT(2, 1)
);

SELECT * FROM salesdatawalmart.sales
limit 1000;

-- ---------------------- FEATURE ENGINEERING ----------------------- --
-- ---------- time_of_date (Morning, Aternoon, or Evening) ---------- --
SELECT 
	time,
    (CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Aternoon"
        ELSE "Evening"
	END
	) AS time_of_date
FROM sales;

ALTER TABLE sales
ADD COLUMN time_of_delay VARCHAR(30);

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET time_of_delay = (
	CASE
		WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Aternoon"
        ELSE "Evening"
	END
	);
    
-- day_name (Mon, Tue, Wed, Thu, Fri, Sat, or Sun)

SELECT 
	DATE,
    DAYNAME(date) AS day_name
FROM sales;

ALTER TABLE sales
ADD COLUMN day_name VARCHAR(20);

UPDATE sales
SET day_name = DAYNAME(date);

-- month_name (jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec)

SELECT
	date,
    MONTHNAME(date)
FROM sales;


ALTER TABLE sales
ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

-- Conclusion

-- Business Questions To Answer
-- Generic
-- 1. How many unique cities does the data have?

SELECT 
	DISTINCT city
FROM sales;

SELECT 
	DISTINCT branch
FROM sales;

-- 2. In which city is each branch?

SELECT 
	DISTINCT city, branch
FROM sales;

-- Product
-- 1. How many unique product lines does the data have?

SELECT 
	COUNT(DISTINCT product_line)
FROM sales;

-- 2. What is the most common payment method?

SELECT 
	payment,
    COUNT(payment) AS count
FROM sales
GROUP BY payment
ORDER BY count DESC;

-- 3. What is the most selling product line?

SELECT 
	product_line,
    COUNT(product_line) AS count
FROM sales
GROUP BY product_line
ORDER BY count DESC;

-- 4. What is the total revenue by month?

SELECT 
	month_name AS month,
    SUM(total) AS total_revenue
FROM sales
GROUP BY month
ORDER BY total_revenue DESC;

-- 5. What month had the largest COGS?

SELECT 
	month_name AS month,
    SUM(cogs) AS cogs
FROM sales
GROUP BY month
ORDER BY cogs DESC;

-- 6. What product line had the largest revenue?

SELECT 
	product_line,
    SUM(total) AS largest_revenue
FROM sales
GROUP BY product_line
ORDER BY largest_revenue DESC;

-- 7. What is the city with the largest revenue?

SELECT 
	branch,
	city,
    SUM(total) AS largest_revenue
FROM sales
GROUP BY city, branch
ORDER BY largest_revenue DESC;
    
-- 8. What product line had the largest VAT?

SELECT 
	product_line,
    AVG(tax_pct) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- 9. Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	product_line,
	ROUND(AVG(total), 2) AS avg_sales,
    (CASE 
		WHEN AVG(total) > (select avg(total) from sales) THEN "Good"
		ELSE "BAD"
    END) AS remarks
FROM sales
Group by product_line;

-- 10. Which branch sold more products than average product sold?

SELECT 
	branch,
    SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (select avg(quantity) from sales);

-- 11. What is the most common product line by gender?

SELECT 
	gender,
    product_line,
    COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- 12. What is the average rating of each product line?

SELECT 
	product_line,
    ROUND(AVG(rating), 2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- Sales
-- 1. Number of sales made in each time of the day per weekday

ALTER TABLE sales
change time_of_delay time_of_day VARCHAR(20);

SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name = "Sunday" -- Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, or Sunday
GROUP BY time_of_day
ORDER BY total_sales;

-- 2. Which of the customer types brings the most revenue?

SELECT 
	customer_type,
    SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- 3. Which city has the largest tax percent/ VAT (Value Added Tax)?

SElECT 
	city,
    AVG(tax_pct) AS largest_tax_pct
FROM sales
GROUP BY city
ORDER BY largest_tax_pct DESC;

-- 4. Which customer type pays the most in VAT?

SELECT 
	customer_type,
    AVG(tax_pct) AS largest_tax_pct
FROM sales
GROUP BY customer_type
ORDER BY largest_tax_pct DESC;

-- Customer
-- 1. How many unique customer types does the data have?

SELECT 
	DISTINCT customer_type
FROM sales;

-- 2. How many unique payment methods does the data have?

SELECT
	DISTINCT payment
FROM sales;

-- 3. What is the most common customer type?

SELECT 
	DISTINCT customer_type
FROM sales;

-- 4. Which customer type buys the most?

SELECT 
	customer_type,
    COUNT(*) AS buys_most
FROM sales
GROUP BY customer_type
ORDER BY buys_most DESC;

-- 5. What is the gender of most of the customers?

SELECT 
	gender,
    COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender
ORDER by gender_cnt DESC;

-- 6.  What is the gender distribution per branch?

SELECT 
	gender,
    COUNT(*) AS gender_cnt
FROM sales
WHERE branch = "C"  -- A,B, or C branch
GROUP BY gender
ORDER by gender_cnt DESC;

-- 7. Which time of the day do customers give most ratings?

SELECT
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- 8. Which time of the day do customers give most ratings per branch?

SELECT 
	time_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch = "C" -- A, B, or C
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- 9. Which day fo the week has the best avg ratings?

SELECT 
	day_name,
    AVG (rating) AS avg_rating
FROM saleS
GROUP BY day_name
ORDER BY avg_rating DESC;

-- 10. Which day of the week has the best average ratings per branch?

SELECT 
	day_name,
    AVG (rating) AS avg_rating
FROM saleS
WHERE branch = "A"  -- A, b, or c
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Revenue And Profit Calculations
-- To Find COGS(cost_of_goods_sold), VAT(value_added_tax), total_gross_sales, gross_profit, gross_margin_percentage.

SELECT 
	ROUND(unit_price * quantity, 2) AS cost_of_goods_sold,
    ROUND(cogs * 0.05, 2) AS value_added_tax,
    ROUND(unit_price * quantity + cogs * 0.05, 2) AS total_gross_sales,
	ROUND(unit_price * quantity + cogs * 0.05 - cogs, 2) AS gross_profit,
    ROUND((unit_price * quantity + cogs * 0.05 - cogs) / (unit_price * quantity + cogs * 0.05) * 100, 2) AS gross_margin_percentage 
FROM sales;
    