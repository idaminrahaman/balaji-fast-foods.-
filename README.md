# 🍽️ Balaji Restaurant Revenue Analysis  

### 📊 Tools Used  
- **MySQL** – for data cleaning, transformation, and analysis  
- **Power BI** – for dashboard creation and visualization  
- **CSV** – for raw data storage and import  

---

## 🧾 Project Overview  

This project focuses on analyzing the **sales and revenue performance** of *Balaji Restaurant* using **SQL** and **Power BI**.  
It provides insights into business trends, product performance, customer behavior, and overall sales growth.  

The dataset covers **348 days** of transaction data, generating a total revenue of approximately **₹2,75,230**.  

---

## 🏗️ Database and Data Preparation  

The database is named **`balaji_restaurant`**, and all tables are created within it.  
To ensure reusability, the script includes `DROP DATABASE / TABLE IF EXISTS` commands, allowing the entire code to run multiple times without errors.  

### Data Cleaning Steps  
- Converted the `date` column into proper `DATE` format.  
- Renamed key columns for better readability.  
- Standardized the `gender` values (`Mr.` → `Male`, `Mrs.` → `Female`).  
- Replaced blank payment method fields with **“Cash”**.  
- Verified that `item_price × quantity = amount` for all records.  

These steps ensured a clean, reliable, and analysis-ready dataset.  

---

## 🧮 SQL Analysis Performed  

### 1️⃣ **Basic Metrics**  
- Total revenue generated.  
- Total number of active sales days (348).  
- Average order value (AOV).  

### 2️⃣ **Product & Category Insights**  
- Top 5 and least profitable items.  
- Item-type-wise sales and revenue.  
- Fast food identified as the leading revenue driver.  

### 3️⃣ **Time-Based Analysis**  
- Daily revenue with a **7-day moving average** trend.  
- Month-over-month (MoM) and weekday-wise performance.  
- Identification of the most profitable months and times of day.  

### 4️⃣ **Customer & Payment Insights**  
- Gender-wise average spending.  
- Distribution of payment methods.  
- Revenue share by customer type.  

### 5️⃣ **Cumulative and Contribution Analysis**  
- Cumulative revenue over time.  
- Revenue contribution percentage by each item.  

---

## 📈 Power BI Dashboard Highlights  

An interactive Power BI dashboard was created to visualize all SQL findings.  

**Dashboard Features:**  
- KPI cards showing total revenue and transactions.  
- Bar charts for top and bottom-performing products.  
- Line chart showing daily revenue and 7-day moving average.  
- Heatmap visualizing revenue by day and time.  
- Pie charts showing gender and payment method distribution.  

---

## 🔍 Key Business Insights  

- **January 2023** recorded the highest revenue among all months.  
- **Weekday sales (Tuesday, Thursday, Monday)** outperform weekends.  
- **Sandwiches** generate the highest revenue, while **Cold Coffee** sells the most — indicating pricing optimization potential.  
- **Fast food** dominates both in orders and revenue share.  
- Revenue growth **plateaued after November**, with declines in **February and March 2023**.  
- Male customers contribute slightly more to revenue on average.  
- Majority of payments were made in **cash**.  

---

## ⚙️ How to Run the Project  

1. Download the `02_schema.sql` file from this repository.  
2. Place the dataset (`main_file.csv`) inside your MySQL **Uploads** directory.  
3. Open MySQL Workbench or vs code and execute the script sequentially.  
4. Use the generated dataset for Power BI dashboard creation.  

---

## 📂 Repository Structure  

| File Name | Description |
|------------|-------------|
| `02_schema.sql` | Full SQL script (database creation, cleaning, and analysis) |
| `main_file.csv` | Raw transaction dataset |
| `visualization.pbix` | Power BI dashboard file |
| `README.md` | Project documentation |


---

## 👨‍💻 Author  

**Idamin Rahaman**  
_Data Analyst | SQL & Power BI Enthusiast_  

 LinkedIn: www.linkedin.com/in/idamin-rahaman-b754322aa

