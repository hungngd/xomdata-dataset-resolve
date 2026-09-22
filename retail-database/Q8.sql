-- Q8: Average delivery time by country
WITH detail_delivered_order AS (
	SELECT 
		order_number,
		customer_key,
		order_date,
		delivery_date,
		ROW_NUMBER() OVER (PARTITION BY customer_key, order_number ORDER BY order_date) AS rn
	FROM retails.sales 
	WHERE delivery_date IS NOT NULL
)
SELECT
	c.country,
	COUNT(*) AS no_of_delivered_orders,
	CAST(
		AVG(1.0 * DATEDIFF(day, do.order_date, do.delivery_date)) 
		AS DECIMAL (10,2)
	) AS avg_no_days
FROM detail_delivered_order do
INNER JOIN retails.customers c
	ON do.customer_key = c.customer_key
WHERE do.rn = 1
GROUP BY c.country
ORDER BY avg_no_days DESC