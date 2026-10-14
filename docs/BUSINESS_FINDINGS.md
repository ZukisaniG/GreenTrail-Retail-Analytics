# GreenTrail Outdoors | Retail Performance Research

**SQL business findings report**  
**Period:** 1 January 2024–31 December 2025  
**Analysis environment:** MySQL 8.0 | 150 simulated stores | 25 SQL analyses

> **Research status.** Independent educational analysis of a synthetic retail dataset. The original 25-store training spreadsheet is preserved separately. This document does not report actual GreenTrail Outdoors results or work undertaken for Mastercard.

## Executive summary

The simulated retailer generated **$89,015,269.31 in revenue** across **426,602 transactions** over 24 months. Gross profit was **$41,512,862.04**, equivalent to a **46.64% gross margin**. Revenue declined by **0.33%** between 2024 and 2025; average purchase value changed very little, indicating that lower transaction volume accounts for most of the decline.

Regional comparisons show that the South contributed the largest total revenue, while the Midwest recorded the highest revenue per store. Footwear generated the most category revenue and gross profit; Camping had the highest gross margin. Sustainable products accounted for **64.3%** of revenue. These results describe the simulated data and should not be interpreted as evidence of real consumer demand or causal promotional effectiveness.

**Research conclusion:** Use these descriptive results to develop hypotheses for a controlled pilot, not to justify immediate nationwide adoption of a promotional strategy.

## 1. Dataset and analytical method

The analysis uses a relational dataset of 150 stores, 650 campaigns, transaction headers and line items, customer segments, daily foot traffic and monthly inventory. SQL queries aggregate the data by time, store, region, product category and promotion classification. Reported revenue in the transaction table reconciles to transaction-line revenue at **$89,015,269.31** (difference **$0.00**). There are no orphaned transaction lines in the validation check, and each of the 650 campaigns has a campaign-cost record.

Sales and profit estimates are descriptive. Campaign-linked purchases are not equivalent to incremental sales. Gross profit excludes campaign expenses and wider operating costs.

## 2. Sales performance

| Period | Transactions | Revenue |
|---|---:|---:|
| 2024 | 213,640 | $44,580,140.73 |
| 2025 | 212,962 | $44,435,128.58 |

Annual revenue fell by approximately **$145,012** (**0.33%**). Average transaction value remained near **$208.66**, suggesting the decline was primarily associated with slightly fewer transactions. This is a modest difference in a synthetic dataset; a real operational interpretation would require comparable store exposure, calendar effects and external demand data.

### Regional comparison

| Region | Stores | Revenue | Revenue per store (24 months) |
|---|---:|---:|---:|
| South | 60 | $32,364,556.44 | $539,409.27 |
| West | 40 | $25,174,994.01 | $629,374.85 |
| Midwest | 27 | $18,400,446.20 | $681,498.01 |
| Northeast | 23 | $13,075,272.66 | $568,490.12 |

The South leads on aggregate revenue but not on store-normalised revenue. The Midwest leads on average revenue per store. Store size and foot traffic should be considered before inferring greater productivity or recommending replication of operating practices.

## 3. Category economics and sustainability

| Category | Revenue | Gross profit | Gross margin |
|---|---:|---:|---:|
| Footwear | $25,805,635.50 | $12,045,771.84 | 46.68% |
| Camping | $22,360,234.20 | $10,900,940.11 | 48.75% |
| Equipment | $22,004,446.97 | $10,208,565.40 | 46.39% |
| Accessories | $9,908,119.99 | $4,557,925.65 | 46.00% |
| Apparel | $8,936,832.65 | $3,799,659.04 | 42.52% |

Footwear contributed the largest sales and gross-profit amounts. Camping recorded the strongest gross margin (**48.75%**) and is a reasonable candidate for a margin-conscious promotional experiment. A high margin does not, by itself, establish that further discounting would be profitable.

Products flagged as sustainable generated **$57,237,472.59** (**64.3% of revenue**), compared with **$31,777,796.72** from non-sustainable products. This is a composition measure: the shares may reflect the number, pricing and availability of products in each group.

## 4. Customer and promotional observations

The largest customer segment by recorded revenue was **Value Seekers ($22,194,976.20)**, followed by **Outdoor Enthusiasts ($20,521,463.18)**. Segment revenue is influenced by transaction count; it should not be conflated with purchase frequency per unique customer.

| Promotion type | Linked transactions | Linked revenue |
|---|---:|---:|
| Sustainability Spotlight | 4,046 | $860,345.10 |
| Loyalty Reward | 3,898 | $792,030.18 |
| Special Event | 3,629 | $749,923.68 |
| Discount | 4,344 | $744,505.25 |
| Buy-One-Get-One | 4,021 | $728,074.85 |

Sustainability Spotlight had the highest revenue linked to tagged promotional transactions. Across all categories, promotional purchases averaged **$194.35**, versus **$209.36** for non-promotional purchases. Neither comparison establishes incremental uplift, return on investment or the effect of a particular promotion, because transactions differ in offer eligibility, timing and customer composition.

## 5. Recommendations and proposed evaluation

**1. Run a bounded experiment.** Pilot Sustainability Spotlight against an alternative camping-focused bundle. Assign comparable stores to treatment and control groups, preferably at random within matched regional or store-size strata. Avoid changing overlapping offers during the test.

**2. Set a commercial decision rule in advance.** Make incremental gross profit **after campaign cost** the primary economic outcome, with incremental revenue, traffic and basket value as secondary indicators. Estimate confidence intervals and investigate variation by store type.

**3. Use customer segmentation as a hypothesis, not a conclusion.** Test different messages for Value Seekers and Outdoor Enthusiasts. Track engagement and repeat purchases where consent and data availability permit.

**4. Improve measurement coverage.** Capture exposure dates, discount eligibility, implementation fidelity, campaign cost allocation and baseline store characteristics. The current data cannot establish a counterfactual for the observed promotional revenue.

**5. Use a provisional six-week pilot.** Confirm the final duration through expected effect size, statistical power and seasonality assessment before implementation.

## 6. Limitations and reproducibility

- All expanded store, transaction, campaign and inventory records are **synthetic**. The 25-store training observations are retained separately.
- Campaign-linked sales are not incremental sales. No causal claims or promotion ROI estimates are made.
- Gross profit reflects item sale price less item cost and is not operating or net profit.
- All **432,000** monthly inventory observations contain **zero recorded stockout days**. This should be treated as a synthetic-data limitation; the dataset cannot support a ranking of meaningful stockout risk.
- Inventory values are modelled holdings, not confirmed physical stock balances.
- Total transaction and line-item revenues reconcile, but this alone does not establish every measure as economically realistic.

**Reproduction:** Use the database creation and import scripts in `sql/`, followed by `04_data_exploration.sql` and `05_data_quality_checks.sql`. The dataset covers **1 January 2024 to 31 December 2025**.
