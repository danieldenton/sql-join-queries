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