SELECT * FROM sp_sales;

# Data cleaning and formatting

# Date formatting
SELECT `Date` 
FROM sp_sales
LIMIT 10;

SELECT `Date`
FROM sp_sales
WHERE STR_TO_DATE(`Date`, '%m/%d/%Y') IS NULL;

SELECT
	STR_TO_DATE(`Date`, '%m/%d/%Y') as converted_date
    FROM sp_sales
    LIMIT 10;
    
# Let's start by comparing which branch makes the most revenue
SELECT Branch, City, SUM(Total) AS total_sales
FROM sp_sales
GROUP BY Branch, City
ORDER BY total_sales DESC;

# We can see that Branch C, located in Naypyitaw brings in the most revenue for the company (chart)
#---------------------------

# What are the best selling product lines accross all branches
SELECT `Product line`, SUM(Total) AS total_sales
FROM sp_sales
GROUP BY `Product line`
ORDER BY total_sales DESC;

# Sports and Travel is the most sold Product line accross all branches (bar chart comparing product lines)
#---------------------------

# Best selling product lines on specific Branch (A, B, C)
SELECT Branch, `Product line`, SUM(Total) AS total_sales
FROM sp_sales
WHERE Branch = "B"
GROUP BY `Product line`
ORDER BY total_sales DESC;

# (Plot bar chart with each category for each Branch)
#---------------------------

### CUSTOMER BEHAVIOR

# Total Sales comparing Member vs Normal customers and the percentage in total sales
SELECT `Customer type`, SUM(Total) AS total_sales, 
SUM(Total) / (SELECT SUM(Total) FROM sp_sales) *100 AS perc_rep
FROM sp_sales
GROUP BY `Customer type`
ORDER BY total_sales DESC;

# Percentage difference in sales for Members and Not Members
WITH customer_sales AS (
    SELECT 
        `Customer type`, 
        SUM(Total) AS total_sales
    FROM sp_sales
    GROUP BY `Customer type`
)
SELECT 
    MAX(`Customer type`) AS HigherCustomerType, -- Customer type with higher total sales
    MIN(`Customer type`) AS LowerCustomerType, -- Customer type with lower total sales
    MAX(total_sales) AS HigherSales, -- Higher total sales amount
    MIN(total_sales) AS LowerSales, -- Lower total sales amount
    ROUND((MAX(total_sales) - MIN(total_sales)) / MAX(total_sales) * 100, 2) AS percentage_diff
FROM customer_sales;

# We can also just get a quick look at the Percentage Difference
WITH customer_sales AS (
    SELECT 
        `Customer type`, 
        SUM(Total) AS total_sales
    FROM sp_sales
    GROUP BY `Customer type`)
SELECT 
	ROUND((MAX(total_sales) - MIN(total_sales)) / MAX(total_sales)*100, 2) AS percentage_difference
FROM customer_sales;

# We can see that MEMBERS represent 3.34% more than NOT MEMBERS
#--------------------

# Members and Not members best performing product lines
SELECT `Customer type`, `Product line`, SUM(Total) AS total_sales
FROM sp_sales
WHERE `Customer type` = "Member"
GROUP BY `Product line`
ORDER BY total_sales DESC;

SELECT `Customer type`, `Product line`, SUM(Total) AS total_sales
FROM sp_sales
WHERE `Customer type` = "Normal"
GROUP BY `Product line`
ORDER BY total_sales DESC;

# Electronic accessories is the Lowest Performing product line for members, while it is the best performing product line for 
# normal consumers. Interesting insight to analyze. 
#--------------------

### TREND ANALYSIS

# What are total sales by month accross all branches?
SELECT 
DATE_FORMAT(STR_TO_DATE(`Date`, '%m/%d/%Y'), '%M %Y') AS month,
SUM(`Total`) as monthly_sales
FROM sp_sales
GROUP BY month
ORDER BY month DESC;

# What branch performs the best each month?
WITH monthly_sales AS (
    SELECT 
        DATE_FORMAT(STR_TO_DATE(`Date`, '%m/%d/%Y'), '%M %Y') AS month,
        `Branch`, 
        SUM(`Total`) AS total_sales 
    FROM sp_sales
    GROUP BY month, `Branch`
)
SELECT 
    month, 
    Branch, 
    total_sales
FROM monthly_sales
WHERE (month, total_sales) IN (
    SELECT 
        month, 
        MAX(total_sales)
    FROM monthly_sales
    GROUP BY month
)
ORDER BY STR_TO_DATE(month, '%M %Y');

#----------------------

### Advanced Analysis 

# Is there a correlation between the product price and the rating?
SELECT 
	AVG(`Rating`) AS avg_rating,
    AVG(`Unit price`) AS avg_price,
    `Product line`
FROM sp_sales
GROUP BY `Product line`;

# There doesn't seem to be any increase in average rating with the increase of average price

#----------------------


# What is the average product rating on each branch?
SELECT 
	`Branch`,
    AVG(`Rating`) AS avg_rating,
    AVG(`Unit price`) AS avg_price
FROM sp_sales
GROUP BY `Branch`;

# While the rating remains almost the same accross all branches
# Branch B seems to be underperforming the 7 point mark
 

