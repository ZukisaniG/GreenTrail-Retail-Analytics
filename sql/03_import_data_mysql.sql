-- GreenTrail Outdoors | Module 03: MySQL 8.0 bulk import
-- 11 source tables. Keep the original 25 historical observations separate.
-- Requires 11 CSV files copied to C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/
-- Uses LOAD DATA INFILE (server-side), not LOCAL INFILE.
-- Execute once against empty tables; running again triggers duplicate-key errors.
-- Check server file access / secure_file_priv if ERROR 1290 or 13 occurs.

USE greentrail_retail;
SET SESSION sql_mode = 'STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION';

-- Import original_promotion_observations
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/original_promotion_observations.csv'
INTO TABLE `original_promotion_observations`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
  `store_id`,
  `location`,
  `store_size_sqft`,
  `store_type`,
  `promotion_id`,
  `promotion_type`,
  `start_date`,
  `end_date`,
  `weekly_sales_during`,
  `weekly_sales_before`,
  `weekly_sales_after`,
  `avg_daily_visits_during`,
  `avg_daily_visits_before`,
  `avg_daily_visits_after`,
  `record_origin`
);

-- Import stores
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/stores.csv'
INTO TABLE `stores`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
  `store_id`,
  `city`,
  `state`,
  `region`,
  `store_type`,
  `store_size_sqft`,
  `opening_date`,
  `is_original_store`,
  `record_origin`
);

-- Import products
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv'
INTO TABLE `products`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
  `product_id`,
  `sku`,
  `product_name`,
  `category`,
  `unit_price`,
  `unit_cost`,
  `sustainable_flag`,
  `sustainability_score`,
  `record_origin`
);

-- Import customer_segments
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer_segments.csv'
INTO TABLE `customer_segments`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
  `segment_id`,
  `segment_name`,
  `description`,
  `record_origin`
);

-- Import promotions
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/promotions.csv'
INTO TABLE `promotions`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
  `promotion_id`,
  `promotion_type`,
  `start_date`,
  `end_date`,
  `discount_rate`,
  `budget_usd`,
  `objective`,
  `record_origin`
);

-- Import store_promotion_assignments
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/store_promotion_assignments.csv'
INTO TABLE `store_promotion_assignments`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
  `promotion_id`,
  `store_id`,
  `assignment_group`,
  `assignment_method`,
  `record_origin`
);

-- Import transactions
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv'
INTO TABLE `transactions`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
  `transaction_id`,
  `store_id`,
  `transaction_date`,
  `segment_id`,
  @promotion_id,
  `transaction_total_usd`,
  `record_origin`
)
SET `promotion_id` = NULLIF(@promotion_id, '');

-- Import transaction_lines
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transaction_lines.csv'
INTO TABLE `transaction_lines`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
  `transaction_id`,
  `line_number`,
  `product_id`,
  `quantity`,
  `unit_price_paid_usd`,
  `unit_cost_usd`,
  `record_origin`
);

-- Import monthly_inventory
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/monthly_inventory.csv'
INTO TABLE `monthly_inventory`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
  `store_id`,
  `product_id`,
  `month`,
  `opening_units`,
  `received_units`,
  `sold_units`,
  `closing_units`,
  `stockout_days`,
  `record_origin`
);

-- Import daily_store_traffic
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/daily_store_traffic.csv'
INTO TABLE `daily_store_traffic`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
  `store_id`,
  `date`,
  `visits`,
  `record_origin`
);

-- Import campaign_costs
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/campaign_costs.csv'
INTO TABLE `campaign_costs`
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES
(
  `promotion_id`,
  `store_id`,
  `cost_usd`,
  `record_origin`
);

-- Validation: expected record counts
SELECT 'original_promotion_observations' AS table_name, COUNT(*) AS actual_rows, 25 AS expected_rows FROM original_promotion_observations
UNION ALL SELECT 'stores', COUNT(*), 150 FROM stores
UNION ALL SELECT 'products', COUNT(*), 120 FROM products
UNION ALL SELECT 'customer_segments', COUNT(*), 5 FROM customer_segments
UNION ALL SELECT 'promotions', COUNT(*), 650 FROM promotions
UNION ALL SELECT 'store_promotion_assignments', COUNT(*), 1300 FROM store_promotion_assignments
UNION ALL SELECT 'transactions', COUNT(*), 426602 FROM transactions
UNION ALL SELECT 'transaction_lines', COUNT(*), 682323 FROM transaction_lines
UNION ALL SELECT 'monthly_inventory', COUNT(*), 432000 FROM monthly_inventory
UNION ALL SELECT 'daily_store_traffic', COUNT(*), 109650 FROM daily_store_traffic
UNION ALL SELECT 'campaign_costs', COUNT(*), 650 FROM campaign_costs;

-- Sanity check: most transactions are not attached to a promotion
SELECT COUNT(*) AS total_transactions, SUM(promotion_id IS NULL) AS transactions_without_promotion FROM transactions;
