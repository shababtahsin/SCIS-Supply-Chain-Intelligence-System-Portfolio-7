# Southern Cross Industrial Supply (SCIS) — End-to-End Supply Chain Analytics

> **SQL Server portfolio project:** an end-to-end supply-chain analysis covering data ingestion, ETL, reconciliation, modelling, exploratory analysis, KPI development, root-cause analysis, and business-impact quantification.

---

## Executive Summary

Southern Cross Industrial Supply (SCIS) is a multi-domain supply-chain analytics project built in **Microsoft SQL Server / SSMS**. The project integrates **25 CSV source files containing 196,460 rows** across customer demand, procurement, suppliers, inventory, production, warehousing, logistics, quality, returns, contracts, FX, and bill-of-materials data.

The objective was not simply to write isolated SQL queries. The project builds a controlled analytical workflow:

**Raw CSVs → Staging → Data Quality & Transformation → Final SQL Tables → Validation → Data Model → EDA → KPI Framework → Root-Cause Analysis → Business Impact**

The analysis is designed to answer management questions such as:

- Are customer orders being fulfilled completely and on time?
- Where are inventory shortages and working-capital exposures occurring?
- Which supplier and procurement behaviours create operational risk?
- Where are production, quality, warehouse, and logistics bottlenecks?
- Which exceptions are financially or operationally material?
- Which issues should management investigate first?

---

## Project Snapshot

| Item | Scope |
|---|---:|
| Source files | **25 CSVs** |
| Source rows | **196,460** |
| Products | **150** |
| Suppliers | **60** |
| Facilities | **5** — 4 distribution centres + 1 manufacturing plant |
| Customer orders | **9,000** |
| Customer order lines | **27,073** |
| Purchase orders | **6,500** |
| Purchase order lines | **22,737** |
| Shipments | **5,907** |
| Inventory snapshots | **42,900** |
| Production orders | **1,800** |
| Quality inspections | **10,000** |
| Core order / planning period | **Jan 2025 – Jun 2026** |
| Primary platform | **Microsoft SQL Server / SSMS** |

---

## Business Problem

SCIS operates across several connected supply-chain processes, but performance cannot be understood reliably by looking at any one table in isolation.

A late customer shipment may originate from:

- supplier delay,
- insufficient inventory,
- inaccurate forecasting,
- production disruption,
- quality failure,
- warehouse execution,
- carrier performance,
- or a combination of these factors.

The project therefore treats supply-chain analysis as an **end-to-end business system**, not a collection of disconnected KPIs.

### Analytical objectives

1. Build a reliable SQL analytical foundation from the raw files.
2. Protect the analysis from duplicate rows, incorrect joins, invalid denominators, and mixed data grains.
3. Establish repeatable KPIs across major supply-chain functions.
4. Identify operational exceptions and concentrations of risk.
5. Trace poor performance toward plausible root causes.
6. Translate operational issues into financial, working-capital, service, capacity, and risk impact.

---

## Data Architecture

```mermaid
flowchart LR
    A[25 Raw CSV Files] --> B[stg Schema]
    B --> C[Data Quality & Transformation]
    C --> D[dbo Analytical Tables]
    D --> E[Validation & Reconciliation]
    E --> F[Data Model]
    F --> G[Exploratory Data Analysis]
    G --> H[KPI Framework]
    H --> I[Root-Cause Analysis]
    I --> J[Business Impact & Materiality]
```

### SQL-layer design

| Layer | Purpose |
|---|---|
| **Raw CSV** | Original source data retained outside SQL Server |
| **`stg` schema** | Landing area for source data with minimal alteration |
| **Transformation / QA** | Validate strings, numbers, dates, relationships, nulls, and business keys |
| **`dbo` tables** | Final analytical tables |
| **Analytical SQL** | EDA, KPIs, exceptions, root causes, and impact analysis |

The staging layer is deliberately separated from the final analytical layer so that source values can be reconciled before business calculations are performed.

---

## Dataset Coverage

| Domain | Main files | Rows |
|---|---|---:|
| Master & reference | regions, warehouses, products, suppliers, supplier-products, carriers, contracts, BOM, FX | **1,132** |
| Demand & customer orders | customer orders, order lines, demand forecast | **41,473** |
| Procurement & receiving | purchase orders, PO lines, goods receipts | **46,981** |
| Inventory | inventory snapshots, stock movements | **60,900** |
| Production | production orders, production events, downtime | **9,109** |
| Quality & returns | quality inspections, returns | **11,039** |
| Logistics | shipments, shipment lines | **23,642** |
| Warehouse operations | warehouse operations | **2,184** |
| **Total** | **25 files** | **196,460** |

<details>
<summary><strong>Source files</strong></summary>

- `bom.csv`
- `carriers.csv`
- `contracts.csv`
- `customer_order_lines.csv`
- `customer_orders.csv`
- `demand_forecast.csv`
- `downtime_events.csv`
- `fx_rates.csv`
- `goods_receipts.csv`
- `inventory_snapshots.csv`
- `production_events.csv`
- `production_orders.csv`
- `products.csv`
- `purchase_order_lines.csv`
- `purchase_orders.csv`
- `quality_inspections.csv`
- `regions.csv`
- `returns.csv`
- `shipment_lines.csv`
- `shipments.csv`
- `stock_movements.csv`
- `supplier_products.csv`
- `suppliers.csv`
- `warehouse_operations.csv`
- `warehouses.csv`

</details>

---

## End-to-End SQL Workflow

The project is organised as a progressive analytical workflow rather than a single monolithic query.

| Chapter | Stage | Purpose |
|---|---|---|
| **3** | Extract | Load CSV data into staging tables using `BULK INSERT` |
| **4** | Transform | Profile and validate nulls, duplicates, text, numeric values, dates, relationships, currencies, and grain |
| **5** | Load | Populate final analytical tables and reconcile row counts |
| **6** | Validation & Reconciliation | Test keys, orphans, joins, quantities, denominators, and header/line multiplication |
| **7** | Data Modelling | Document table grain and one-to-many relationships |
| **8** | EDA | Explore demand, procurement, inventory, logistics, production, quality, returns, and warehouse activity |
| **9** | Supply-Chain Analysis | Perform detailed functional analysis across the full operating model |
| **10** | KPI Development | Convert analytical logic into repeatable business KPIs |
| **11** | Root-Cause Analysis | Investigate drivers behind poor-performing areas |
| **12** | Business Impact | Quantify financial, service, productivity, capacity, working-capital, and risk exposure |

---

## Data Quality & Validation

A major part of the project is protecting business conclusions from bad analytical mechanics.

### Controls implemented

- staging-to-final **row-count reconciliation**
- primary and business-key uniqueness tests
- duplicate detection
- null profiling
- string trimming and category standardisation
- suspicious numeric-value checks
- impossible or suspicious date-sequence checks
- orphan-record checks
- master-to-child relationship validation
- PO header / line grain checks
- shipment header / line grain checks
- join-multiplication tests
- currency validation
- FX-rate coverage checks
- forecast-version separation
- signed inventory-movement validation
- KPI denominator validation

### Examples of raw-data issues identified

The source-data review identified anomalies that were **flagged rather than silently overwritten**, including:

- **8** purchase-order lines with negative ordered quantity
- **8** purchase-order lines with missing unit price
- **12** PO lines with missing expected delivery date
- **6** goods-receipt rows with missing received quantity
- **6** customer orders with missing requested delivery date
- inconsistent whitespace/casing in several categorical values

This approach preserves source traceability while preventing questionable records from being mistaken for normal business behaviour.

---

## Data-Grain Controls

Correct data grain is critical in this project.

For example:

- `shipments` is **shipment-level**
- `shipment_lines` is **line-level**

A shipment may contain several lines. Joining the two tables and then summing `freight_cost_aud` would repeat the same shipment freight multiple times.

The project explicitly tests for this type of **join multiplication** and keeps freight calculations at shipment grain.

The same principle is applied to:

- customer order headers vs order lines,
- purchase order headers vs PO lines,
- goods receipts,
- production orders vs production events,
- and forecast observations.

---

## KPI Framework

### Inventory

- Average inventory
- Inventory value
- Inventory turnover
- Days in inventory
- Stockout rate
- Reorder-point breach rate
- Safety-stock breach rate
- Slow / fast-moving inventory
- Dead-stock exposure
- ABC classification

### Demand & Forecast

- Monthly demand
- Demand variability
- Seasonality
- Forecast vs actual
- Absolute forecast error
- Forecast error by version

### Procurement

- Procurement spend by currency
- Contract compliance
- Maverick / non-compliant spend
- Purchase-price spread
- Purchase-price variance
- Supplier concentration

### Suppliers

- Lead time
- Lead-time variability
- On-time receipt rate
- OTIF
- Rejection rate
- Supplier concentration
- Single-source exposure

### Customer Fulfilment

- Fill rate
- Backorder rate
- On-time delivery rate
- Late-delivery rate
- Average days late
- Perfect-order rate
- Order-cycle time

### Warehouse

- Throughput
- Lines picked per labour hour
- Pick-error rate
- Capacity utilisation

### Production

- Production throughput
- Yield
- Scrap rate
- Schedule adherence
- Production cycle time
- Downtime
- Scrap-value exposure

### Quality

- Defect rate
- Inspection failure rate
- Product-level defect rate
- Defect rate by source
- Defect-type profile

### Logistics & Returns

- Total freight
- Average freight per shipment
- Freight by carrier
- Carrier on-time performance
- Transport lead time
- Late-shipment rate
- Return quantity
- Return rate
- Return-value exposure

### End-to-End Risk

- SLA breaches
- single-source stockout exposure
- operational exception counts
- product bottleneck signals
- materiality ranking

---

## Selected Analytical Results

The following figures were calculated from the supplied source data using the KPI definitions implemented in the project.

| Area | Result | Interpretation |
|---|---:|---|
| **Overall fill rate** | **64.13%** | A material share of ordered quantity was not represented as shipped quantity under the project definition |
| **Backorder rate** | **35.87%** | Equivalent to **879,544 units** of unfulfilled quantity |
| **On-time delivery** | **34.11%** | Delivery timeliness is a major service-level constraint |
| **Late-delivery rate** | **65.89%** | Late shipments averaged **4.51 days late** |
| **Perfect-order rate** | **28.92%** | Defined here as fully shipped with no return event |
| **Contract-compliant PO lines** | **75.06%** | Roughly one quarter of PO lines are outside the compliance flag |
| **Inventory stockout snapshots** | **8.09%** | Repeated zero/negative on-hand positions require product and site investigation |
| **Below reorder point** | **55.03%** | Replenishment thresholds are breached frequently across snapshot records |
| **Below safety stock** | **26.34%** | Indicates recurring inventory-resilience pressure |
| **Single-source products** | **33** | All 33 experienced at least one stockout snapshot in the supplied data |
| **Average inventory value** | **A$6.90M** | Working-capital proxy based on average on-hand quantity × standard cost |
| **Production yield** | **96.27%** | Production output is generally high-yield despite material scrap exposure |
| **Scrap rate** | **3.73%** | Standard-cost scrap exposure is approximately **A$5.41M** |
| **Recorded downtime** | **2,965.1 hours** | Provides a basis for reason- and product-level capacity analysis |
| **Quantity defect rate** | **4.15%** | Defective units as a share of inspected units |
| **Inspection failure rate** | **30.04%** | Failure-event frequency is materially higher than the unit defect rate |
| **Total freight cost** | **A$3.63M** | Retained at shipment grain to avoid line-level duplication |
| **Return rate** | **0.66%** | Returned quantity as a share of shipped quantity |
| **Return value exposure** | **A$2.16M** | Standard-cost proxy, not final accounting loss |

> **Important:** several impact measures are deliberately treated as **exposure proxies**, not booked financial losses. Procurement currencies are also kept separate unless an explicit FX conversion is applied.

---

## Key Findings

### 1. Customer service is the clearest end-to-end pressure point

The combination of a **64.13% fill rate** and **65.89% late-delivery rate** indicates that service performance cannot be explained by a single process metric. The project therefore traces fulfilment problems across inventory, suppliers, production, warehousing, and logistics rather than treating late delivery as an isolated carrier issue.

### 2. Inventory availability and sourcing resilience are linked

Stockouts occurred in **8.09% of inventory snapshots**, while **33 products are single-source**. Every one of those single-source products recorded at least one stockout snapshot, creating a clear candidate set for sourcing and replenishment review.

### 3. Replenishment thresholds require attention

More than half of product/site inventory snapshots were at or below reorder point, and **26.34%** were below safety stock. The SQL analysis uses product, warehouse, movement, demand, and supplier relationships to distinguish chronic shortage risk from isolated low-stock events.

### 4. Production output is strong, but losses remain financially material

Overall production yield is **96.27%**, but the supplied production orders still contain approximately **A$5.41M** of standard-cost scrap exposure and **2,965.1 hours** of recorded downtime. Root-cause analysis therefore focuses on product, process step, and downtime reason rather than yield alone.

### 5. Quality performance needs both event-level and quantity-level interpretation

The project separates the **30.04% inspection failure rate** from the **4.15% unit defect rate**. This prevents a high number of failed inspection events from being incorrectly interpreted as the same thing as the percentage of physical units defective.

### 6. Procurement compliance is a measurable control issue

Approximately **75.06%** of PO lines are flagged as contract compliant. Because purchase orders are denominated in multiple currencies, spend is analysed by currency or only aggregated after explicit FX treatment.

---

## Root-Cause Analysis

Chapter 11 moves beyond KPI reporting and asks **why** poor performance is occurring.

The SQL investigates root causes across:

- stockouts,
- inventory / overstock,
- forecast performance,
- procurement and purchase-price variance,
- supplier performance,
- purchase-order execution,
- customer fulfilment,
- warehouse operations,
- production,
- quality,
- logistics,
- returns,
- and end-to-end bottlenecks.

The analysis also compares **good vs poor-performing groups** and separates **symptoms from plausible causes**.

Example analytical chain:

```text
Late Customer Delivery
        ↓
Insufficient Shipped Quantity / Late Shipment
        ↓
Inventory Shortage OR Production Delay OR Warehouse Delay
        ↓
Supplier / Forecast / Material / Quality / Capacity Driver
        ↓
Customer-Service + Financial + Operational Impact
```

---

## Business-Impact Quantification

Chapter 12 translates operational findings into management-relevant impact.

### Financial impact

- procurement spend
- purchase-price variance
- non-compliant procurement value
- scrap-value exposure
- return-value exposure
- freight cost

### Working-capital impact

- average inventory value
- slow-moving inventory exposure
- dead-stock exposure
- over-forecast inventory exposure

### Revenue / customer impact

- backorder quantity
- backorder-value proxy
- orders affected by lateness
- orders affected by returns

### Service-level impact

- late-delivery rate
- average days late
- fill-rate impact
- SLA breaches
- perfect-order loss

### Productivity & capacity impact

- warehouse productivity
- pick-error impact
- downtime
- scrap
- production-output loss
- material-shortage exposure

### Risk impact

- single-source exposure
- single-source + stockout exposure
- supplier-delivery risk
- forecast risk
- quality risk
- customer-service risk
- operational materiality

---

## SQL Techniques Demonstrated

The project intentionally relies on repeatable analyst-level SQL rather than unnecessary database engineering.

```sql
SELECT
WHERE
ORDER BY
DISTINCT
GROUP BY
HAVING

SUM()
AVG()
COUNT()
MIN()
MAX()

CASE
DATEDIFF()
YEAR()
MONTH()

INNER JOIN
LEFT JOIN

UNION ALL

Subqueries
NOT EXISTS

CTEs

Window functions
PARTITION BY
ORDER BY ... OVER()

NULL handling
NULLIF()

BULK INSERT
INFORMATION_SCHEMA
```

### Analytical SQL capabilities demonstrated

- multi-table business analysis
- aggregation at controlled grain
- conditional metrics
- denominator-safe percentages
- exception classification
- ranked analysis
- reusable CTE pipelines
- reconciliation queries
- source-to-target validation
- dimensional relationship checks
- one-to-many join control
- operational KPI design
- root-cause investigation
- financial-impact proxies

---

## Important Analytical Rules

Several rules are enforced throughout the project:

1. **Do not mix currencies without conversion.**
2. **Do not combine forecast versions without a defined business rule.**
3. **Do not treat every NULL as bad data.**
4. **Do not convert legitimate negative stock movements to positive values.**
5. **Do not sum shipment-level freight after multiplying shipments through a line-level join.**
6. **Define the denominator before calculating a percentage KPI.**
7. **Validate table grain before joining.**
8. **Label cost proxies as proxies rather than accounting losses.**
9. **Preserve original source values long enough to reconcile transformations.**

These controls are as important to the project as the KPI calculations themselves.

---

## Repository Structure

```text
SCIS-Supply-Chain-Analytics/
│
├── README.md
├── SCIS_Supply_Chain_Analysis.sql
│
└── data/
    ├── bom.csv
    ├── carriers.csv
    ├── contracts.csv
    ├── customer_order_lines.csv
    ├── customer_orders.csv
    ├── demand_forecast.csv
    ├── downtime_events.csv
    ├── fx_rates.csv
    ├── goods_receipts.csv
    ├── inventory_snapshots.csv
    ├── production_events.csv
    ├── production_orders.csv
    ├── products.csv
    ├── purchase_order_lines.csv
    ├── purchase_orders.csv
    ├── quality_inspections.csv
    ├── regions.csv
    ├── returns.csv
    ├── shipment_lines.csv
    ├── shipments.csv
    ├── stock_movements.csv
    ├── supplier_products.csv
    ├── suppliers.csv
    ├── warehouse_operations.csv
    └── warehouses.csv
```

---

## Running the Project

### Requirements

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)
- Local access to the source CSV files

### Steps

1. Create or select the `SCIS` database.
2. Create staging and final tables matching the supplied CSV structures.
3. Place the CSV files in a directory readable by the SQL Server service.
4. Update the `BULK INSERT` paths in the SQL file, for example:

```sql
FROM 'C:\SCIS_DATA\products.csv'
```

5. Execute the project sequentially from **Chapter 3 through Chapter 12**.
6. Review validation results before relying on downstream KPI outputs.

### Current repository prerequisite

The supplied main SQL script begins at **Chapter 3 — Extract** and assumes the staging/final table structures have already been created from the source schemas.

For a fully one-click reproducible repository, a future enhancement would be to add a dedicated:

```text
01_schema_setup.sql
```

containing the `CREATE DATABASE`, schema, and `CREATE TABLE` statements.

---

## Assumptions & Limitations

- The project uses the business definitions documented inside the SQL script; alternative organisations may define the same KPI differently.
- Procurement records contain multiple currencies. Values are not treated as a single monetary total unless explicitly converted.
- Forecast versions remain analytically distinct.
- Negative stock movements can represent legitimate outbound activity.
- Cost-based scrap and return measures use **standard cost** and are exposure proxies rather than final realised accounting losses.
- Some raw-source anomalies are intentionally surfaced for investigation rather than automatically corrected.
- The current repository focuses on the SQL analytical workflow; a BI/dashboard layer can be added separately.

---

## What This Project Demonstrates

This project demonstrates the ability to move from **raw operational data to management-level analysis** while maintaining control over data quality, table grain, business definitions, and analytical assumptions.

The strongest skills demonstrated are:

- SQL-based ETL
- relational data modelling
- data-quality investigation
- reconciliation
- supply-chain analytics
- KPI design
- root-cause analysis
- financial and operational impact analysis
- risk identification
- business-oriented analytical communication

---

## Tools

**Microsoft SQL Server · SQL Server Management Studio (SSMS) · SQL · CSV**

---

## Project Status

**Complete analytical workflow: Chapters 3–12**

- [x] Extract
- [x] Transform
- [x] Load
- [x] Validate and reconcile
- [x] Model
- [x] Explore
- [x] Analyse supply-chain performance
- [x] Develop KPIs
- [x] Perform root-cause analysis
- [x] Quantify business impact

