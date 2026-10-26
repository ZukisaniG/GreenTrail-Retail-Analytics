# GreenTrail Outdoors | Retail Analytics Portfolio Project

**SQL • Python • Power BI • Business Analysis**

An end-to-end retail analytics project exploring sales performance, profitability, customer behaviour, promotional activity and inventory management across a simulated 150-store outdoor retail business.

---

## About the Project

GreenTrail Outdoors is a fictional outdoor retail business used for this independent portfolio case study.

I developed this project to explore how data can support better business decisions. Rather than focusing only on sales figures, I wanted to understand what was driving performance across different parts of the business, which products and stores were contributing the most, and where management could potentially improve profitability.

The project began with a small retail promotions dataset containing 25 store observations. I subsequently worked with an expanded synthetic dataset covering 150 stores and two years of retail activity.

Using MySQL, Python and Power BI, I worked through the process of preparing the data, exploring business performance, developing analytical queries and presenting the findings through an interactive dashboard.

The final result is a four-page Power BI report supported by SQL analysis, Python exploratory work and documented business findings.

## Business Problem

Retail businesses often have access to large amounts of transaction data but still struggle to turn that information into useful decisions.

For GreenTrail, I focused on five questions:

1. How is the business performing in terms of revenue, profit and sales trends?
2. Which stores and regions are performing well, and which may require further investigation?
3. Which product categories contribute the most revenue and gross profit?
4. What can promotional activity tell us about sales, campaign spending and customer behaviour?
5. How can inventory and sustainability-related data support better business planning?

The objective was to build a clearer picture of retail performance and identify areas where management could make more informed decisions.

## Dataset Overview

The analysis uses an expanded synthetic retail dataset covering **January 2024 to December 2025**.

| Metric | Value |
|---|---:|
| Stores | 150 |
| Transactions | 426,602 |
| Transaction line items | 682,323 |
| Products | 120 |
| Simulated campaigns | 650 |
| Total Revenue | $89.02M |
| Gross Profit | $41.51M |
| Gross Margin | 46.64% |
| Analysis Period | 24 months |

The data covers store locations, customer segments, product categories, transactions, promotions, campaign costs, customer traffic and inventory.

The original 25-store training observations are retained separately from the expanded synthetic transactions.

**Note:** GreenTrail is a simulated business case. All financial figures and findings are for educational and portfolio purposes and do not represent real company performance.

---

## Project Approach

### 1. SQL — Data Exploration and Business Analysis

I used MySQL 8.0 to investigate the business from several angles.

This included designing and working with a relational database, joining tables, aggregating transactional data and comparing performance across different business dimensions.

The SQL work includes **25 analytical queries and five data-quality checks**.

The analysis covers:

- Overall revenue and transaction performance
- Monthly and annual sales trends
- Revenue by region and store type
- Top- and bottom-performing stores
- Product-category sales and gross profit
- Sustainable-product contributions
- Promotional activity and associated sales
- Customer spending patterns
- Inventory valuation and data limitations

The validation work included reconciling transaction revenue against transaction-line revenue and checking for orphaned transaction records.

One important lesson from this stage was that accurate calculations are only part of the process. The context behind a metric matters just as much, particularly when comparing stores of different sizes or evaluating promotional activity.

### 2. Python — Exploratory Data Analysis

Python was included as a complementary analytical tool to explore and validate patterns in the dataset.

The Jupyter notebook documents exploratory work using Pandas and supporting visualisations.

This part of the project provides another way of examining the data beyond SQL queries and helps build a more rounded analytical workflow.

The notebook is available in the [Python notebooks folder](python/notebooks/).

### 3. Power BI — Interactive Dashboard Development

I built a four-page Power BI dashboard to make the findings easier to explore and communicate.

The report combines DAX measures, relational data modelling, KPI cards, comparative charts and interactive filtering.

The dashboard is organised into four sections.

### Page 1 — Executive Overview

![GreenTrail Executive Overview](docs/screenshots/01_executive_overview.png)

The Executive Overview provides a high-level summary of the business.

It includes total revenue, gross profit, gross margin, transaction volumes and average transaction value, alongside monthly revenue trends and regional, category and customer-segment comparisons.

This page is intended to give management a quick understanding of overall performance before exploring individual business areas.

### Page 2 — Store Performance

![GreenTrail Store Performance](docs/screenshots/02_store_performance.png)

This page explores differences between individual stores and regions.

It compares the ten highest- and lowest-revenue stores, average revenue per store across regions and revenue generated per square foot by store type.

The focus is on distinguishing total sales performance from operational efficiency.

### Page 3 — Promotions Analysis

![GreenTrail Promotions Analysis](docs/screenshots/03_promotions_analysis.png)

The Promotions Analysis page examines sales and gross profit associated with different promotional types.

It also compares recorded campaign costs and the number of promotional versus non-promotional transactions.

A key consideration here is that revenue associated with a campaign is not necessarily revenue caused by that campaign. The analysis is descriptive and does not establish incremental sales or promotional return on investment.

### Page 4 — Customers & Inventory

![GreenTrail Customers and Inventory](docs/screenshots/04_customers_inventory.png)

The final dashboard page focuses on customer spending, sustainable products, inventory and individual product performance.

It includes average transaction value by customer segment, sustainable versus non-sustainable product revenue, closing inventory value by category and the ten highest-revenue products.

The inventory analysis uses December 2025 closing stock values rather than adding inventory balances across multiple periods.

---

## Key Findings

### 1. Revenue was relatively stable across the two years

GreenTrail generated approximately **$89.02 million** in simulated revenue over the 24-month period.

Revenue decreased slightly between 2024 and 2025, by approximately **0.33%**.

Although this is a small decline, it highlights the importance of looking beyond a single overall revenue figure and examining regional, product and transaction trends.

### 2. The highest-revenue region was not the most productive per store

The South generated approximately **$32.36 million** in revenue, making it the largest regional contributor.

However, the Midwest achieved the highest average revenue per store, at approximately **$681,498** over the two-year period, compared with **$539,409** in the South.

This demonstrates why comparisons should account for the number of stores rather than relying solely on total sales.

A useful next step would be to investigate whether differences in store size, traffic, location or product mix explain the regional performance gap.

### 3. Footwear led sales, while Camping achieved the strongest margins

Footwear generated approximately **$25.81 million** in revenue and **$12.05 million** in gross profit, making it the largest category by both measures.

Camping recorded the highest category gross margin at approximately **48.75%**.

This suggests an opportunity to investigate camping-related product bundles or category-specific promotions, while considering the potential impact of discounts on profitability.

### 4. Sustainable products accounted for a significant share of sales

Products classified as sustainable contributed approximately **64.3% of total revenue**, equivalent to $57.24 million.

This is a substantial contribution to GreenTrail's simulated product mix.

However, it should not automatically be interpreted as evidence of stronger customer preference for sustainable products. Product availability, assortment, pricing and other factors would need to be considered.

### 5. Promotional
