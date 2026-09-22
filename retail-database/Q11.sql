-- Q11: Monthly revenue + cumulative revenue over 24 months
WITH max_date AS(
SELECT
	DATEADD(month, DATEDIFF(month, 0, MAX(order_date)), 0) AS lasted_date
FROM retails.sales
),
monthly_rev AS(
	SELECT
		DATEADD(month, DATEDIFF(month, 0, s.order_date),0) AS month,
		SUM(p.unit_price_usd * s.quantity) AS revenue
	FROM retails.products p
	INNER JOIN retails.sales s
		ON p.product_key = s.product_key
	CROSS JOIN max_date m
	WHERE s.order_date >= DATEADD(month, -23, m.lasted_date)
	GROUP BY DATEADD(month, DATEDIFF(month, 0, s.order_date),0) 
)
SELECT
	FORMAT(month, 'yyyy-MM') AS year_month,
	revenue,
	SUM(revenue) OVER (
		ORDER BY month ASC 
		ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
	) AS cumulative_rev
FROM monthly_rev
ORDER BY month