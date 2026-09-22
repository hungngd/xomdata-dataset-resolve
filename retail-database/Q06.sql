-- Q6: Top 5 best-selling products in each category
WITH details_quantity_sold AS (
	SELECT
		p.product_name,
		p.category,
		SUM(s.quantity) AS total_quantity_sold,
		ROW_NUMBER() OVER (PARTITION BY category ORDER BY SUM(s.quantity) DESC) AS rank
	FROM retails.products p
	INNER JOIN retails.sales s
		ON p.product_key = s.product_key
	GROUP BY p.category, p.product_name
)
SELECT 
	product_name,
	category,
	total_quantity_sold,
	rank
FROM details_quantity_sold
WHERE rank <= 5
