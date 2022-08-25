-- Udacity SQL queries

-- 1 Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, sr.name sales_reps, a.name accounts
FROM region r
JOIN sales_reps sr
ON r.id = sr.region_id
JOIN accounts a
ON sr.id = a.sales_rep_id
AND r.name = 'Midwest';
-- AND is similar to WHERE but the difference is it's executed within the JOIN not after.


-- 2 Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a first name starting with S and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, sr.name sales_reps, a.name accounts
FROM region r
JOIN sales_reps sr
ON r.id = sr.region_id
JOIN accounts a
ON sr.id = a.sales_rep_id
AND r.name = 'Midwest' AND sr.name LIKE 'S%'
ORDER BY a.name;


-- 3 Provide a table that provides the region for each sales_rep along with their associated accounts. This time only for accounts where the sales rep has a last name starting with K and in the Midwest region. Your final table should include three columns: the region name, the sales rep name, and the account name. Sort the accounts alphabetically (A-Z) according to account name.
SELECT r.name region, sr.name sales_reps, a.name accounts
FROM region r
JOIN sales_reps sr
ON r.id = sr.region_id
JOIN accounts a
ON sr.id = a.sales_rep_id
AND r.name = 'Midwest' AND sr.name LIKE '% K%'
ORDER BY a.name;
-- Space before the K '% K%' to get last name that starts with K


-- 4 Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100. Your final table should have 3 columns: region name, account name, and unit price. In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).
SELECT r.name region, a.name accounts, o.total_amt_usd/o.total orders
FROM region r
JOIN sales_reps sr
ON r.id = sr.region_id
JOIN accounts a
ON sr.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
AND o.standard_qty > 100
ORDER BY a.name;


-- 5 Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
SELECT r.name region, a.name accounts, o.total_amt_usd/o.total orders
FROM region r
JOIN sales_reps sr
ON r.id = sr.region_id
JOIN accounts a
ON sr.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
AND o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY o.total_amt_usd/(o.total+0.01);


-- 6 Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).
SELECT r.name region, a.name accounts, o.total_amt_usd/o.total orders
FROM region r
JOIN sales_reps sr
ON r.id = sr.region_id
JOIN accounts a
ON sr.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
AND o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY o.total_amt_usd/(o.total+0.01) DESC;


-- 7 What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values.
SELECT we.channel web_events, a.name
FROM web_events we
JOIN accounts a
ON we.account_id = a.id
WHERE account_id = 1001


-- 8 Find all the orders that occurred in 2015. Your final table should have 4 columns: occurred_at, account name, order total, and order total_amt_usd.
SELECT a.name, o.total, o.total_amt_usd, o.occurred_at
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '01-01-2015' AND '01-01-2016'



-- COUNT SUM NULL ETC
SELECT SUM(poster_qty) AS poster
FROM orders;

SELECT SUM(standard_qty) 
FROM orders;

SELECT SUM(total_amt_usd)
FROM orders;

SELECT standard_amt_usd + gloss_amt_usd AS total_standard_gloss
FROM orders;

SELECT SUM(standard_amt_usd)/SUM(standard_qty) AS total_standard
FROM orders;

SELECT MIN(occurred_at)
FROM orders

SELECT occurred_at 
FROM orders 
ORDER BY occurred_at
LIMIT 1;

SELECT MAX(occurred_at)
FROM web_events

SELECT occurred_at
FROM web_events
ORDER BY occurred_at DESC
LIMIT 1;

SELECT AVG(standard_amt_usd ) mean_standard, AVG(standard_qty) mean_standard_usd, AVG(gloss_amt_usd) mean_gloss, AVG(gloss_qty) mean_gloss_usd, AVG(poster_qty) mean_poster, AVG(poster_amt_usd) mean_poster_usd
FROM orders

-- median
-- Via the video, you might be interested in how to calculate the MEDIAN. Though this is more advanced than what we have covered so far try finding - what is the MEDIAN total_usd spent on all orders? Note, this is more advanced than the topics we have covered thus far to build a general solution, but we can hard code a solution in the following way.
SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

-- GROUP BY 

-- 1. Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT a.name, o.occurred_at
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY occurred_at
LIMIT 1;

-- 2. Find the total sales in usd for each account. You should include two columns - the total sales for each company's orders in usd and the company name.
SELECT a.name, SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a. name;

-- 3. Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event? Your query should return only three values - the date, channel, and account name.
SELECT we.occurred_at, we.channel, a.name
FROM web_events we
JOIN accounts a
ON a.id = we.account_id
ORDER BY we.occurred_at DESC
LIMIT 1;

-- 4. Find the total number of times each type of channel from the web_events was used. Your final table should have two columns - the channel and the number of times the channel was used.
SELECT w.channel, COUNT(*)
FROM web_events w
GROUP BY w.channel;

-- 5. Who was the primary contact associated with the earliest web_event?
SELECT a.primary_poc, we.occurred_at
FROM accounts a
JOIN web_events we
ON a.id = we.account_id
ORDER BY we.occurred_at
LIMIT 1;

-- 6. What was the smallest order placed by each account in terms of total usd. Provide only two columns - the account name and the total usd. Order from smallest dollar amounts to largest.
SELECT a.name, MIN(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY MIN(o.total_amt_usd)

-- 7. Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT r.name, COUNT(sr.*)
FROM region r
JOIN sales_reps sr
ON r.id = sr.region_id
GROUP BY r.name;
ORDER BY COUNT(sr*)

-- GROUP BY 2

-- 1. For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account.
SELECT a.name, AVG(o.standard_qty) AS standard, AVG(o.gloss_qty) AS gloss, AVG(o.poster_qty) AS poster
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name

-- 2. For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
SELECT a.name, AVG(o.standard_amt_usd) AS standard, AVG(o.gloss_amt_usd) AS gloss, AVG(o.poster_amt_usd) AS poster
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name

-- 3. Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT we.channel, COUNT(*), sr.name
FROM sales_reps sr
JOIN accounts a
ON a.sales_rep_id = sr.id
JOIN web_events we
ON a.id = we.account_id
GROUP BY we.channel, sr.name
ORDER BY COUNT(*) DESC

-- 4. Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT we.channel, COUNT(*), r.name
FROM region r
JOIN sales_reps sr
ON r.id = sr.region_id
JOIN accounts a
ON a.sales_rep_id = sr.id
JOIN web_events we
ON a.id = we.account_id
GROUP BY we.channel, r.name
ORDER BY COUNT(*) DESC

-- HAVING
-- in the following queries COUNT(*) is the count of whatever is in the FROM
SELECT COUNT(*), sr.id, sr.name
FROM accounts a
JOIN sales_reps sr
ON sr.id = a.sales_rep_id
GROUP BY sr.id, sr.name
HAVING COUNT(*) > 5
ORDER BY COUNT(*) DESC

SELECT COUNT(*), a.name
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
HAVING COUNT(*) > 20
ORDER BY COUNT(*) DESC

SELECT SUM(o.total_amt_usd), a.name
FROM orders o
JOIN accounts a
ON a.id = o.account_id
GROUP BY a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY COUNT(*) DESC

-- DATE examples
-- The difference between TRUNC and PART is TRUNC will organize dates by month for ex but PART would combine all of the months. In othe words if there were 5 years of dates and you used TRUN there would be 5 January's but with PART there would only be one.
SELECT DATE_TRUNC('year', occurred_at) AS year, SUM(total_amt_usd)
FROM orders
GROUP BY year
ORDER BY year

SELECT DATE_PART('month', occurred_at) AS month, SUM(total_amt_usd) AS total
FROM orders
GROUP BY month
ORDER BY total DESC

SELECT DATE_TRUNC('month', occurred_at) AS month, SUM(gloss_amt_usd) AS total
FROM orders
GROUP BY month
ORDER BY total DESC

-- CASE
-- 1. Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
SELECT CASE WHEN SUM(o.total_amt_usd) >= 3000 THEN 'large' ELSE 'small' END AS ord, a.id, o.total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, o.total_amt_usd

-- 2. Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
SELECT CASE WHEN SUM(o.total_amt_usd) >= 2000 THEN 'At Least 2000' 
WHEN SUM(o.total_amt_usd) >= 1000 AND SUM(o.total_amt_usd) < 2000 THEN 'Between 1000 and 2000' ELSE 'Less than 1000' END AS category, a.name, o.total_amt_usd, a.name
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name, o.total_amt_usd

--  3. We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.
SELECT CASE WHEN SUM(o.total_amt_usd) >= 200000 THEN 'greater than 200,000' 
WHEN SUM(o.total_amt_usd) >= 100000 AND SUM(o.total_amt_usd) < 200000 THEN 'Between 100,000 and 200,000' ELSE 'Less than 100,000' END AS category, a.name, SUM(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 2

-- 4. We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.
SELECT a.name, SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
     ELSE 'low' END AS customer_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at > '2015-12-31' 
GROUP BY 1
ORDER BY 2 DESC;

-- 5. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.
SELECT s.name, COUNT(*) num_ords,
     CASE WHEN COUNT(*) > 200 THEN 'top'
     ELSE 'not' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 2 DESC;

-- 6. The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!
SELECT s.name, COUNT(*) num_ords, SUM(total_amt_usd) total, 
     CASE WHEN COUNT(*) > 200 AND SUM(total_amt_usd) > 75000 THEN 'top'
     WHEN COUNT(*) BETWEEN 150 AND 200 AND SUM(total_amt_usd) > 50000 THEN 'middle'
     ELSE 'low' END AS sales_rep_level
FROM orders o
JOIN accounts a
ON o.account_id = a.id 
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC;

