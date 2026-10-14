
-- GreenTrail Outdoors | SQL Retail Analytics Portfolio
-- Data provenance: 25 original training observations, plus clearly labelled synthetic data.
-- Transaction data is a simulated POS sample (2024-2025); not verified client financials.
-- MySQL 8.0+

USE greentrail_retail;

SELECT
    COUNT(*) AS total_transactions,
    ROUND(SUM(transaction_total_usd), 2)
        AS total_revenue,
    ROUND(AVG(transaction_total_usd), 2)
        AS average_transaction_value
FROM transactions;

-- Analysis 2: Revenue performance by region

SELECT
    s.region,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.transaction_total_usd), 2)
        AS total_revenue,
    ROUND(AVG(t.transaction_total_usd), 2)
        AS average_transaction_value

FROM transactions t

JOIN stores s
    ON t.store_id = s.store_id

GROUP BY s.region

ORDER BY total_revenue DESC;

-- Analysis 3: Revenue per store by region

SELECT
    s.region,
    COUNT(DISTINCT s.store_id) AS total_stores,
    ROUND(SUM(t.transaction_total_usd), 2)
        AS total_revenue,
    ROUND(
        SUM(t.transaction_total_usd) /
        COUNT(DISTINCT s.store_id), 2
    ) AS revenue_per_store

FROM transactions t

JOIN stores s
    ON t.store_id = s.store_id

GROUP BY s.region

ORDER BY revenue_per_store DESC;

-- Analysis 4: Top 10 stores by revenue

SELECT
    s.store_id,
    s.region,
    s.store_type,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.transaction_total_usd), 2)
        AS total_revenue

FROM transactions t

JOIN stores s
    ON t.store_id = s.store_id

GROUP BY
    s.store_id,
    s.region,
    s.store_type

ORDER BY total_revenue DESC

LIMIT 10;

-- Analysis 5: Monthly revenue trends

SELECT
    YEAR(transaction_date) AS sales_year,
    MONTH(transaction_date) AS sales_month,
    COUNT(transaction_id) AS total_transactions,
    ROUND(SUM(transaction_total_usd), 2)
        AS total_revenue

FROM transactions

GROUP BY
    YEAR(transaction_date),
    MONTH(transaction_date)

ORDER BY
    sales_year,
    sales_month;

-- Analysis 6: Annual sales performance

SELECT
    YEAR(transaction_date) AS sales_year,
    COUNT(transaction_id) AS total_transactions,
    ROUND(SUM(transaction_total_usd), 2)
        AS total_revenue,
    ROUND(AVG(transaction_total_usd), 2)
        AS average_transaction_value

FROM transactions

GROUP BY YEAR(transaction_date)

ORDER BY sales_year;

-- Analysis 7: Revenue by store type

SELECT
    s.store_type,
    COUNT(DISTINCT s.store_id) AS total_stores,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.transaction_total_usd), 2)
        AS total_revenue,
    ROUND(
        SUM(t.transaction_total_usd) /
        COUNT(DISTINCT s.store_id), 2
    ) AS revenue_per_store

FROM transactions t

JOIN stores s
    ON t.store_id = s.store_id

GROUP BY s.store_type

ORDER BY revenue_per_store DESC;


-- Analysis 8: Revenue per square foot by store type

SELECT
    s.store_type,
    COUNT(*) AS total_stores,
    ROUND(SUM(sales.store_revenue), 2)
        AS total_revenue,
    ROUND(
        SUM(sales.store_revenue) /
        SUM(s.store_size_sqft), 2
    ) AS revenue_per_sqft

FROM stores s

JOIN (
    SELECT
        store_id,
        SUM(transaction_total_usd) AS store_revenue
    FROM transactions
    GROUP BY store_id
) sales
    ON s.store_id = sales.store_id

GROUP BY s.store_type

ORDER BY revenue_per_sqft DESC;

-- Analysis 9: Top 10 stores by revenue per square foot

SELECT
    s.store_id,
    s.region,
    s.store_type,
    s.store_size_sqft,
    ROUND(SUM(t.transaction_total_usd), 2)
        AS total_revenue,
    ROUND(
        SUM(t.transaction_total_usd) /
        s.store_size_sqft, 2
    ) AS revenue_per_sqft

FROM stores s

JOIN transactions t
    ON s.store_id = t.store_id

GROUP BY
    s.store_id,
    s.region,
    s.store_type,
    s.store_size_sqft

ORDER BY revenue_per_sqft DESC

LIMIT 10;

-- Analysis 10: Bottom 10 stores by total revenue

SELECT
    s.store_id,
    s.region,
    s.store_type,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.transaction_total_usd), 2)
        AS total_revenue

FROM stores s

JOIN transactions t
    ON s.store_id = t.store_id

GROUP BY
    s.store_id,
    s.region,
    s.store_type

ORDER BY total_revenue ASC

LIMIT 10;

-- Analysis 11: Revenue by product category

SELECT
    p.category,
    SUM(tl.quantity) AS units_sold,
    ROUND(
        SUM(tl.quantity * tl.unit_price_paid_usd), 2
    ) AS total_revenue

FROM transaction_lines tl

JOIN products p
    ON tl.product_id = p.product_id

GROUP BY p.category

ORDER BY total_revenue DESC;

-- Analysis 12: Top 10 products by revenue

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(tl.quantity) AS units_sold,
    ROUND(
        SUM(tl.quantity * tl.unit_price_paid_usd), 2
    ) AS total_revenue

FROM transaction_lines tl

JOIN products p
    ON tl.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name,
    p.category

ORDER BY total_revenue DESC

LIMIT 10;

-- Analysis 13: Gross profit by product category

SELECT
    p.category,

    ROUND(
        SUM(tl.quantity * tl.unit_price_paid_usd), 2
    ) AS total_revenue,

    ROUND(
        SUM(tl.quantity * tl.unit_cost_usd), 2
    ) AS total_cost,

    ROUND(
        SUM(
            tl.quantity *
            (tl.unit_price_paid_usd - tl.unit_cost_usd)
        ), 2
    ) AS gross_profit

FROM transaction_lines tl

JOIN products p
    ON tl.product_id = p.product_id

GROUP BY p.category

ORDER BY gross_profit DESC;

-- Analysis 14: Gross profit margin by category

SELECT
    p.category,

    ROUND(
        SUM(tl.quantity * tl.unit_price_paid_usd), 2
    ) AS total_revenue,

    ROUND(
        100 * SUM(
            tl.quantity *
            (tl.unit_price_paid_usd - tl.unit_cost_usd)
        ) /
        NULLIF(
            SUM(tl.quantity * tl.unit_price_paid_usd), 0
        ), 2
    ) AS gross_margin_pct

FROM transaction_lines tl

JOIN products p
    ON tl.product_id = p.product_id

GROUP BY p.category

ORDER BY gross_margin_pct DESC;

-- Analysis 15: Sustainable product performance

SELECT
    CASE
        WHEN p.sustainable_flag = 1
            THEN 'Sustainable'
        ELSE 'Non-Sustainable'
    END AS product_type,

    SUM(tl.quantity) AS units_sold,

    ROUND(
        SUM(tl.quantity * tl.unit_price_paid_usd), 2
    ) AS total_revenue,

    ROUND(
        SUM(
            tl.quantity *
            (tl.unit_price_paid_usd - tl.unit_cost_usd)
        ), 2
    ) AS gross_profit

FROM transaction_lines tl

JOIN products p
    ON tl.product_id = p.product_id

GROUP BY product_type

ORDER BY total_revenue DESC;

-- Analysis 16: Revenue by promotion type

SELECT
    p.promotion_type,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND(SUM(t.transaction_total_usd), 2)
        AS total_revenue,
    ROUND(AVG(t.transaction_total_usd), 2)
        AS average_transaction_value

FROM transactions t

JOIN promotions p
    ON t.promotion_id = p.promotion_id

GROUP BY p.promotion_type

ORDER BY total_revenue DESC;

-- Analysis 17: Promotional vs regular transactions

SELECT
    CASE
        WHEN promotion_id IS NOT NULL
            THEN 'Promotional'
        ELSE 'Non-Promotional'
    END AS transaction_type,

    COUNT(*) AS total_transactions,

    ROUND(SUM(transaction_total_usd), 2)
        AS total_revenue,

    ROUND(AVG(transaction_total_usd), 2)
        AS average_transaction_value

FROM transactions

GROUP BY transaction_type

ORDER BY total_revenue DESC;

-- Analysis 18: Campaign costs by promotion type

SELECT
    p.promotion_type,

    COUNT(DISTINCT p.promotion_id)
        AS total_campaigns,

    COUNT(*) AS campaign_cost_records,

    ROUND(SUM(c.cost_usd), 2)
        AS total_campaign_cost,

    ROUND(AVG(c.cost_usd), 2)
        AS average_cost_per_campaign

FROM campaign_costs c

JOIN promotions p
    ON c.promotion_id = p.promotion_id

GROUP BY p.promotion_type

ORDER BY total_campaign_cost DESC;

-- Analysis 19: Gross profit by promotion type

SELECT
    p.promotion_type,
    COUNT(DISTINCT t.transaction_id)
        AS total_transactions,

    ROUND(
        SUM(tl.quantity * tl.unit_price_paid_usd), 2
    ) AS total_revenue,

    ROUND(
        SUM(
            tl.quantity *
            (tl.unit_price_paid_usd - tl.unit_cost_usd)
        ), 2
    ) AS gross_profit

FROM transactions t

JOIN promotions p
    ON t.promotion_id = p.promotion_id

JOIN transaction_lines tl
    ON t.transaction_id = tl.transaction_id

GROUP BY p.promotion_type

ORDER BY gross_profit DESC;

-- Analysis 20: Revenue by customer segment

SELECT
    cs.segment_name,
    COUNT(t.transaction_id)
        AS total_transactions,

    ROUND(SUM(t.transaction_total_usd), 2)
        AS total_revenue

FROM transactions t

JOIN customer_segments cs
    ON t.segment_id = cs.segment_id

GROUP BY cs.segment_name

ORDER BY total_revenue DESC;

-- Analysis 21: Customer spending patterns

SELECT
    cs.segment_name,

    COUNT(t.transaction_id)
        AS total_transactions,

    ROUND(AVG(t.transaction_total_usd), 2)
        AS average_transaction_value,

    SUM(
        CASE
            WHEN t.promotion_id IS NOT NULL
                THEN 1
            ELSE 0
        END
    ) AS promotional_transactions

FROM transactions t

JOIN customer_segments cs
    ON t.segment_id = cs.segment_id

GROUP BY cs.segment_name

ORDER BY average_transaction_value DESC;

-- Analysis 22: Customer traffic by region
-- AVG(d.visits) is visits per store-day, not aggregate visits per region-day.

SELECT
    s.region,

    COUNT(DISTINCT s.store_id)
        AS total_stores,

    SUM(d.visits)
        AS total_visits,

    ROUND(AVG(d.visits), 2)
        AS average_visits_per_store_day

FROM daily_store_traffic d

JOIN stores s
    ON d.store_id = s.store_id

GROUP BY s.region

ORDER BY total_visits DESC;

-- Analysis 23: Top 10 products by units sold in inventory records
-- Dataset limitation: stockout_days is zero in all generated records.
-- Units sold are synthetic and reflect the generated transaction sample.

SELECT
    p.product_id,
    p.product_name,
    p.category,
    SUM(i.sold_units) AS total_units_sold,
    SUM(i.stockout_days) AS total_stockout_days

FROM monthly_inventory i

JOIN products p
    ON i.product_id = p.product_id

GROUP BY
    p.product_id,
    p.product_name,
    p.category

ORDER BY total_units_sold DESC

LIMIT 10;

-- Analysis 24: Closing inventory value by category

SELECT
    p.category,

    SUM(i.closing_units)
        AS total_closing_units,

    ROUND(
        SUM(i.closing_units * p.unit_cost), 2
    ) AS inventory_value

FROM monthly_inventory i

JOIN products p
    ON i.product_id = p.product_id

WHERE i.month = '2025-12'

GROUP BY p.category

ORDER BY inventory_value DESC;

-- Analysis 25: Executive KPI summary
-- Gross profit is calculated before campaign and operating expenses.

SELECT
    (SELECT COUNT(*)
     FROM stores) AS total_stores,

    (SELECT COUNT(*)
     FROM transactions) AS total_transactions,

    (SELECT ROUND(SUM(transaction_total_usd), 2)
     FROM transactions) AS total_revenue,

    (SELECT ROUND(AVG(transaction_total_usd), 2)
     FROM transactions) AS average_transaction_value,

    (SELECT ROUND(SUM(
         quantity * (unit_price_paid_usd - unit_cost_usd)
     ), 2)
     FROM transaction_lines) AS total_gross_profit,

    (SELECT COUNT(*)
     FROM promotions) AS total_campaigns;
