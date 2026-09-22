-- Q5: Number of stores by country
SELECT
	country,
	COUNT(*) AS number_of_store
FROM retails.stores
GROUP BY country
ORDER BY number_of_store DESC