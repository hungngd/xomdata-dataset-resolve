-- Q1: Total number of orders in 2020
SELECT 
COUNT(DISTINCT order_number) AS total_number_orders_2020
FROM retails.sales
WHERE YEAR(order_date) = 2020
