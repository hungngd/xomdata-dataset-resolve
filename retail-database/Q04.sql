-- Q4: Revenue in December 2020
SELECT
	SUM(p.unit_price_usd * s.quantity) AS total_revenue_Dec_2020
FROM retails.products p 
INNER JOIN retails.sales s 
	ON p.product_key = s.product_key
WHERE s.order_date >= '2020-12-1' 
	AND s.order_date <= '2020-12-31'
