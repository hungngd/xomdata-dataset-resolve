-- Q14: Store cannibalization
WITH pair_stores AS (
SELECT 
	old_store.store_key AS old_store,
	new_store.store_key AS new_store,
	old_store.country,
	old_store.open_date AS old_store_open_date,
	new_store.open_date AS new_store_open_date
FROM retails.stores old_store
INNER JOIN retails.stores new_store
	ON old_store.country = new_store.country
	AND new_store.open_date >= DATEADD(month, 6, old_store.open_date)
),
	cal_rev AS(
	SELECT
		p.old_store,
		p.new_store,
		p.country,
		p.new_store_open_date,
		SUM(
			CASE
				WHEN s.order_date >= DATEADD(month, -6, p.new_store_open_date)
				AND s.order_date < p.new_store_open_date
					THEN s.quantity * rp.unit_price_usd
				ELSE 0
			END
		) AS revenue_before,
		SUM(
			CASE 
				WHEN s.order_date < DATEADD(month, 6, p.new_store_open_date)
				AND s.order_date >= p.new_store_open_date
					THEN s.quantity * rp.unit_price_usd
				ELSE 0
			END
		) AS revenue_after
	FROM pair_stores p 
	LEFT JOIN retails.sales s
		ON s.store_key = p.old_store
	LEFT JOIN retails.products rp
		ON rp.product_key = s.product_key
	GROUP BY p.old_store, p.new_store, p.country, p.new_store_open_date
)
SELECT
	old_store,
	new_store,
	country,
	new_store_open_date,
	revenue_before,
	revenue_after,
	CAST((revenue_before - revenue_after) *100.0 / revenue_before AS DECIMAL (10,2)) AS decrease_pct
FROM cal_rev
WHERE revenue_before > 0
	AND revenue_after < revenue_before * 0.85
ORDER BY decrease_pct, old_store, new_store