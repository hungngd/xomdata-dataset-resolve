-- Q13: Revenue per m2 of store, ranked within country
WITH detail_rev_per_store AS (
	SELECT
		SUM(p.unit_price_usd * s.quantity) AS revenue,
		st.store_key,
		st.country,
		st.square_meters
	FROM retails.products p 
	INNER JOIN retails.sales s
		ON p.product_key = s.product_key
	INNER JOIN retails.stores st
		ON s.store_key = st.store_key
	WHERE st.square_meters IS NOT NULL 
		AND s.order_date >= '2020-01-01'
		AND s.order_date <= '2020-12-31'
	GROUP BY country, st.store_key, st.square_meters
)
SELECT
	store_key,
	country,
	CAST(revenue / NULLIF(square_meters,0) AS DECIMAL (10,2)) AS rev_per_m2,
	NTILE(4) OVER ( PARTITION BY country ORDER BY revenue / NULLIF(square_meters,0) DESC) AS rev_quartile
FROM detail_rev_per_store
ORDER BY country, rev_quartile, rev_per_m2 DESC