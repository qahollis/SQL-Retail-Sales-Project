-- SQL Retail Salaes Analysis - P1
CREATE DATABASE sales_analysis;


-- Create TABLE
CREATE TABLE retail_sales 
	(
    transactions_id INT PRIMARY KEY, 
    sale_date DATE,
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    category VARCHAR (15),
    quantity INT, 
    price_per_unit DECIMAL (10,2),
    cogs DECIMAL (10,2),
    total_sale DECIMAL (10,2)
); 

SELECT * FROM retail_sales;

SELECT COUNT(*) FROM retail_sales;

-- Data Cleaning

SELECT * FROM retail_sales
WHERE customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

SELECT
  COUNT(*) AS total_rows,
  COUNT(customer_id) AS non_null_customer_id,
  COUNT(gender) AS non_null_gender,
  COUNT(age) AS non_null_age,
  COUNT(category) AS non_null_category,
  COUNT(quantity) AS non_null_quantity,
  COUNT(price_per_unit) AS non_null_price_per_unit,
  COUNT(cogs) AS non_null_cogs,
  COUNT(total_sale) AS non_null_total_sale
FROM retail_sales;

SELECT
  SUM(customer_id IS NULL) AS null_customer_id,
  SUM(gender IS NULL) AS null_gender,
  SUM(age IS NULL) AS null_age,
  SUM(category IS NULL) AS null_category,
  SUM(quantity IS NULL) AS null_quantity,
  SUM(price_per_unit IS NULL) AS null_price_per_unit,
  SUM(cogs IS NULL) AS null_cogs,
  SUM(total_sale IS NULL) AS null_total_sale
FROM retail_sales;

SELECT COUNT(*) FROM retail_sales;

-- Data Exploration

-- How many sales do we have?
SELECT COUNT(*) as total_sale FROM retail_sales;

-- How many unique customers do we have?
SELECT COUNT(DISTINCT customer_id) AS total_sale FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on "2022-11-05"
-- Q.2 Write a SQL query to retrieve all transactions where the category is "Clothing" and the quantity sold is more than 3 in the month of Nov-22
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the "Beauty" category
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category
-- Q.7 Write a SQL query to calculate the averae sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

-- Q.1 Write a SQL query to retrieve all columns for sales made on "2022-11-05"

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is "Clothing" and the quantity sold is more than 3 in the month of Nov-22

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantity > 3
AND MONTH(sale_date) = 11
AND YEAR(sale_date) = 2022;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category

SELECT category, 
SUM(total_sale) AS gross_sale,
COUNT(*) AS total_sale
FROM retail_sales
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the "Beauty" category

SELECT category, AVG(age) 
FROM retail_sales
GROUP BY category;

SELECT category, AVG(age) 
FROM retail_sales
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category

SELECT category, gender, COUNT(transactions_id) AS total_sales
FROM retail_sales
GROUP BY category, gender
ORDER BY 1; 

-- Q.7 Write a SQL query to calculate the averae sale for each month. Find out best selling month in each year

SELECT 
YEAR(sale_date) AS sale_year,
MONTH(sale_date) AS sale_month,
AVG(total_sale) as avg_sale
FROM retail_sales
GROUP BY sale_year, sale_month
ORDER BY sale_year, sale_month;

WITH monthly_sales AS (
SELECT 
YEAR(sale_date) AS sale_year,
MONTH(sale_date) AS sale_month,
AVG(total_sale) as avg_sale
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
)

SELECT sale_year, MAX(avg_sale) AS max_sale
FROM monthly_sales
GROUP BY sale_year;

WITH monthly_sales AS (
SELECT 
YEAR(sale_date) AS sale_year,
MONTH(sale_date) AS sale_month,
AVG(total_sale) as avg_sale
FROM retail_sales
GROUP BY YEAR(sale_date), MONTH(sale_date)
)

SELECT ms.*
FROM monthly_sales ms
JOIN(
SELECT sale_year, MAX(avg_sale) AS max_sale
FROM monthly_sales
GROUP BY sale_year
) best_months
ON ms.sale_year = best_months.sale_year
AND ms.avg_sale = best_months.max_sale
ORDER BY ms.sale_year, ms.sale_month;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT SUM(total_sale) AS sumsale, customer_id
FROM retail_sales
GROUP BY customer_id
ORDER BY sumsale DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category

SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

SELECT 
  CASE 
    WHEN HOUR(sale_time) <= 12 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS shift,
  COUNT(*) AS order_count
FROM retail_sales
GROUP BY shift;

-- End of project