Hi guys, this repository contains 15 SQL adhoc questions in https://dataset.xomdata.com/. For each question, I explain the main idea behind my solution.



The dataset has 4 main table: retails.customers, retails.products, retails.sales, retails.stores.



Question 1: Calculate total number of orders in 2020

\-I see order\_number column on retails.sales so I use COUNT function to solve this, but be careful with duplicate data because on retails.sales, and I filter sales to 2020.



Question 2: List product categories

\-I use retails.products to solve this question, use COUNT with GROUP BY category to show the total number of products each category.



Question 3: Top 10 cities with the most customers

\-I group customers by country, state, and city, count the customers in each location, and return the 10 locations with the highest counts.



Question 4: Revenue in December 2020

\-Because retails.sales has quantity column and retails.products has unit\_price\_usd column, so i use JOIN function to merge it to calculate the revenue.

\-Attention at the question - calculate in December 2020 so we must use SUM function outside revenue calculation suchs as SUM(quantity \* unit\_price\_usd) and use filter function "WHERE" to define data in December 2020.



Question 5: Number of stores by country
-I group stores by country and count the stores in each group.



Question 6: Top 5 best-selling products in each category

\-I join sales with products and sum the quantity sold for each product. Then I use ROW\_NUMBER() PARTITION BY category to number products within each category by quantity sold, and then I just use WHERE and ORDER BY function to sort the top 5 best selling each category.



Question 7: Gross margin by subcategory

\-I use retails.products and calculate gross margin by using AVG function for unit\_price\_usd and unit\_cost\_usd columns for each subcategory.

\-And this question requires show subcategories which have min 10 products to show the meaning output, so I use HAVING function, why I don't use WHERE function because WHERE is run before GROUP BY and HAVING run after GROUP BY function run, so I can group by subcategory first and then sort the condition later.



Question 8: Average delivery time by country

\-This question requires calculate delivery time by country, so I will use retails.sales and retails.customers to solve it (but carefully with the duplicated data).

\-We can use ROW\_NUMBER partition by order number to highlight the frequency of the same data instead of using DISTINCT function, because of optimizer query. (Output will show the rank of each order number), carefully with the NULL delivery\_date.

\-And then when I completely create the logic CTE, JOIN this cte with retails.customer and calculate the avg delivery days by DATEDIFF and AVG function, use WHERE function to select the order\_number with the ROW\_NUMBER = 1 (To avoid duplicate data).



Question 9: VIP customer per country

\-To check the VIP customer per country in 2020, lets make some logic CTE.

\-I will create the first CTE to show the details customer information with spending (quantity and product's price) of them.

\-The second CTE, I calculate the total\_spending for each customer and RANK them by ROW\_NUMBER partition by each country in 2020 based on the first CTE.

\-After these calculation, the second CTE will show the ranking customer spending of each country and I pick the highest spending customer for each country by WHERE function.



Question 10: Zombie products (never sold)

\-To solve this problem, I use LEFT JOIN with retails.products and retails.sales to and add sort condition by using WHERE this product IS NULL.



Question 11: Monthly revenue + cumulative revenue over 24 months

\-I will find the lasted updated day (convert it into month format) in the retails.sales, and then can calculate monthly revenue from the lasted updated day to the 23 months before and then cumulative revenue by using SUM function with ROW BETWEEN (window function) from the first month to the current month.



Question 12: Cohort retention by first\_purchase year

\-I find the first year bought by customer and then calculate the difference with the next years and first year.

\-Then, I find the total customers who buy products at the first purchase year (and sort the different of the first year with the next year =1,2,3 - one, two, three year later) and then calculate the % retention of customers on these years.

Question 13: Revenue per m2 of store, ranked within country

\-I will calculate the total revenue in the offline store for each store in 2020, and I calculate the ratio between revenue and square\_meters.

\-And then I use NTILE(4) to divide it into 4 groups.



Question 14: Store cannibalization
-First, I create a new CTE which show the old and new store by JOIN the same table together, the time open new store > time open old store at least 6 months

\-Then I create a logic CTE which calculate the revenue of old store within 6 months before new store open and the revenue of old store within 6 months after new store open and calculate the decrease pct of revenue between before and after revenue.
- Sort store which has the revenue after lower 15% more than revenue before and choose only store just open within 6 months after new store open.

Question 15: Products frequently bought together

\-First, I'm going to remove duplicated data of retails.sales, and then count the total order number of customer (careful with duplicated order number)

\-After that, I create a new table which can show the product a, b and the times appear together of us

\-When I have cte about remove duplicated data, total order number, and time appear together of products, I will join them into new table and calculate the ratio to total number of orders.


