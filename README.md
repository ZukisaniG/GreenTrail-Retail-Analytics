[README.md](https://github.com/user-attachments/files/34001099/README.md)
# GreenTrail Outdoors | Retail Analytics Portfolio Project

**SQL • Python • Power BI • Business Analysis**

An end-to-end retail analytics project exploring sales performance, profitability, customer behaviour, promotional activity and inventory management across a simulated 150-store outdoor retail business.

---

## About the Project

GreenTrail Outdoors is a fictional outdoor retail business used for this independent portfolio case study.

I developed this project to explore how data can support better business decisions. Rather than focusing only on sales figures, I wanted to understand what was driving performance across different parts of the business, which products and stores were contributing the most, and where management could potentially improve profitability.

The project began with a small retail promotions dataset containing 25 store observations. I subsequently worked with an expanded synthetic dataset covering 150 stores and two years of retail activity.

Using MySQL, Python and Power BI, I worked through preparing the data, exploring business performance, developing analytical queries and presenting the findings through an interactive dashboard.

The result is a four-page Power BI report supported by SQL analysis, Python exploratory work and documented business findings.

## Business Problem

Retail businesses can have large amounts of transaction data but still struggle to turn that information into useful decisions.

For GreenTrail, I focused on five questions:

1. How is the business performing in revenue, profit and sales trends?
2. Which stores and regions perform well, and which deserve further investigation?
3. Which product categories contribute the most revenue and gross profit?
4. What can promotional activity tell us about sales, campaign spending and customer behaviour?
5. How can inventory and sustainability-related data support better business planning?

The objective was to give management a clearer picture of retail performance and identify opportunities worth investigating.

## Dataset Overview

The analysis uses an expanded **synthetic** retail dataset covering **January 2024 to December 2025**.

| Metric | Value |
|---|---:|
| Stores | 150 |
| Transactions | 426,602 |
| Transaction line items | 682,323 |
| Products | 120 |
| Simulated campaigns | 650 |
| Total revenue | $89.02M |
| Gross profit | $41.51M |
| Gross margin | 46.64% |
| Analysis period | 24 months |

The data covers stores, customer segments, product categories, transactions, promotions, campaign costs, customer traffic and inventory. The original 25-store training observations remain separate from the expanded synthetic transactions.

**Data note:** GreenTrail is a simulated business case. These figures and findings are for educational and portfolio purposes, not actual company performance.

---

## Project Approach

### 1. SQL — Data Exploration and Business Analysis

I used MySQL 8.0 to explore GreenTrail's performance through a relational database, joins, aggregations and comparative analysis. The SQL work includes **25 analytical queries** and **five data-quality checks**.

I examined overall sales, monthly and annual trends, revenue by region and store type, top and bottom stores, product-category profitability, sustainable products, promotions, customer spending and inventory.

The quality checks included reconciling transaction revenue with transaction-line revenue and looking for orphaned transaction lines. That work reinforced an important point for me: a correct number is useful only when the underlying definition and business context are also clear.

### 2. Python — Exploratory Data Analysis

I used Python and Pandas to complement the SQL work with exploratory analysis and supporting visualisations. The notebook documents the analysis and helps make the workflow easier to revisit.

See the [Python notebooks](python/notebooks/).

### 3. Power BI — Interactive Dashboards

I built four Power BI report pages to make the results easier to interpret and explore. The report uses DAX measures, a relational model, KPI cards, comparisons and interactive charts.

#### Page 1 — Executive Overview

![Executive Overview](docs/screenshots/01_executive_overview.png)

This page brings together total revenue, gross profit, gross margin, transaction volume and average transaction value. It also shows monthly revenue trends and comparisons by region, product category and customer segment.

#### Page 2 — Store Performance

![Store Performance](docs/screenshots/02_store_performance.png)

This page compares the ten highest- and lowest-revenue stores, average revenue per store by region and revenue per square foot by store type. It separates overall sales size from measures of store efficiency.

#### Page 3 — Promotions Analysis

![Promotions Analysis](docs/screenshots/03_promotions_analysis.png)

This page examines revenue and gross profit associated with promotion types, recorded campaign costs and promotional versus non-promotional transactions. It describes associations, **not proven incremental sales or return on investment**.

#### Page 4 — Customers & Inventory

![Customers and Inventory](docs/screenshots/04_customers_inventory.png)

This page looks at average transaction value by customer segment, sustainable-product revenue share, December 2025 closing inventory value and the ten highest-revenue products.

---

## Key Findings

### 1. Revenue was relatively stable across the two years

GreenTrail generated about **$89.02 million** in simulated revenue over 24 months. Revenue fell by approximately **0.33%** between 2024 and 2025. That modest decrease is a starting point for investigating changes in transactions, products and regional performance rather than an explanation by itself.

### 2. The region with the most revenue was not the most productive per store

The South generated approximately **$32.36 million** in total revenue, the highest regional contribution. However, the Midwest generated approximately **$681,498 per store** over two years, compared with **$539,409 per store** in the South.

This highlights why comparisons should account for store count. I would investigate location, floor area, traffic and merchandise mix before concluding that one region is operationally better.

### 3. Footwear led sales, while Camping had the highest gross margin

Footwear contributed approximately **$25.81 million** in revenue and **$12.05 million** in gross profit. Camping had the strongest category gross margin, at about **48.75%**.

A possible next step would be to test camping-focused offers while monitoring whether promotional discounts weaken category margins.

### 4. Sustainable products were a large part of the sales mix

Products classified as sustainable accounted for approximately **$57.24 million**, or **64.3% of total revenue**.

This is a significant share, but it does not prove that customers prefer sustainable items on a like-for-like basis. Product availability, price and assortment also matter.

### 5. Promotional revenue does not automatically mean promotional success

**Sustainability Spotlight** had the largest revenue associated with labelled promotional transactions, at approximately **$860,345**.

However, the data cannot show whether those purchases would have happened without the promotion. To assess incremental impact, I would recommend testing clearly defined offers against comparable control stores and examining gross profit after campaign costs.

---

## Business Recommendations

**Investigate store-level differences.** Compare location, traffic, store size and trading conditions to understand why some stores outperform others.

**Look beyond sales when assessing product categories.** Include gross margin in merchandising and pricing decisions, particularly when evaluating discounts.

**Test promotional ideas before scaling them.** Use treatment and control groups, pre-test baselines and incremental gross profit rather than judging campaigns on associated revenue alone.

**Improve inventory measures.** Use reliable stockout and inventory-turnover information to support replenishment decisions. The generated dataset's stockout records are not realistic enough for a meaningful lost-sales assessment.

**Explore customer-level opportunities carefully.** Investigate differences in spending by segment and test tailored offers rather than assuming one promotion works equally well for all customers.

These recommendations are hypotheses for further investigation, not evidence that operational changes have already produced results.

## Tools and Skills

| Tool | Application |
|---|---|
| MySQL 8.0 | Relational schema, joins, aggregations, analytical queries, data validation |
| Python and Pandas | Exploratory analysis and data preparation |
| Power BI | Interactive dashboards, KPI reporting, visual storytelling |
| DAX | Financial measures and calculated fields |
| GitHub | Documentation and version control |
| Business analysis | Framing questions, defining KPIs, interpreting results, recommending next steps |

---

## Repository Structure

```text
GreenTrail-SQL-Project/
├── data/                  # Data samples and generation resources
├── docs/                  # Documentation and screenshots
│   └── screenshots/
│       ├── 01_executive_overview.png
│       ├── 02_store_performance.png
│       ├── 03_promotions_analysis.png
│       └── 04_customers_inventory.png
├── python/
│   └── notebooks/         # Exploratory analysis notebook
├── sql/                   # MySQL schema, imports, analysis and checks
├── powerbi/
│   ├── GreenTrail_Retail_Analytics.pbix
│   └── README.md
└── README.md
```

### Running the SQL analysis locally

1. Install MySQL Server 8.0 and MySQL Workbench.
2. Create the database and tables using the schema scripts in [`sql/`](sql/).
3. Obtain or generate the complete synthetic dataset. The repository's sample files alone are not sufficient to reproduce the full database.
4. Update the CSV import paths in `03_import_data_mysql.sql` for your local MySQL import directory.
5. Run the import script, then `05_data_quality_checks.sql` to verify the data.
6. Run the analytical SQL script to explore the findings.

The expanded data generator depends on the original training workbook, which is not included in the repository. Some environment-specific adjustments may therefore be needed for full reproduction.

### Exploring the Python analysis

See [`python/notebooks/`](python/notebooks/) for the exploratory notebook. Reproducing it requires a compatible Python environment and the relevant input data.

### Opening the Power BI report

The report is located at [`powerbi/GreenTrail_Retail_Analytics.pbix`](powerbi/GreenTrail_Retail_Analytics.pbix). Open it in Power BI Desktop.

Its local MySQL data connection may need to be updated if opened on another computer. If you only want to preview the results, the four screenshots above show the saved report pages.

---

## Limitations and Interpretation

- The expanded retail transactions are **synthetic**, not observed company sales.
- The original 25-store promotions spreadsheet is separate from the simulated 2024–2025 transaction history.
- Campaign-linked revenue and gross profit are not estimates of causal lift or verified promotional ROI.
- Gross profit excludes other operating expenses and is not net profit.
- Generated monthly inventory records have zero recorded stockout days, limiting stockout analysis.
- Currency amounts reflect simulated USD assumptions.

These boundaries are central to interpreting the findings responsibly.

## Reflection

GreenTrail helped me connect technical analysis with business questions. SQL helped me examine the underlying records, Python added an exploratory workflow, and Power BI made the findings easier to communicate.

The biggest takeaway for me was that a dashboard can show patterns, but understanding their causes and deciding what to do next often requires better data, careful comparisons and testing. That's the kind of work I want to keep developing in business analysis, business intelligence and data analytics.

---

**Project by Zukisani Gxawu**  
BSc Informatics | University of South Africa (UNISA)

*Independent educational portfolio project. Not a real client engagement.*
