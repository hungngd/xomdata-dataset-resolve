-- Q7: Gross margin by subcategory
SELECT
	subcategory,
	count(*) AS no_products,
	CAST(ROUND(AVG((unit_price_usd - unit_cost_usd)* 100.0 / unit_price_usd),2) AS DECIMAL(10,2)) AS margin_percent
FROM retails.products
GROUP BY subcategory
HAVING COUNT(*) >= 10
ORDER BY margin_percent DESC