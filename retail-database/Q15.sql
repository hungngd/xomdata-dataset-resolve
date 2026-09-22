-- Q15: Products frequently bought together
WITH distinct_order_products AS(
	SELECT DISTINCT	
		order_number,
		product_key
	FROM retails.sales 
),
count_orders AS(
	SELECT
		COUNT (DISTINCT order_number) AS total_orders
	FROM retails.sales
),
pairs AS(
	SELECT
		product_a.product_key AS product_a_key,
		product_b.product_key AS product_b_key,
		COUNT(*) AS time_together
	FROM distinct_order_products AS product_a
	INNER JOIN distinct_order_products AS product_b
		ON product_a.order_number = product_b.order_number
		AND product_a.product_key < product_b.product_key
	GROUP BY product_a.product_key, product_b.product_key
)
SELECT TOP 20
	a.product_name AS product_a,
	b.product_name AS product_b,
	p.time_together,
	CAST( p.time_together * 100.0 / c.total_orders  AS DECIMAL (10,4)) AS pct
FROM pairs p 
INNER JOIN retails.products AS a
	ON p.product_a_key = a.product_key
INNER JOIN retails.products AS b
	ON p.product_b_key = b.product_key
CROSS JOIN count_orders c
ORDER BY p.time_together DESC