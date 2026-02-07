--PROJECT 1- Sales retail analysis--

CREATE TABLE Retail_Sales(transactions_id int primary key,
			sale_date date,
			sale_time time,
			customer_id int,
			gender varchar(10),
			age int,
			category varchar(15),
			quantity int,
			price_per_unit float,
			cogs float,
			total_sale float);


SELECT * FROM retail_sales
WHERE sale_date IS NULL
	or
	sale_time is null
	or 
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	cogs is null
	or
	total_sale is null

--DATA CLEANING--
DELETE FROM retail_sales
WHERE sale_date IS NULL
	or
	sale_time is null
	or 
	customer_id is null
	or
	gender is null
	or
	age is null
	or
	category is null
	or
	quantity is null
	or
	cogs is null
	or
	total_sale is null

--DATA EXPLORATION--
--Total sales figure--
SELECT COUNT(*)FROM retail_sales
--how many customer do we have--
SELECT COUNT(DISTINCT customer_id) from retail_sales
--Check all categories from our table--
SELECT DISTINCT category from retail_sales



--DATA ANALYSIS OR BUSINESS PROBLEMS--
--Write a query to retrive all columns from sales made on '2022-11-05'--
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--write a query to retrieve where cateogory is 'clothing' and quantity sold is more than 4 in the month of november 2022
SELECT * FROM retail_sales
WHERE category='Clothing'
AND TO_CHAR(sale_date,'yyyy-mm')='2022-11'
AND 
quantity>=4


--write a query to calculate the total sale and total orders of each category--
SELECT category,
  	SUM(total_sale) as net_sale,
	  COUNT(*) as total_orders
FROM retail_sales
GROUP BY category

--write a query to find the average age of customers who purchased items from the 'Beauty' category.--

SELECT ROUND(AVG(age),2) as Avg_age
FROM retail_sales
WHERE category='Beauty'

--write a query to find all the transaction where total_sales is greater than 1000

SELECT *
FROM retail_sales
WHERE total_sale>1000

--write a query to find the total number transacation(transaction_id) made by each gender in each category

SELECT category,
		gender,
     COUNT(*) AS total_transaction
FROM retail_sales
GROUP BY
gender,category
ORDER BY category

--write a query to calculate average sale of each month. find out best selling month in each year.
SELECT year,
       month,
	   avg_sale
FROM(

SELECT 
     EXTRACT(YEAR FROM sale_date) as year,
	 EXTRACT(MONTH FROM sale_date) as month,
	 AVG(total_sale) as avg_sale,
	 RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_Sale) DESC)
FROM retail_sales
GROUP BY 1,2 
)AS T1
WHERE RANK=1

--write a query to find out the top 5 customers based on highest total sales.

SELECT customer_id,
		SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5

--Write a query to find unique customer who purchased items from each category.

SELECT COUNT(DISTINCT(customer_id)),
			category
FROM retail_sales
GROUP BY 2

--Write a query to create shift and number of orders(Example Morning<=12,Afternoon between 12 & 17,Evening>17).
WITH hourly_sale
AS
(
SELECT *,
	CASE
	WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	ELSE 'Evening'
	END as Shift
FROM retail_sales
)
SELECT shift,
 		COUNT(*) AS total_orders
FROM hourly_sale
GROUP BY 1

--THANK YOU.
