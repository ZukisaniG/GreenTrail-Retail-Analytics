-- GreenTrail Outdoors | Module 02: MySQL 8.0+ relational schema
-- Source: GreenTrail_Expanded Dataset Option C
-- Creates tables only; no records are imported in this step.
-- Original 2023 historical observations stay in their own separate table.
CREATE DATABASE IF NOT EXISTS greentrail_retail CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE greentrail_retail;

CREATE TABLE IF NOT EXISTS original_promotion_observations (
  store_id INT NOT NULL,
  location VARCHAR(120),
  store_size_sqft INT,
  store_type VARCHAR(40),
  promotion_id INT NOT NULL,
  promotion_type VARCHAR(60),
  start_date DATE,
  end_date DATE,
  weekly_sales_during DECIMAL(14,2),
  weekly_sales_before DECIMAL(14,2),
  weekly_sales_after DECIMAL(14,2),
  avg_daily_visits_during DECIMAL(12,2),
  avg_daily_visits_before DECIMAL(12,2),
  avg_daily_visits_after DECIMAL(12,2),
  record_origin VARCHAR(50) NOT NULL,
  PRIMARY KEY (store_id, promotion_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS stores (
  store_id INT NOT NULL PRIMARY KEY,
  city VARCHAR(120),
  state VARCHAR(20),
  region VARCHAR(50),
  store_type VARCHAR(40),
  store_size_sqft INT,
  opening_date DATE,
  is_original_store TINYINT(1),
  record_origin VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS products (
  product_id INT NOT NULL PRIMARY KEY,
  sku VARCHAR(30),
  product_name VARCHAR(200),
  category VARCHAR(80),
  unit_price DECIMAL(12,2),
  unit_cost DECIMAL(12,2),
  sustainable_flag TINYINT(1),
  sustainability_score INT,
  record_origin VARCHAR(50),
  UNIQUE KEY uq_products_sku (sku)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS customer_segments (
  segment_id INT NOT NULL PRIMARY KEY,
  segment_name VARCHAR(100),
  description VARCHAR(500),
  record_origin VARCHAR(50)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS promotions (
  promotion_id INT NOT NULL PRIMARY KEY,
  promotion_type VARCHAR(60),
  start_date DATE,
  end_date DATE,
  discount_rate DECIMAL(8,4),
  budget_usd DECIMAL(14,2),
  objective VARCHAR(500),
  record_origin VARCHAR(50),
  INDEX idx_promotions_dates (start_date, end_date)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS store_promotion_assignments (
  promotion_id INT NOT NULL,
  store_id INT NOT NULL,
  assignment_group VARCHAR(20),
  assignment_method VARCHAR(80),
  record_origin VARCHAR(50),
  PRIMARY KEY (promotion_id, store_id),
  INDEX idx_assign_store (store_id),
  CONSTRAINT fk_assign_promotion FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id),
  CONSTRAINT fk_assign_store FOREIGN KEY (store_id) REFERENCES stores(store_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS transactions (
  transaction_id BIGINT NOT NULL PRIMARY KEY,
  store_id INT NOT NULL,
  transaction_date DATE,
  segment_id INT,
  promotion_id INT NULL,
  transaction_total_usd DECIMAL(14,2),
  record_origin VARCHAR(50),
  INDEX idx_txn_store_date (store_id, transaction_date),
  INDEX idx_txn_segment (segment_id),
  INDEX idx_txn_promotion (promotion_id),
  CONSTRAINT fk_txn_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
  CONSTRAINT fk_txn_segment FOREIGN KEY (segment_id) REFERENCES customer_segments(segment_id),
  CONSTRAINT fk_txn_promotion FOREIGN KEY (promotion_id) REFERENCES promotions(promotion_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS transaction_lines (
  transaction_id BIGINT NOT NULL,
  line_number INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT,
  unit_price_paid_usd DECIMAL(12,2),
  unit_cost_usd DECIMAL(12,2),
  record_origin VARCHAR(50),
  PRIMARY KEY (transaction_id, line_number),
  INDEX idx_lines_product (product_id),
  CONSTRAINT fk_lines_txn FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
  CONSTRAINT fk_lines_product FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS monthly_inventory (
  store_id INT NOT NULL,
  product_id INT NOT NULL,
  `month` CHAR(7) NOT NULL,  -- YYYY-MM; intentional string, matches source CSV
  opening_units INT,
  received_units INT,
  sold_units INT,
  closing_units INT,
  stockout_days INT,
  record_origin VARCHAR(50),
  PRIMARY KEY (store_id, product_id, `month`),
  INDEX idx_inventory_product (product_id),
  CONSTRAINT fk_inventory_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
  CONSTRAINT fk_inventory_product FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS daily_store_traffic (
  store_id INT NOT NULL,
  `date` DATE NOT NULL,
  visits INT,
  record_origin VARCHAR(50),
  PRIMARY KEY (store_id, `date`),
  CONSTRAINT fk_traffic_store FOREIGN KEY (store_id) REFERENCES stores(store_id)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS campaign_costs (
  promotion_id INT NOT NULL,
  store_id INT NOT NULL,
  cost_usd DECIMAL(14,2),
  record_origin VARCHAR(50),
  PRIMARY KEY (promotion_id, store_id),
  CONSTRAINT fk_cost_assignment FOREIGN KEY (promotion_id, store_id)
    REFERENCES store_promotion_assignments(promotion_id, store_id)
) ENGINE=InnoDB;

-- Verify all 11 tables exist. Row counts are zero until Module 03 imports the CSV files.
SHOW TABLES;
SELECT COUNT(*) AS tables_created
FROM information_schema.tables
WHERE table_schema = 'greentrail_retail' AND table_type = 'BASE TABLE';
