# GreenTrail Outdoors — Retail Analytics (SQL Portfolio)

**Independent educational case study | MySQL 8.0**

This project investigates revenue, store performance, product profitability, customer segments and promotional activity using 25 original training observations and a **separately generated synthetic** 150-store dataset across 2024–2025. The synthetic figures are **not real business results** and this is **not a Mastercard client engagement**.

## SQL deliverables

- `sql/01_create_database.sql` — sets up the schema name
- `sql/02_create_tables_mysql.sql` — creates 11 tables and keys
- `sql/03_import_data_mysql.sql` — bulk-loads CSVs (configured for a specific Windows MySQL `Uploads` path)
- `sql/04_data_exploration.sql` — 25 analytical queries
- `sql/05_data_quality_checks.sql` — five data checks
- `docs/data_dictionary.csv` — columns and data lineage
- `data/samples/` — 10-record previews **not sufficient for full database import**
- `data/generation_script.py` — synthetic dataset generator; requires local source workbook

## Reproduce locally

1. Install MySQL Server 8.0 and MySQL Workbench.
2. Run `01_create_database.sql`, then `02_create_tables_mysql.sql`.
3. Obtain or generate the **full** 11 CSV tables. Samples in this repository are only previews. The generator expects the local, original `GreenTrail Store Data.xlsx` workbook; it is not included in the Git-tracked files.
4. Review the absolute path in `03_import_data_mysql.sql`; place the CSVs in your MySQL server's `secure_file_priv` directory, adjust the path if needed, then import into empty tables once.
5. Run `05_data_quality_checks.sql` and inspect the results; then run `04_data_exploration.sql`.

## What the work demonstrates

SQL `JOIN`, `GROUP BY`, `CASE`, aggregates, basic subqueries, store normalisation, gross margin, campaign comparisons, and inventory valuation. Analysis is descriptive; differences between promotional and nonpromotional transactions **do not establish causal lift or ROI**. Transactions are a synthetic point-of-sale sample, not complete company sales.

## Data notes

- All 25 original observations are retained unchanged in the local source workbook and separate `original_promotion_observations` table.
- Original exercise observations and the newer simulated transactions represent **different time periods**. Do not combine them as observed sales history.
- Campaign matches are simulated and do not constitute validated experimental outcomes.
- Generated stockout days are all zero; stockout ranking is not meaningful.
- Monetary figures in the generated dataset are **USD assumptions**.

See `docs/PROJECT_STRUCTURE.md` for an explanation of folders. An executive findings report and ERD will be added in later portfolio steps.
