CREATE DATABASE IF NOT EXISTS sales_analysis_database;

USE sales_analysis;

SHOW DATABASES;

CREATE TABLE IF NOT EXISTS sales_table (
	sale_id INT AUTO_INCREMENT,
    sale_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    CONSTRAINT pk_sale_id PRIMARY KEY(sale_id)
);

INSERT INTO sales_table (sale_date, amount) VALUES
('2026-01-01', 1000),
('2026-01-01', 1500),
('2026-01-02', 2000),
('2026-01-02', 1000),
('2026-01-03', 2500),
('2026-01-03', 1500),
('2026-01-04', 3000),
('2026-01-04', 2000),
('2026-01-05', 3500),
('2026-01-05', 2500),
('2026-01-06', 3000),
('2026-01-06', 2000),
('2026-01-07', 4000),
('2026-01-07', 2500),
('2026-01-08', 4500),
('2026-01-08', 3000),
('2026-01-09', 5000),
('2026-01-09', 3500),
('2026-01-10', 5500),
('2026-01-10', 4000),
('2026-01-11', 4500),
('2026-01-11', 3000),
('2026-01-12', 6000),
('2026-01-12', 4000),
('2026-01-13', 6500),
('2026-01-13', 4500),
('2026-01-14', 7000),
('2026-01-14', 5000),
('2026-01-15', 7500),
('2026-01-15', 5500),
('2026-01-16', 6000),
('2026-01-16', 4000),
('2026-01-17', 8000),
('2026-01-17', 5000),
('2026-01-18', 8500),
('2026-01-18', 5500),
('2026-01-19', 9000),
('2026-01-19', 6000),
('2026-01-20', 9500),
('2026-01-20', 6500),
('2026-01-21', 7000),
('2026-01-21', 5000),
('2026-01-22', 10000),
('2026-01-22', 7000),
('2026-01-23', 11000),
('2026-01-23', 7500),
('2026-01-24', 12000),
('2026-01-24', 8000),
('2026-01-25', 10000),
('2026-01-25', 7000),
('2026-01-26', 12500),
('2026-01-26', 8500),
('2026-01-27', 13000),
('2026-01-27', 9000),
('2026-01-28', 14000),
('2026-01-28', 9500),
('2026-01-29', 15000),
('2026-01-29', 10000),
('2026-01-30', 16000),
('2026-01-30', 11000);


SELECT * FROM sales_table;

-- Check the total number of records

SELECT COUNT(*) AS total_records
FROM sales_table;

-- Calculate daily average sales using AVG()

SELECT
	sale_date,
    COUNT(*) as total_transactions,
    SUM(amount) as daily_total_sales,
    AVG(amount) as daily_average_sales
FROM sales_table
GROUP BY sale_date
ORDER BY sale_date;

-- Calculate previous day's sales using LAG()

WITH daily_sales AS (
	SELECT 
		sale_date,
        SUM(amount) as daily_total_sales
	FROM sales_table
    GROUP BY sale_date
)

SELECT
	sale_date,
    daily_total_sales,
    LAG(daily_total_sales) OVER (ORDER BY sale_date) as previous_day_sales
FROM daily_sales;


-- Calculate sales difference

-- calculate how much sales increased or decreased compared with the previous day.


WITH  daily_sales AS (
	SELECT
		sale_date,
        SUM(amount) as daily_total_sales
	FROM 
		sales_table
	GROUP BY sale_date
)
SELECT
	sale_date,
    daily_total_sales,
    LAG(daily_total_sales) OVER(ORDER BY sale_date) AS previous_day_sales,
    (daily_total_sales - LAG(daily_total_sales)
    OVER (ORDER BY sale_date)) AS sales_difference
FROM daily_sales;


-- Calculate daily sales growth percentage

WITH daily_sales AS (
    SELECT
        sale_date,
        SUM(amount) AS daily_total_sales
    FROM sales_table
    GROUP BY sale_date
),
sales_comparison AS (
    SELECT
        sale_date,
        daily_total_sales,
        LAG(daily_total_sales)
        OVER (ORDER BY sale_date) AS previous_day_sales
    FROM daily_sales
)
SELECT
    sale_date,
    daily_total_sales,
    previous_day_sales,
    ROUND(
        (
            (daily_total_sales - previous_day_sales)
            / NULLIF(previous_day_sales, 0)
        ) * 100,
        2
    ) AS growth_percentage
FROM sales_comparison;

-- Compare future sales using LEAD()


WITH daily_sales AS (
	SELECT
		sale_date,
        SUM(amount) AS daily_total_sales
	FROM
		sales_table
	GROUP BY sale_date
)
SELECT
	sale_date,
    daily_total_sales,
    LEAD(daily_total_sales) OVER (ORDER BY sale_date) as next_day_sales
FROM
	daily_sales;
    

-- Calculate a 3-day moving average

WITH daily_sales AS (
	SELECT
		sale_date,
        SUM(amount) AS daily_total_sales
	FROM sales_table
    GROUP BY sale_date
)
SELECT
	sale_date,
    daily_total_sales,
    ROUND(
		AVG(daily_total_sales) OVER(
			ORDER BY sale_date
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        )
    ,2) AS moving_average_3_days
FROM
	daily_sales;


-- Calculate a 7-day moving average

WITH daily_sales AS (
    SELECT
        sale_date,
        SUM(amount) AS daily_total_sales
    FROM sales_table
    GROUP BY sale_date
)
SELECT
    sale_date,
    daily_total_sales,
    ROUND(
        AVG(daily_total_sales) OVER (
            ORDER BY sale_date
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
    2) AS moving_average_7_days
FROM daily_sales;

