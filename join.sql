SELECT r.name region, sr.name sales_reps, a.name accounts
FROM region r
JOIN sales_reps sr
ON r.id = sr.region_id
JOIN accounts a
ON sr.id = a.sales_rep_id
AND r.name = 'Midwest'