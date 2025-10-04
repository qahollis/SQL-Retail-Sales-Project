# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Database**: `SQL - Retail Sales Analysis_utf`

This project is designed to demonstrate SQL skills used by data analysts to navigate, clean, and analyze retail sales data. The project covers setting up a retail sales database, performing exploratory data analysis, and answering business questions through SQL queries. 

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: Created database and named `sales_analysis`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE sales_analysis;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit DECIMAL (10,2),	
    cogs DECIMAL (10,2),
    total_sale DECIMAL (10,2)
);
```

### 2. Data Cleaning

- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql

SELECT * FROM retail_sales
WHERE customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;

--The query did not return any null values. I can double check this with the following queries.

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

--And/or

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

--If there were null values I would use the following to remove them

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR price_per_unit IS NULL
    OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022**:
```sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
AND quantity > 3
AND MONTH(sale_date) = 11
AND YEAR(sale_date) = 2022;
```

3. **Write a SQL query to calculate the total sales (gross_sale) for each category.**:
```sql
SELECT category, 
SUM(total_sale) AS gross_sale,
COUNT(*) AS total_sale
FROM retail_sales
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT category, AVG(age) 
FROM retail_sales
WHERE category = 'Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

SELECT COUNT(*)
FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT category, gender, COUNT(transactions_id) AS total_sales
FROM retail_sales
GROUP BY category, gender
ORDER BY 1; 
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales:**
```sql
SELECT SUM(total_sale) AS sumsale, customer_id
FROM retail_sales
GROUP BY customer_id
ORDER BY sumsale DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category:**
```sql
SELECT category, COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category
ORDER BY unique_customers DESC;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
SELECT 
  CASE 
    WHEN HOUR(sale_time) <= 12 THEN 'Morning'
    WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
  END AS shift,
  COUNT(*) AS order_count
FROM retail_sales
GROUP BY shift;
```

## Findings

- **Customer Demographics**: The dataset includes customers who are roughly 40-42 years of age on average. 
- **High-Value Transactions**: 306 out of 1,987 transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: Sales made by male and female customers are closely aligned when looking at the Clothing and Electronics categories. The widest difference in total sales made by each gender is found in the Beauty department.

## Potential Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.




