-- Q3: Top 10 cities with the most customers
SELECT TOP 10
city,
state,
country,
COUNT(*) AS no_of_customers
FROM retails.customers
GROUP BY country, state, city
ORDER BY COUNT(*) DESC