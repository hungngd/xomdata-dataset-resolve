# Retail Database: 15 Ad Hoc SQL Questions

This repository contains my solutions to 15 ad hoc SQL questions on the [XomData platform](https://dataset.xomdata.com/). Each question has its own SQL file. Below, I briefly explain the idea behind each solution.

## Dataset

The retail database has four main tables: `retails.customers`, `retails.products`, `retails.sales`, and `retails.stores`.

## Questions and approaches


### 01. Calculate total number of orders in 2020

**File:** [`Q01.sql`](Q01.sql)

- I see order_number column on retails.sales so I use COUNT function to solve this, but be careful with duplicate data because on retails.sales, and I filter sales to 2020.

### 02. List product categories

**File:** [`Q02.sql`](Q02.sql)

- I use retails.products to solve this question, use COUNT with GROUP BY category to show the total number of products each category.

### 03. Top 10 cities with the most customers

**File:** [`Q03.sql`](Q03.sql)

- I group customers by country, state, and city, count the customers in each location, and return the 10 locations with the highest counts.

### 04. Revenue in December 2020

**File:** [`Q04.sql`](Q04.sql)

- Because retails.sales has quantity column and retails.products has unit_price_usd column, so i use JOIN function to merge it to calculate the revenue.
- Attention at the question - calculate in December 2020 so we must use SUM function outside revenue calculation suchs as SUM(quantity * unit_price_usd) and use filter function "WHERE" to define data in December 2020.

### 05. Number of stores by country

**File:** [`Q05.sql`](Q05.sql)

- I group stores by country and count the stores in each group.

### 06. Top 5 best-selling products in each category

**File:** [`Q06.sql`](Q06.sql)

- I join sales with products and sum the quantity sold for each product. Then I use ROW_NUMBER() PARTITION BY category to number products within each category by quantity sold, and then I just use WHERE and ORDER BY function to sort the top 5 best selling each category.

### 07. Gross margin by subcategory

**File:** [`Q07.sql`](Q07.sql)

- I use retails.products and calculate gross margin by using AVG function for unit_price_usd and unit_cost_usd columns for each subcategory.
- And this question requires show subcategories which have min 10 products to show the meaning output, so I use HAVING function, why I don't use WHERE function because WHERE is run before GROUP BY and HAVING run after GROUP BY function run, so I can group by subcategory first and then sort the condition later.

### 08. Average delivery time by country

**File:** [`Q08.sql`](Q08.sql)

- This question requires calculate delivery time by country, so I will use retails.sales and retails.customers to solve it (but carefully with the duplicated data).
- We can use ROW_NUMBER partition by order number to highlight the frequency of the same data instead of using DISTINCT function, because of optimizer query. (Output will show the rank of each order number), carefully with the NULL delivery_date.
- And then when I completely create the logic CTE, JOIN this cte with retails.customer and calculate the avg delivery days by DATEDIFF and AVG function, use WHERE function to select the order_number with the ROW_NUMBER = 1 (To avoid duplicate data).

### 09. VIP customer per country

**File:** [`Q09.sql`](Q09.sql)

- To check the VIP customer per country in 2020, lets make some logic CTE.
- I will create the first CTE to show the details customer information with spending (quantity and product's price) of them.
- The second CTE, I calculate the total_spending for each customer and RANK them by ROW_NUMBER partition by each country in 2020 based on the first CTE.
- After these calculation, the second CTE will show the ranking customer spending of each country and I pick the highest spending customer for each country by WHERE function.

### 10. Zombie products (never sold)

**File:** [`Q10.sql`](Q10.sql)

- To solve this problem, I use LEFT JOIN with retails.products and retails.sales to and add sort condition by using WHERE this product IS NULL.

### 11. Monthly revenue + cumulative revenue over 24 months

**File:** [`Q11.sql`](Q11.sql)

- I will find the lasted updated day (convert it into month format) in the retails.sales, and then can calculate monthly revenue from the lasted updated day to the 23 months before and then cumulative revenue by using SUM function with ROW BETWEEN (window function) from the first month to the current month.

### 12. Cohort retention by first_purchase year

**File:** [`Q12.sql`](Q12.sql)

- I find the first year bought by customer and then calculate the difference with the next years and first year.
- Then, I find the total customers who buy products at the first purchase year (and sort the different of the first year with the next year =1,2,3 - one, two, three year later) and then calculate the % retention of customers on these years.

### 13. Revenue per m2 of store, ranked within country

**File:** [`Q13.sql`](Q13.sql)

- I will calculate the total revenue in the offline store for each store in 2020, and I calculate the ratio between revenue and square_meters.
- And then I use NTILE(4) to divide it into 4 groups.

### 14. Store cannibalization

**File:** [`Q14.sql`](Q14.sql)

- First, I create a new CTE which show the old and new store by JOIN the same table together, the time open new store > time open old store at least 6 months
- Then I create a logic CTE which calculate the revenue of old store within 6 months before new store open and the revenue of old store within 6 months after new store open and calculate the decrease pct of revenue between before and after revenue.
- Sort store which has the revenue after lower 15% more than revenue before and choose only store just open within 6 months after new store open.

### 15. Products frequently bought together

**File:** [`Q15.sql`](Q15.sql)

- First, I'm going to remove duplicated data of retails.sales, and then count the total order number of customer (careful with duplicated order number)
- After that, I create a new table which can show the product a, b and the times appear together of us
- When I have cte about remove duplicated data, total order number, and time appear together of products, I will join them into new table and calculate the ratio to total number of orders.
