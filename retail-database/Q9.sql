-- Q9: VIP customer per country
WITH spending_customers AS (
	SELECT	
		c.name,
		c.country,
		p.unit_price_usd,
		s.quantity,
		order_date
	FROM retails.customers c
	INNER JOIN retails.sales s
		ON c.customer_key = s.customer_key
	INNER JOIN retails.products p
		ON p.product_key = s.product_key
),
	ranking_customer AS (
	SELECT 
		country, 
		name,
		SUM(quantity * unit_price_usd) AS total_spend,
		ROW_NUMBER() OVER (PARTITION BY country ORDER BY SUM(quantity * unit_price_usd) DESC) AS rank
	FROM spending_customers
	WHERE order_date >= '2020-01-01' AND order_date <= '2020-12-31'
	GROUP BY country,name
)
SELECT
	country,
	name, 
	total_spend
FROM ranking_customer
WHERE rank = 1
ORDER BY total_spend DESC
