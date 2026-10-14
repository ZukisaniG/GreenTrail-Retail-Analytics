-- GreenTrail: validation checks for MySQL 8.0
-- Run these SELECT queries after importing the full dataset.
USE greentrail_retail;

-- 1. Revenue reconciliation: difference should be 0.00.
SELECT
  (SELECT ROUND(SUM(transaction_total_usd),2) FROM transactions) AS transaction_revenue,
  (SELECT ROUND(SUM(quantity * unit_price_paid_usd),2) FROM transaction_lines) AS line_revenue,
  (SELECT ROUND(SUM(transaction_total_usd),2) FROM transactions) -
  (SELECT ROUND(SUM(quantity * unit_price_paid_usd),2) FROM transaction_lines) AS revenue_difference;

-- 2. Confirm zero stockout limitation.
SELECT COUNT(*) AS inventory_rows,
       SUM(CASE WHEN stockout_days > 0 THEN 1 ELSE 0 END) AS rows_with_stockouts,
       SUM(stockout_days) AS total_stockout_days
FROM monthly_inventory;

-- 3. Confirm campaign costs have one row per campaign.
SELECT COUNT(*) AS campaign_cost_records,
       COUNT(DISTINCT promotion_id) AS campaigns_with_costs
FROM campaign_costs;

-- 4. Find orphaned transaction lines (expected: 0).
SELECT COUNT(*) AS orphaned_transaction_lines
FROM transaction_lines tl
LEFT JOIN transactions t ON tl.transaction_id = t.transaction_id
WHERE t.transaction_id IS NULL;

-- 5. Date range and transaction count.
SELECT MIN(transaction_date) AS first_date,
       MAX(transaction_date) AS last_date,
       COUNT(*) AS transactions
FROM transactions;
