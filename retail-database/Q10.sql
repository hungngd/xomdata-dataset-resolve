-- Q10: Zombie products (never sold)
SELECT	DISTINCT
	p.product_key,
	p.product_name,
	p.brand,
	p.category
FROM retails.products p
LEFT JOIN retails.sales s
	ON p.product_key = s.product_key
WHERE s.product_key IS NULL
ORDER BY product_name, brand,category