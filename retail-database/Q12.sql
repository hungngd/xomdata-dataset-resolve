-- Q12: Cohort retention by first_purchase year
WITH first_y_customers AS (
	SELECT
		customer_key,
		MIN(YEAR(order_date)) AS first_year
	FROM retails.sales
	GROUP BY customer_key
),
year_after_cal AS (
	SELECT
		f.customer_key,
		f.first_year, 
		YEAR(s.order_date) - f.first_year AS year_after
	FROM first_y_customers f
	INNER JOIN retails.sales s
		ON f.customer_key = s.customer_key
	GROUP BY f.customer_key, f.first_year, YEAR(s.order_date) - f.first_year
),
size_of_customer AS(
	SELECT
		first_year,
		year_after,
		COUNT(*) AS no_of_customers
	FROM year_after_cal
	WHERE year_after BETWEEN 0 AND 3
	GROUP BY first_year, year_after
)
SELECT
	first_year,
	year_after,
	no_of_customers,
	CAST((no_of_customers *100.0) / FIRST_VALUE(no_of_customers) OVER (PARTITION BY first_year ORDER BY year_after) AS DECIMAL(10,2)) AS retention_pct
FROM size_of_customer
ORDER BY first_year, year_after