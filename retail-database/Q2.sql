-- Q2: List product categories
SELECT
category,
COUNT(product_key) AS SKUs_each_category
FROM retails.products
GROUP BY category
ORDER BY category