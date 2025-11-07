-- ==============================================================
-- 📦 PROJECT: Balaji Restaurant Revenue Analysis
-- 🔧 Tools Used: MySQL
-- ==============================================================

-- --------------------------------------------------------------
-- 1️⃣ DATABASE CREATION
-- --------------------------------------------------------------

-- Drop the database if it already exists to avoid conflicts
DROP DATABASE IF EXISTS balaji_restaurant;

-- Create a new database
CREATE DATABASE balaji_restaurant;

-- Use the newly created database
USE balaji_restaurant;


-- --------------------------------------------------------------
-- 2️⃣ TABLE CREATION
-- --------------------------------------------------------------

-- Drop the existing table if it exists
DROP TABLE IF EXISTS sales_table;

-- Create the sales table
CREATE TABLE sales_table (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    date VARCHAR(20),
    item_name VARCHAR(100),
    item_type VARCHAR(50),
    item_price DECIMAL(10, 2),
    quantity INT NOT NULL,
    transaction_amount DECIMAL(10, 2),
    transaction_type VARCHAR(20),
    received_by VARCHAR(100),
    time_of_sale VARCHAR(20)
);


-- --------------------------------------------------------------
-- 3️⃣ DATA LOADING
-- --------------------------------------------------------------

-- Load data from the CSV file (ensure Secure File Priv folder path)
LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\main_file.csv' 
INTO TABLE sales_table 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS (
    order_id,
    date,
    item_name,
    item_type,
    item_price,
    quantity,
    transaction_amount,
    transaction_type,
    received_by,
    time_of_sale
);


-- --------------------------------------------------------------
-- 4️⃣ DATA CLEANING AND COLUMN STANDARDIZATION
-- --------------------------------------------------------------

-- Convert 'date' column into proper DATE format
UPDATE sales_table
SET date = DATE_FORMAT(STR_TO_DATE(date, '%m-%d-%Y'), '%Y-%m-%d');

-- Modify 'date' column data type
ALTER TABLE sales_table MODIFY date DATE;

-- Rename columns for better readability
ALTER TABLE sales_table CHANGE COLUMN transaction_amount amount DECIMAL(10, 2);
ALTER TABLE sales_table CHANGE COLUMN transaction_type payment_method VARCHAR(20);
ALTER TABLE sales_table CHANGE COLUMN received_by gender VARCHAR(20);

-- Standardize gender values
UPDATE sales_table SET gender = 'Male' WHERE gender = 'Mr.';
UPDATE sales_table SET gender = 'Female' WHERE gender = 'Mrs.';

-- Replace empty strings in payment_method with 'Cash'
UPDATE sales_table SET payment_method = 'Cash' WHERE payment_method = '';


-- --------------------------------------------------------------
-- 5️⃣ BASIC BUSINESS QUERIES
-- --------------------------------------------------------------

-- 🔹 Total revenue generated
SELECT SUM(amount) AS Total_Revenue FROM sales_table;
-- Result: ₹275,230.00


-- 🔹 Total number of distinct days in the dataset
SELECT COUNT(DISTINCT date) AS Total_Days FROM sales_table;
-- Result: 348 days of data


-- --------------------------------------------------------------
-- 6️⃣ PRODUCT PERFORMANCE ANALYSIS
-- --------------------------------------------------------------

-- 🔹 Top 5 most profitable items
SELECT item_name, SUM(amount) AS total_revenue
FROM sales_table
GROUP BY item_name
ORDER BY total_revenue DESC
LIMIT 5;

-- Example Result:
-- Sandwich       | 65,820.00
-- Frankie        | 57,500.00
-- Cold Coffee    | 54,440.00
-- Sugarcane Juice| 31,950.00
-- Panipuri       | 24,520.00


-- 🔹 5 least profitable items
SELECT item_name, SUM(amount) AS total_revenue
FROM sales_table
GROUP BY item_name
ORDER BY total_revenue
LIMIT 5;


-- --------------------------------------------------------------
-- 7️⃣ TIME-BASED REVENUE ANALYSIS
-- --------------------------------------------------------------

-- 🔹 Top 3 most profitable months
SELECT DATE_FORMAT(date, '%Y-%m') AS month, SUM(amount) AS total_revenue
FROM sales_table
GROUP BY month
ORDER BY total_revenue DESC
LIMIT 3;

-- Example Result:
-- 2023-01 | 28,670.00
-- 2022-10 | 27,205.00
-- 2022-05 | 26,570.00


-- 🔹 Top 3 weekdays by average revenue
SELECT DAYNAME(date) AS day_of_week, ROUND(AVG(amount), 1) AS avg_revenue
FROM sales_table
GROUP BY day_of_week
ORDER BY avg_revenue DESC
LIMIT 3;

-- Example Result:
-- Tuesday  | 295.8
-- Thursday | 293.4
-- Monday   | 290.3


-- --------------------------------------------------------------
-- 8️⃣ CUSTOMER & ITEM TYPE INSIGHTS
-- --------------------------------------------------------------

-- 🔹 Gender-wise average revenue
SELECT gender, ROUND(AVG(amount), 1) AS avg_revenue
FROM sales_table
GROUP BY gender
ORDER BY avg_revenue DESC;
-- Male: 280.2 | Female: 270.1


-- 🔹 Item type sales & revenue summary
SELECT item_type, SUM(quantity) AS total_quantity_sold, SUM(amount) AS total_revenue
FROM sales_table
GROUP BY item_type
ORDER BY total_quantity_sold DESC;


-- 🔹 Highest revenue-generating item type
SELECT item_type, SUM(amount) AS total_revenue
FROM sales_table
GROUP BY item_type
ORDER BY total_revenue DESC
LIMIT 1;
-- Result: Fast Food


-- 🔹 Average revenue by time of day
SELECT time_of_sale, ROUND(AVG(amount), 1) AS average_revenue
FROM sales_table
GROUP BY time_of_sale
ORDER BY average_revenue DESC;

-- Example:
-- Night      | 302.8
-- Morning    | 282.8
-- Afternoon  | 274.9
-- Evening    | 260.5
-- Midnight   | 254.9


-- --------------------------------------------------------------
-- 9️⃣ REVENUE TREND ANALYSIS
-- --------------------------------------------------------------

-- 🔹 Daily revenue with 7-day moving average
SELECT 
    date,
    SUM(amount) AS daily_revenue,
    ROUND(
        AVG(SUM(amount)) OVER (
            ORDER BY date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ),
        1
    ) AS weekly_moving_avg
FROM sales_table
GROUP BY date
ORDER BY date;


-- 🔹 Monthly growth rate percentage
SELECT 
    DATE_FORMAT(date, '%Y-%m') AS month,
    SUM(amount) AS total_revenue,
    ROUND(
        (
            SUM(amount) - LAG(SUM(amount)) OVER (ORDER BY DATE_FORMAT(date, '%Y-%m'))
        ) / LAG(SUM(amount)) OVER (ORDER BY DATE_FORMAT(date, '%Y-%m')) * 100,
        1
    ) AS growth_percentage
FROM sales_table
GROUP BY month
ORDER BY month;


-- --------------------------------------------------------------
-- 🔟 ADDITIONAL INSIGHTS
-- --------------------------------------------------------------

-- 🔹 Most frequently sold items
SELECT item_name, COUNT(order_id) AS total_orders, SUM(quantity) AS total_quantity, SUM(amount) AS total_revenue
FROM sales_table
GROUP BY item_name
ORDER BY total_orders DESC
LIMIT 5;


-- 🔹 Average Order Value (AOV)
SELECT ROUND(SUM(amount) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM sales_table;


-- 🔹 Sales heatmap by day and time
SELECT DAYNAME(date) AS day_of_week, time_of_sale, SUM(amount) AS total_revenue
FROM sales_table
GROUP BY day_of_week, time_of_sale
ORDER BY FIELD(
    day_of_week, 'Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'
), total_revenue DESC;


-- 🔹 Payment method distribution
SELECT 
    payment_method,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(amount), 2) AS total_revenue,
    ROUND(SUM(amount) / (SELECT SUM(amount) FROM sales_table) * 100, 2) AS percent_of_total
FROM sales_table
GROUP BY payment_method
ORDER BY total_revenue DESC;


-- 🔹 Gender-based spending overview
SELECT gender, COUNT(order_id) AS total_orders, SUM(amount) AS total_revenue, ROUND(AVG(amount), 2) AS avg_order_value
FROM sales_table
GROUP BY gender
ORDER BY total_revenue DESC;


-- 🔹 Data consistency check (price × quantity = amount)
SELECT 
    COUNT(*) AS total_records,
    SUM(CASE WHEN amount = (item_price * quantity) THEN 1 ELSE 0 END) AS correct_records,
    ROUND(SUM(CASE WHEN amount = (item_price * quantity) THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS percent_consistent
FROM sales_table;


-- 🔹 Top 5 item types by revenue & quantity
SELECT item_type, SUM(amount) AS total_revenue, SUM(quantity) AS total_quantity, ROUND(AVG(amount), 2) AS avg_revenue_per_order
FROM sales_table
GROUP BY item_type
ORDER BY total_revenue DESC
LIMIT 5;


-- 🔹 Cumulative revenue over time
SELECT date, SUM(amount) AS daily_revenue, SUM(SUM(amount)) OVER (ORDER BY date) AS cumulative_revenue
FROM sales_table
GROUP BY date
ORDER BY date;


-- 🔹 Top 10 items by revenue contribution (%)
SELECT item_name, SUM(amount) AS total_revenue,
    ROUND(SUM(amount) / (SELECT SUM(amount) FROM sales_table) * 100, 1) AS percent_contribution
FROM sales_table
GROUP BY item_name
ORDER BY percent_contribution DESC
LIMIT 10;

-- ==============================================================
-- ✅ END OF SCRIPT
-- ==============================================================
