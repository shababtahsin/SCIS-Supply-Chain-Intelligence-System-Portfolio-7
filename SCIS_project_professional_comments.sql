/*==============================================================================
  SOUTHERN CROSS INDUSTRIAL SUPPLY — END-TO-END SQL ANALYSIS
  CHAPTER 3 — ETL: EXTRACT
  Analyst: Data Analyst
  Environment: SQL Server / SSMS

  PURPOSE
  -------
  Extract the original CSV source files into SQL Server staging tables.

  IMPORTANT:
  • This phase COPIES source data only.
  • Do not clean, replace, classify, or remediate source values during extraction.
  • Transformation belongs to Chapter 4.
  • Final analytical tables belong to Chapter 5.
  • NULL values require business-context validation before classification as data-quality issues.
  • stock_movements.quantity may legitimately be negative.
  • Exact source values must be retained for reconciliation.

  ASSUMPTION
  ----------
  The staging tables were created from the column structures inspected in
  The existing staging tables created from the Chapter 2 schema review are used as load targets.

  IMPLEMENTATION NOTE:
  BULK INSERT is the SQL Server ingestion mechanism used to load CSV source files
  into staging tables.
==============================================================================*/


/*==============================================================================
  3.1 — SELECT DATABASE
==============================================================================*/

USE SCIS;
GO


/*==============================================================================
  3.2 — CONFIRM STAGING TABLES EXIST

  Business purpose:
  Before loading anything, confirm that the staging tables created from the
  source-file structures are actually present.

  If an expected table is missing, resolve the schema issue before loading data.
==============================================================================*/

SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'stg'
ORDER BY TABLE_NAME;


/*==============================================================================
  3.3 — CLEAR PREVIOUS TEST LOADS

  RATIONALE
  If Chapter 3 is re-run, old rows must not remain and create duplicates.

  TRUNCATE TABLE removes ALL existing staging rows while keeping table structure.

  IMPORTANT:
  Apply this operation only to staging tables; final analytical tables must not be truncated here.
==============================================================================*/

TRUNCATE TABLE stg.regions;
TRUNCATE TABLE stg.warehouses;
TRUNCATE TABLE stg.suppliers;
TRUNCATE TABLE stg.products;
TRUNCATE TABLE stg.supplier_products;
TRUNCATE TABLE stg.contracts;
TRUNCATE TABLE stg.bom;
TRUNCATE TABLE stg.fx_rates;
TRUNCATE TABLE stg.demand_forecast;
TRUNCATE TABLE stg.customer_orders;
TRUNCATE TABLE stg.customer_order_lines;
TRUNCATE TABLE stg.shipments;
TRUNCATE TABLE stg.shipment_lines;
TRUNCATE TABLE stg.purchase_orders;
TRUNCATE TABLE stg.purchase_order_lines;
TRUNCATE TABLE stg.goods_receipts;
TRUNCATE TABLE stg.inventory_snapshots;
TRUNCATE TABLE stg.stock_movements;
TRUNCATE TABLE stg.production_orders;
TRUNCATE TABLE stg.production_events;
TRUNCATE TABLE stg.downtime_events;
TRUNCATE TABLE stg.quality_inspections;
TRUNCATE TABLE stg.returns;
TRUNCATE TABLE stg.warehouse_operations;
TRUNCATE TABLE stg.carriers;


/*==============================================================================
  3.4 — EXTRACT CSV FILES INTO SQL SERVER

  MECHANICS
  ---------
  BULK INSERT stg.regions              ← destination SQL table
  FROM '...\regions.csv'               ← source CSV
  FIRSTROW = 2                         ← skip CSV header
  FIELDTERMINATOR = ','                ← columns separated by commas
  ROWTERMINATOR = '0x0a'               ← new row
  TABLOCK                              ← efficient bulk load

  Update C:\SCIS_DATA\ to the applicable source directory.

  Example:
  C:\Users\YourName\Documents\SCIS\regions.csv

  SQL Server service must have permission to read the directory.
==============================================================================*/


-- ============================ MASTER DATA ============================

BULK INSERT stg.regions
FROM 'C:\SCIS_DATA\regions.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.warehouses
FROM 'C:\SCIS_DATA\warehouses.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.suppliers
FROM 'C:\SCIS_DATA\suppliers.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.products
FROM 'C:\SCIS_DATA\products.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.supplier_products
FROM 'C:\SCIS_DATA\supplier_products.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.contracts
FROM 'C:\SCIS_DATA\contracts.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.bom
FROM 'C:\SCIS_DATA\bom.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.fx_rates
FROM 'C:\SCIS_DATA\fx_rates.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);


-- ============================ DEMAND / SALES ============================

BULK INSERT stg.demand_forecast
FROM 'C:\SCIS_DATA\demand_forecast.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.customer_orders
FROM 'C:\SCIS_DATA\customer_orders.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.customer_order_lines
FROM 'C:\SCIS_DATA\customer_order_lines.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);


-- ============================ SHIPMENTS ============================

BULK INSERT stg.shipments
FROM 'C:\SCIS_DATA\shipments.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.shipment_lines
FROM 'C:\SCIS_DATA\shipment_lines.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.carriers
FROM 'C:\SCIS_DATA\carriers.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);


-- ============================ PROCUREMENT ============================

BULK INSERT stg.purchase_orders
FROM 'C:\SCIS_DATA\purchase_orders.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.purchase_order_lines
FROM 'C:\SCIS_DATA\purchase_order_lines.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.goods_receipts
FROM 'C:\SCIS_DATA\goods_receipts.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);


-- ============================ INVENTORY ============================

BULK INSERT stg.inventory_snapshots
FROM 'C:\SCIS_DATA\inventory_snapshots.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.stock_movements
FROM 'C:\SCIS_DATA\stock_movements.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);


-- ============================ PRODUCTION ============================

BULK INSERT stg.production_orders
FROM 'C:\SCIS_DATA\production_orders.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.production_events
FROM 'C:\SCIS_DATA\production_events.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.downtime_events
FROM 'C:\SCIS_DATA\downtime_events.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);


-- ============================ QUALITY / RETURNS ============================

BULK INSERT stg.quality_inspections
FROM 'C:\SCIS_DATA\quality_inspections.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);

BULK INSERT stg.returns
FROM 'C:\SCIS_DATA\returns.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);


-- ============================ WAREHOUSE ============================

BULK INSERT stg.warehouse_operations
FROM 'C:\SCIS_DATA\warehouse_operations.csv'
WITH (FORMAT='CSV', FIRSTROW=2, FIELDQUOTE='"', TABLOCK);


/*==============================================================================
  3.5 — VERIFY THAT EACH FILE ACTUALLY LOADED

  SQL technique: COUNT()

  No analytical interpretation is performed at this stage.

  Validation objective:
      Confirm the number of rows loaded into SQL Server.

  Expected:
  Every source CSV should produce rows unless the source file itself is empty.
==============================================================================*/

SELECT 'regions'              AS table_name, COUNT(*) AS row_count FROM stg.regions
UNION ALL SELECT 'warehouses',             COUNT(*) FROM stg.warehouses
UNION ALL SELECT 'suppliers',              COUNT(*) FROM stg.suppliers
UNION ALL SELECT 'products',               COUNT(*) FROM stg.products
UNION ALL SELECT 'supplier_products',      COUNT(*) FROM stg.supplier_products
UNION ALL SELECT 'contracts',              COUNT(*) FROM stg.contracts
UNION ALL SELECT 'bom',                    COUNT(*) FROM stg.bom
UNION ALL SELECT 'fx_rates',               COUNT(*) FROM stg.fx_rates
UNION ALL SELECT 'demand_forecast',        COUNT(*) FROM stg.demand_forecast
UNION ALL SELECT 'customer_orders',        COUNT(*) FROM stg.customer_orders
UNION ALL SELECT 'customer_order_lines',   COUNT(*) FROM stg.customer_order_lines
UNION ALL SELECT 'shipments',              COUNT(*) FROM stg.shipments
UNION ALL SELECT 'shipment_lines',         COUNT(*) FROM stg.shipment_lines
UNION ALL SELECT 'purchase_orders',        COUNT(*) FROM stg.purchase_orders
UNION ALL SELECT 'purchase_order_lines',   COUNT(*) FROM stg.purchase_order_lines
UNION ALL SELECT 'goods_receipts',         COUNT(*) FROM stg.goods_receipts
UNION ALL SELECT 'inventory_snapshots',    COUNT(*) FROM stg.inventory_snapshots
UNION ALL SELECT 'stock_movements',        COUNT(*) FROM stg.stock_movements
UNION ALL SELECT 'production_orders',      COUNT(*) FROM stg.production_orders
UNION ALL SELECT 'production_events',      COUNT(*) FROM stg.production_events
UNION ALL SELECT 'downtime_events',        COUNT(*) FROM stg.downtime_events
UNION ALL SELECT 'quality_inspections',    COUNT(*) FROM stg.quality_inspections
UNION ALL SELECT 'returns',                COUNT(*) FROM stg.returns
UNION ALL SELECT 'warehouse_operations',   COUNT(*) FROM stg.warehouse_operations
UNION ALL SELECT 'carriers',               COUNT(*) FROM stg.carriers
ORDER BY table_name;


/*==============================================================================
  3.6 — MANUAL SPOT CHECK

  SQL technique:
  SELECT + TOP

  RATIONALE
  COUNT(*) confirms that rows were loaded.
  It does not confirm that column alignment and field parsing are correct.

  Review for:
  • shifted columns
  • header imported as a row
  • broken commas
  • quotation marks appearing incorrectly
  • dates mapped to incorrect columns
  • obvious datatype/import problems
==============================================================================*/

SELECT TOP 10 * FROM stg.regions;
SELECT TOP 10 * FROM stg.suppliers;
SELECT TOP 10 * FROM stg.products;

SELECT TOP 10 * FROM stg.customer_orders;
SELECT TOP 10 * FROM stg.customer_order_lines;

SELECT TOP 10 * FROM stg.purchase_orders;
SELECT TOP 10 * FROM stg.purchase_order_lines;
SELECT TOP 10 * FROM stg.goods_receipts;

SELECT TOP 10 * FROM stg.inventory_snapshots;
SELECT TOP 10 * FROM stg.stock_movements;

SELECT TOP 10 * FROM stg.production_orders;
SELECT TOP 10 * FROM stg.production_events;

SELECT TOP 10 * FROM stg.shipments;
SELECT TOP 10 * FROM stg.shipment_lines;

SELECT TOP 10 * FROM stg.quality_inspections;
SELECT TOP 10 * FROM stg.returns;


/*==============================================================================
  3.7 — CHECK EXPECTED DATE RANGE

  Project source period is approximately:
      2025-01-01 → 2026-06-30

  No date corrections are applied at this stage.
  This check confirms that the loaded date range is broadly consistent with the source period.

  Update the referenced date column only if the source schema differs.
==============================================================================*/

SELECT MIN(order_date) AS first_customer_order,
       MAX(order_date) AS last_customer_order
FROM stg.customer_orders;

SELECT MIN(order_date) AS first_purchase_order,
       MAX(order_date) AS last_purchase_order
FROM stg.purchase_orders;


/*==============================================================================
  3.8 — IMPORTANT EXTRACTION SANITY CHECK

  Do not classify these conditions as errors without contextual validation.

  Example:
  A NULL actual delivery date may indicate:
      "Shipment has not been delivered yet."

  A negative stock movement may indicate:
      "Inventory left the warehouse."

  Chapter 4 validates business meaning before transformations are applied.
==============================================================================*/

-- Inspect NULL actual shipment dates.
SELECT TOP 20 *
FROM stg.shipments
WHERE actual_delivery_date IS NULL;


-- Inspect negative inventory movements.
SELECT TOP 20 *
FROM stg.stock_movements
WHERE quantity < 0
ORDER BY quantity;


/*==============================================================================
  3.9 — EXTRACTION COMPLETION CHECK

  ANALYST VALIDATION SUMMARY
  -----------------------

  [ ] All expected source CSV files were identified.
  [ ] All staging tables existed before ingestion.
  [ ] Previous staging rows were removed before reloading.
  [ ] Each CSV was imported into the correct staging table.
  [ ] Source values were preserved without transformation.
  [ ] Row counts were recorded.
  [ ] Representative tables were visually inspected.
  [ ] Date ranges were checked against the expected source period.
  [ ] NULLs were preserved.
  [ ] Negative stock movements were preserved.
  [ ] No assumptions were made that anomalies are errors.
  [ ] No business calculations were performed during extraction.
  [ ] Data is ready for Chapter 4 — ETL: Transform.


  REVIEW CONTROL STATEMENT
  -------------------------------
  The SCIS source files have been extracted into SQL Server staging tables.
  The extraction process intentionally preserves the original source values.
  Initial row-count, sample-row and date-range checks were performed to confirm
  that the datasets loaded successfully.

  Potential data-quality issues have NOT been corrected during extraction.
  They will be investigated and handled explicitly during Chapter 4 so that
  transformation decisions remain traceable and reproducible.


  CHAPTER 3 STATUS:
      EXTRACT → COMPLETE

  NEXT:
      CHAPTER 4 — ETL: TRANSFORM
==============================================================================*/

/*==============================================================================
  SOUTHERN CROSS INDUSTRIAL SUPPLY — END-TO-END SQL ANALYSIS
  CHAPTER 4 — ETL: TRANSFORM
  Analyst: Data Analyst
  Environment: SQL Server / SSMS

  PURPOSE
  -------
  Inspect, standardise and prepare staging data before loading analytical tables.

  CORE RULE
  ---------
  Transform only when there is evidence that a value needs transformation.

  CONTROL REQUIREMENTS:
  • replace legitimate NULL values
  • convert legitimate negative stock movements to positive
  • invent missing values
  • remove rows solely because they appear unusual
  • combine currencies without conversion
  • combine forecast versions without version controls

  SQL TECHNIQUES APPLIED
  ------------------
  Core retrieval: SELECT / WHERE / DISTINCT
  Aggregation: COUNT / GROUP BY
  Conditional logic: CASE
  Text standardisation: string functions
  Date analysis: date functions
  Relational analysis: JOINs
==============================================================================*/


USE SCIS;
GO


/*==============================================================================
  4.1 — CHECK NULLS BEFORE TRANSFORMATION

  PURPOSE:
  Profile NULL occurrence before classifying records as data-quality exceptions.

  NULL values require business-context validation before classification as data-quality issues.
==============================================================================*/

SELECT
    COUNT(*) AS total_shipments,
    COUNT(actual_delivery_date) AS rows_with_actual_delivery,
    COUNT(*) - COUNT(actual_delivery_date) AS null_actual_delivery_dates
FROM stg.shipments;


SELECT
    COUNT(*) AS total_production_orders,
    COUNT(actual_end_date) AS rows_with_actual_end_date,
    COUNT(*) - COUNT(actual_end_date) AS null_actual_end_dates
FROM stg.production_orders;


/*==============================================================================
  4.2 — CHECK DUPLICATES

  PURPOSE:
  Find repeated business keys.

  IMPORTANT:
  A duplicate business key is suspicious.
  It is not automatically deleted.

  Validate whether table grain permits repeated identifiers before classifying duplicates.
==============================================================================*/

SELECT supplier_id, COUNT(*) AS row_count
FROM stg.suppliers
GROUP BY supplier_id
HAVING COUNT(*) > 1;


SELECT product_id, COUNT(*) AS row_count
FROM stg.products
GROUP BY product_id
HAVING COUNT(*) > 1;


SELECT purchase_order_id, COUNT(*) AS row_count
FROM stg.purchase_orders
GROUP BY purchase_order_id
HAVING COUNT(*) > 1;


SELECT shipment_id, COUNT(*) AS row_count
FROM stg.shipments
GROUP BY shipment_id
HAVING COUNT(*) > 1;


/*==============================================================================
  4.3 — CHECK STRING QUALITY

  PURPOSE:
  Find accidental leading/trailing spaces.

  String validation technique:
  LTRIM() + RTRIM()

  Review precedes remediation.
==============================================================================*/

SELECT supplier_id, supplier_name
FROM stg.suppliers
WHERE supplier_name <> LTRIM(RTRIM(supplier_name));


SELECT product_id, product_name
FROM stg.products
WHERE product_name <> LTRIM(RTRIM(product_name));


/*==============================================================================
  4.4 — STANDARDISE STRINGS

  Only perform this when Chapter 2/4 inspection confirms whitespace problems.

  CONTROL RULE:
      '  ABC Supplies  '
              ↓
        'ABC Supplies'
==============================================================================*/

UPDATE stg.suppliers
SET supplier_name = LTRIM(RTRIM(supplier_name))
WHERE supplier_name <> LTRIM(RTRIM(supplier_name));


UPDATE stg.products
SET product_name = LTRIM(RTRIM(product_name))
WHERE product_name <> LTRIM(RTRIM(product_name));


/*==============================================================================
  4.5 — CHECK CATEGORY / STATUS SPELLINGS

  PURPOSE:
  Find inconsistent categories before changing them.

  DISTINCT is enough.

  Example:
      Delivered
      delivered
      DELIVERED

  These may represent the same business status.
==============================================================================*/

SELECT DISTINCT shipment_status
FROM stg.shipments
ORDER BY shipment_status;


SELECT DISTINCT order_status
FROM stg.customer_orders
ORDER BY order_status;


SELECT DISTINCT po_status
FROM stg.purchase_orders
ORDER BY po_status;


/*==============================================================================
  4.6 — STANDARDISE CONFIRMED STATUS VALUES

  USE CASE:
  Only use CASE when inspection proves several spellings mean the same thing.

  IMPORTANT:
  These mappings are EXAMPLES OF METHOD.
  Keep only mappings supported by the actual data.
==============================================================================*/

UPDATE stg.shipments
SET shipment_status =
    CASE
        WHEN UPPER(LTRIM(RTRIM(shipment_status))) = 'DELIVERED' THEN 'Delivered'
        WHEN UPPER(LTRIM(RTRIM(shipment_status))) = 'IN TRANSIT' THEN 'In Transit'
        WHEN UPPER(LTRIM(RTRIM(shipment_status))) = 'CANCELLED' THEN 'Cancelled'
        ELSE LTRIM(RTRIM(shipment_status))
    END;


/*==============================================================================
  4.7 — CHECK NUMERIC VALUES

  PURPOSE:
  Find values that require investigation.

  IMPORTANT:
  Negative quantity in stock_movements can be legitimate because inventory
  leaving the warehouse is represented by negative movement.

  Therefore:
      quantity < 0 may be valid depending on movement type
==============================================================================*/

SELECT TOP 50 *
FROM stg.stock_movements
WHERE quantity < 0
ORDER BY quantity;


SELECT TOP 50 *
FROM stg.inventory_snapshots
WHERE quantity_on_hand < 0;


SELECT TOP 50 *
FROM stg.purchase_order_lines
WHERE unit_price < 0 OR ordered_quantity < 0;


/*==============================================================================
  4.8 — CHECK IMPOSSIBLE OR SUSPICIOUS DATE RELATIONSHIPS

  Date-analysis technique:
  direct date comparison

  This step identifies exceptions for review; no automatic remediation is applied.
==============================================================================*/

-- Delivery before shipment
SELECT *
FROM stg.shipments
WHERE actual_delivery_date IS NOT NULL
  AND actual_delivery_date < shipment_date;


-- PO receipt before PO creation
SELECT *
FROM stg.goods_receipts gr
JOIN stg.purchase_orders po
    ON gr.purchase_order_id = po.purchase_order_id
WHERE gr.receipt_date < po.order_date;


/*==============================================================================
  JOIN COLUMNS
  ------------
  goods_receipts.purchase_order_id
             =
  purchase_orders.purchase_order_id
==============================================================================*/


/*==============================================================================
  4.9 — CHECK ORPHAN RECORDS

  PURPOSE:
  Identify child records whose parent does not exist.

  Example:
  purchase_order_lines says PO123 exists
  but purchase_orders contains no PO123.

  Relational validation technique:
  LEFT JOIN + WHERE parent IS NULL
==============================================================================*/

SELECT pol.*
FROM stg.purchase_order_lines pol
LEFT JOIN stg.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id
WHERE po.purchase_order_id IS NULL;


/*------------------------------------------------------------------------------
  JOIN:
  purchase_order_lines.purchase_order_id
            =
  purchase_orders.purchase_order_id
------------------------------------------------------------------------------*/


SELECT sl.*
FROM stg.shipment_lines sl
LEFT JOIN stg.shipments s
    ON sl.shipment_id = s.shipment_id
WHERE s.shipment_id IS NULL;


/*------------------------------------------------------------------------------
  JOIN:
  shipment_lines.shipment_id
          =
  shipments.shipment_id
------------------------------------------------------------------------------*/


SELECT sp.*
FROM stg.supplier_products sp
LEFT JOIN stg.suppliers s
    ON sp.supplier_id = s.supplier_id
WHERE s.supplier_id IS NULL;


/*------------------------------------------------------------------------------
  JOIN:
  supplier_products.supplier_id
           =
  suppliers.supplier_id
------------------------------------------------------------------------------*/


/*==============================================================================
  4.10 — CHECK BUSINESS-KEY RELATIONSHIPS

  PURPOSE:
  Confirm that foreign-key-style values actually map to the master tables.
==============================================================================*/

SELECT pol.*
FROM stg.purchase_order_lines pol
LEFT JOIN stg.products p
    ON pol.product_id = p.product_id
WHERE p.product_id IS NULL;


SELECT col.*
FROM stg.customer_order_lines col
LEFT JOIN stg.products p
    ON col.product_id = p.product_id
WHERE p.product_id IS NULL;


/*==============================================================================
  4.11 — CHECK CURRENCY VALUES

  CRITICAL:
  Procurement values must be converted to a common currency before aggregation.

  Identify all currencies present before financial aggregation.
==============================================================================*/

SELECT currency_code, COUNT(*) AS row_count
FROM stg.purchase_orders
GROUP BY currency_code
ORDER BY currency_code;


/*==============================================================================
  4.12 — CHECK FX COVERAGE

  ANALYTICAL OBJECTIVE:
  Validate FX-rate coverage for non-AUD transactions.

  JOIN COLUMNS:
      purchase_orders.currency_code = fx_rates.currency_code
      purchase_orders.order_date    = fx_rates.rate_date
==============================================================================*/

SELECT
    po.purchase_order_id,
    po.order_date,
    po.currency_code
FROM stg.purchase_orders po
LEFT JOIN stg.fx_rates fx
    ON po.currency_code = fx.currency_code
   AND po.order_date = fx.rate_date
WHERE po.currency_code <> 'AUD'
  AND fx.currency_code IS NULL;


/*==============================================================================
  4.13 — CHECK FORECAST VERSIONS

  CRITICAL:
  Multiple forecast versions must not be combined as though they are one
  forecast.

  First identify the versions that exist.
==============================================================================*/

SELECT forecast_version, COUNT(*) AS row_count
FROM stg.demand_forecast
GROUP BY forecast_version
ORDER BY forecast_version;


/*==============================================================================
  4.14 — CHECK TABLE GRAIN

  Example:
  shipment_lines is line grain.
  shipments is shipment grain.

  Shipment-level freight must not be aggregated after joining
  shipments to shipment_lines.

  Example of the danger:

  shipment_id   freight
  S001          $100

  Shipment has 3 lines.

  After joining:
  S001 line1    $100
  S001 line2    $100
  S001 line3    $100

  SUM(freight) = $300  <-- INVALID AGGREGATION

  Real freight = $100.

  This demonstrates the importance of validating grain before analysis.
==============================================================================*/

SELECT shipment_id, COUNT(*) AS line_count
FROM stg.shipment_lines
GROUP BY shipment_id
ORDER BY line_count DESC;


/*==============================================================================
  4.15 — CHECK PURCHASE ORDER LINE GRAIN

  A purchase order can legitimately have several lines.

  Therefore duplicate purchase_order_id values here are NORMAL.

  The expected line-level key may instead be something like:
      purchase_order_id + line_number
==============================================================================*/

SELECT purchase_order_id, COUNT(*) AS line_count
FROM stg.purchase_order_lines
GROUP BY purchase_order_id
ORDER BY line_count DESC;


/*==============================================================================
  4.16 — CHECK FOR EXACT DUPLICATES

  DISTINCT enables comparison of:
      raw rows
  versus
      unique rows

  Any variance requires further investigation.
==============================================================================*/

SELECT COUNT(*) AS total_rows
FROM stg.suppliers;

SELECT COUNT(*) AS distinct_rows
FROM
(
    SELECT DISTINCT *
    FROM stg.suppliers
) x;


/*==============================================================================
  4.17 — RECHECK TRANSFORMED VALUES

  After any approved cleaning step, inspect the results again.
==============================================================================*/

SELECT DISTINCT shipment_status
FROM stg.shipments
ORDER BY shipment_status;


SELECT TOP 20 *
FROM stg.suppliers
ORDER BY supplier_id;


/*==============================================================================
  4.18 — TRANSFORMATION QA

  The goal is NOT:
      "force the data into an artificially clean state"

  The goal is:
      "make confirmed data-quality corrections while preserving business truth."


  VALIDATION CHECKLIST
  ------------------------

  [ ] NULLs inspected before changing anything
  [ ] Duplicate business keys checked
  [ ] Table grain understood before duplicate removal
  [ ] Leading/trailing spaces checked
  [ ] Status/category spelling checked
  [ ] Only confirmed text inconsistencies standardised
  [ ] Suspicious numeric values reviewed
  [ ] Negative stock movements preserved where legitimate
  [ ] Date relationships checked
  [ ] Orphan records checked
  [ ] Product/supplier relationships checked
  [ ] Currency values reviewed
  [ ] FX-rate coverage reviewed
  [ ] Forecast versions identified
  [ ] Shipment-header measures protected from line-level duplication
  [ ] Exact duplicates investigated
  [ ] No missing values invented
  [ ] Transformation decisions are reproducible


  REVIEW CONTROL STATEMENT
  -----------------------
  The staging datasets were profiled and transformed using controlled,
  evidence-based rules.

  Transformations were limited to confirmed data-quality issues such as
  whitespace or equivalent status representations.

  Legitimate operational behaviours — including NULL dates for incomplete
  processes and signed stock movements — were preserved.

  Referential relationships, currency coverage, forecast versions and table
  grain were reviewed before analytical loading.


  CHAPTER 4 STATUS:
      TRANSFORM → COMPLETE

  NEXT:
      CHAPTER 5 — ETL: LOAD
==============================================================================*/

/*==============================================================================
  SOUTHERN CROSS INDUSTRIAL SUPPLY — END-TO-END SQL ANALYSIS
  CHAPTER 5 — ETL: LOAD
  Analyst: Data Analyst
  Environment: SQL Server / SSMS

  PURPOSE
  -------
  Load validated staging data into final analytical tables.

  PROCESS FLOW
  -----------
  STAGING
      ↓
  SELECT approved columns
      ↓
  INSERT INTO final tables
      ↓
  validate row counts
      ↓
  confirm relationships

  SQL TECHNIQUES APPLIED
  ------------------
  Core retrieval: SELECT
  Aggregation: COUNT
  Relational analysis: JOIN
==============================================================================*/


USE SCIS;
GO


/*==============================================================================
  5.1 — LOAD MASTER TABLES

  These are relatively stable reference/master datasets.

  RULE:
  Load parent/master tables before child/transaction tables where practical.
==============================================================================*/


-- ============================ REGIONS ============================

INSERT INTO dbo.regions
(
    region_id,
    region_name
)
SELECT
    region_id,
    region_name
FROM stg.regions;


/*==============================================================================
  5.2 — WAREHOUSES

  regions should already exist because warehouses may reference region_id.
==============================================================================*/

INSERT INTO dbo.warehouses
SELECT *
FROM stg.warehouses;


/*==============================================================================
  5.3 — SUPPLIERS
==============================================================================*/

INSERT INTO dbo.suppliers
SELECT *
FROM stg.suppliers;


/*==============================================================================
  5.4 — PRODUCTS
==============================================================================*/

INSERT INTO dbo.products
SELECT *
FROM stg.products;


/*==============================================================================
  5.5 — CARRIERS
==============================================================================*/

INSERT INTO dbo.carriers
SELECT *
FROM stg.carriers;


/*==============================================================================
  5.6 — FX RATES
==============================================================================*/

INSERT INTO dbo.fx_rates
SELECT *
FROM stg.fx_rates;


/*==============================================================================
  5.7 — SUPPLIER PRODUCTS

  Relationship table connecting suppliers and products.

  JOIN LOGIC LATER:
      supplier_products.supplier_id = suppliers.supplier_id
      supplier_products.product_id  = products.product_id
==============================================================================*/

INSERT INTO dbo.supplier_products
SELECT *
FROM stg.supplier_products;


/*==============================================================================
  5.8 — CONTRACTS
==============================================================================*/

INSERT INTO dbo.contracts
SELECT *
FROM stg.contracts;


/*==============================================================================
  5.9 — BOM

  Bill of Materials.

  Typically connects:
      finished product
             ↓
      component/material product

  Preserve original source relationships.
==============================================================================*/

INSERT INTO dbo.bom
SELECT *
FROM stg.bom;


/*==============================================================================
  5.10 — DEMAND FORECAST

  IMPORTANT:
  Forecast versions are preserved.

  Forecast versions must remain separate during loading.
==============================================================================*/

INSERT INTO dbo.demand_forecast
SELECT *
FROM stg.demand_forecast;


/*==============================================================================
  5.11 — CUSTOMER ORDERS

  HEADER first.
==============================================================================*/

INSERT INTO dbo.customer_orders
SELECT *
FROM stg.customer_orders;


/*==============================================================================
  5.12 — CUSTOMER ORDER LINES

  CHILD TABLE

  Expected relationship:
      customer_order_lines.customer_order_id
                  =
      customer_orders.customer_order_id
==============================================================================*/

INSERT INTO dbo.customer_order_lines
SELECT *
FROM stg.customer_order_lines;


/*==============================================================================
  5.13 — PURCHASE ORDERS

  Load header before purchase-order lines and goods receipts.
==============================================================================*/

INSERT INTO dbo.purchase_orders
SELECT *
FROM stg.purchase_orders;


/*==============================================================================
  5.14 — PURCHASE ORDER LINES

  Expected relationship:
      purchase_order_lines.purchase_order_id
                    =
      purchase_orders.purchase_order_id
==============================================================================*/

INSERT INTO dbo.purchase_order_lines
SELECT *
FROM stg.purchase_order_lines;


/*==============================================================================
  5.15 — GOODS RECEIPTS
==============================================================================*/

INSERT INTO dbo.goods_receipts
SELECT *
FROM stg.goods_receipts;


/*==============================================================================
  5.16 — SHIPMENTS

  Shipment header must be loaded before shipment lines.
==============================================================================*/

INSERT INTO dbo.shipments
SELECT *
FROM stg.shipments;


/*==============================================================================
  5.17 — SHIPMENT LINES

  IMPORTANT GRAIN RULE:
  shipment_lines = LINE level
  shipments      = SHIPMENT level

  Freight and shipment-level delivery metrics must not later be multiplied
  because a shipment may contain multiple line records.
==============================================================================*/

INSERT INTO dbo.shipment_lines
SELECT *
FROM stg.shipment_lines;


/*==============================================================================
  5.18 — INVENTORY SNAPSHOTS
==============================================================================*/

INSERT INTO dbo.inventory_snapshots
SELECT *
FROM stg.inventory_snapshots;


/*==============================================================================
  5.19 — STOCK MOVEMENTS

  IMPORTANT:
  Signed quantity is preserved.

      positive = inventory entering
      negative = inventory leaving

  Retain the signed quantity; do not apply ABS(quantity).
==============================================================================*/

INSERT INTO dbo.stock_movements
SELECT *
FROM stg.stock_movements;


/*==============================================================================
  5.20 — PRODUCTION ORDERS
==============================================================================*/

INSERT INTO dbo.production_orders
SELECT *
FROM stg.production_orders;


/*==============================================================================
  5.21 — PRODUCTION EVENTS
==============================================================================*/

INSERT INTO dbo.production_events
SELECT *
FROM stg.production_events;


/*==============================================================================
  5.22 — DOWNTIME EVENTS
==============================================================================*/

INSERT INTO dbo.downtime_events
SELECT *
FROM stg.downtime_events;


/*==============================================================================
  5.23 — QUALITY INSPECTIONS
==============================================================================*/

INSERT INTO dbo.quality_inspections
SELECT *
FROM stg.quality_inspections;


/*==============================================================================
  5.24 — RETURNS
==============================================================================*/

INSERT INTO dbo.returns
SELECT *
FROM stg.returns;


/*==============================================================================
  5.25 — WAREHOUSE OPERATIONS
==============================================================================*/

INSERT INTO dbo.warehouse_operations
SELECT *
FROM stg.warehouse_operations;


/*==============================================================================
  5.26 — POST-LOAD ROW COUNT VALIDATION

  ANALYTICAL OBJECTIVE:
      Confirm that row counts reconcile between staging and final tables.

  Expected:
      staging_count = final_count

  If not:
      investigate BEFORE continuing.
==============================================================================*/


-- Suppliers
SELECT
    (SELECT COUNT(*) FROM stg.suppliers) AS staging_rows,
    (SELECT COUNT(*) FROM dbo.suppliers) AS final_rows;


-- Products
SELECT
    (SELECT COUNT(*) FROM stg.products) AS staging_rows,
    (SELECT COUNT(*) FROM dbo.products) AS final_rows;


-- Customer Orders
SELECT
    (SELECT COUNT(*) FROM stg.customer_orders) AS staging_rows,
    (SELECT COUNT(*) FROM dbo.customer_orders) AS final_rows;


-- Customer Order Lines
SELECT
    (SELECT COUNT(*) FROM stg.customer_order_lines) AS staging_rows,
    (SELECT COUNT(*) FROM dbo.customer_order_lines) AS final_rows;


-- Purchase Orders
SELECT
    (SELECT COUNT(*) FROM stg.purchase_orders) AS staging_rows,
    (SELECT COUNT(*) FROM dbo.purchase_orders) AS final_rows;


-- Purchase Order Lines
SELECT
    (SELECT COUNT(*) FROM stg.purchase_order_lines) AS staging_rows,
    (SELECT COUNT(*) FROM dbo.purchase_order_lines) AS final_rows;


-- Shipments
SELECT
    (SELECT COUNT(*) FROM stg.shipments) AS staging_rows,
    (SELECT COUNT(*) FROM dbo.shipments) AS final_rows;


-- Shipment Lines
SELECT
    (SELECT COUNT(*) FROM stg.shipment_lines) AS staging_rows,
    (SELECT COUNT(*) FROM dbo.shipment_lines) AS final_rows;


/*==============================================================================
  5.27 — COMPACT FULL ROW-COUNT CHECK

  Set-operation technique:
  UNION ALL

  This provides a compact review-ready reconciliation output.
==============================================================================*/

SELECT 'suppliers' AS table_name,
       (SELECT COUNT(*) FROM stg.suppliers) AS staging_rows,
       (SELECT COUNT(*) FROM dbo.suppliers) AS final_rows

UNION ALL

SELECT 'products',
       (SELECT COUNT(*) FROM stg.products),
       (SELECT COUNT(*) FROM dbo.products)

UNION ALL

SELECT 'customer_orders',
       (SELECT COUNT(*) FROM stg.customer_orders),
       (SELECT COUNT(*) FROM dbo.customer_orders)

UNION ALL

SELECT 'customer_order_lines',
       (SELECT COUNT(*) FROM stg.customer_order_lines),
       (SELECT COUNT(*) FROM dbo.customer_order_lines)

UNION ALL

SELECT 'purchase_orders',
       (SELECT COUNT(*) FROM stg.purchase_orders),
       (SELECT COUNT(*) FROM dbo.purchase_orders)

UNION ALL

SELECT 'purchase_order_lines',
       (SELECT COUNT(*) FROM stg.purchase_order_lines),
       (SELECT COUNT(*) FROM dbo.purchase_order_lines)

UNION ALL

SELECT 'shipments',
       (SELECT COUNT(*) FROM stg.shipments),
       (SELECT COUNT(*) FROM dbo.shipments)

UNION ALL

SELECT 'shipment_lines',
       (SELECT COUNT(*) FROM stg.shipment_lines),
       (SELECT COUNT(*) FROM dbo.shipment_lines);


/*==============================================================================
  5.28 — FIND TABLES WHERE LOAD COUNT DOES NOT MATCH

  BUSINESS RULE:
      staging rows should equal final rows after a clean full load.

  CASE creates a standardised review status.
==============================================================================*/

SELECT
    'suppliers' AS table_name,
    (SELECT COUNT(*) FROM stg.suppliers) AS staging_rows,
    (SELECT COUNT(*) FROM dbo.suppliers) AS final_rows,

    CASE
        WHEN (SELECT COUNT(*) FROM stg.suppliers)
           = (SELECT COUNT(*) FROM dbo.suppliers)
        THEN 'PASS'
        ELSE 'CHECK'
    END AS load_status;


/*==============================================================================
  5.29 — CHECK MASTER → CHILD RELATIONSHIPS AFTER LOAD

  Example:
  Validate that every purchase-order line remains linked to a purchase-order header.
==============================================================================*/

SELECT pol.*
FROM dbo.purchase_order_lines pol
LEFT JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id
WHERE po.purchase_order_id IS NULL;


/*------------------------------------------------------------------------------
  JOIN COLUMNS

  purchase_order_lines.purchase_order_id
                   =
  purchase_orders.purchase_order_id

  EXPECTED RESULT:
  0 rows
------------------------------------------------------------------------------*/


SELECT col.*
FROM dbo.customer_order_lines col
LEFT JOIN dbo.customer_orders co
    ON col.customer_order_id = co.customer_order_id
WHERE co.customer_order_id IS NULL;


/*------------------------------------------------------------------------------
  EXPECTED:
  0 orphan customer-order lines
------------------------------------------------------------------------------*/


SELECT sl.*
FROM dbo.shipment_lines sl
LEFT JOIN dbo.shipments s
    ON sl.shipment_id = s.shipment_id
WHERE s.shipment_id IS NULL;


/*------------------------------------------------------------------------------
  EXPECTED:
  0 orphan shipment lines
------------------------------------------------------------------------------*/


/*==============================================================================
  5.30 — CHECK PRODUCT RELATIONSHIPS AFTER LOAD
==============================================================================*/

SELECT pol.*
FROM dbo.purchase_order_lines pol
LEFT JOIN dbo.products p
    ON pol.product_id = p.product_id
WHERE p.product_id IS NULL;


SELECT col.*
FROM dbo.customer_order_lines col
LEFT JOIN dbo.products p
    ON col.product_id = p.product_id
WHERE p.product_id IS NULL;


/*==============================================================================
  5.31 — SAMPLE FINAL DATA

  Final visual check:
  Confirm that the final database remains consistent with the approved staging data.
==============================================================================*/

SELECT TOP 10 *
FROM dbo.suppliers;


SELECT TOP 10 *
FROM dbo.products;


SELECT TOP 10 *
FROM dbo.purchase_orders;


SELECT TOP 10 *
FROM dbo.customer_orders;


SELECT TOP 10 *
FROM dbo.shipments;


/*==============================================================================
  5.32 — VERIFY CRITICAL BUSINESS RULES SURVIVED LOAD
==============================================================================*/


-- Signed stock movements must still exist.
SELECT TOP 20 *
FROM dbo.stock_movements
WHERE quantity < 0;


-- Legitimate incomplete shipments may still have NULL delivery dates.
SELECT TOP 20 *
FROM dbo.shipments
WHERE actual_delivery_date IS NULL;


-- Forecast versions should still remain separate.
SELECT forecast_version, COUNT(*) AS rows_per_version
FROM dbo.demand_forecast
GROUP BY forecast_version
ORDER BY forecast_version;


-- Currencies should remain identifiable.
SELECT currency_code, COUNT(*) AS row_count
FROM dbo.purchase_orders
GROUP BY currency_code
ORDER BY currency_code;


/*==============================================================================
  5.33 — LOAD QA / ANALYST VALIDATION SUMMARY

  [ ] Master/reference tables loaded
  [ ] Parent tables loaded before dependent tables where practical
  [ ] Customer-order headers and lines loaded
  [ ] Purchase-order headers and lines loaded
  [ ] Goods receipts loaded
  [ ] Shipment headers and lines loaded
  [ ] Inventory tables loaded
  [ ] Production tables loaded
  [ ] Quality tables loaded
  [ ] Returns loaded
  [ ] Warehouse operations loaded
  [ ] Staging vs final row counts checked
  [ ] Orphan relationships checked
  [ ] Product relationships checked
  [ ] Signed stock quantities preserved
  [ ] Legitimate NULL operational dates preserved
  [ ] Currency information preserved
  [ ] Forecast versions preserved
  [ ] Shipment grain distinction preserved


  REVIEW CONTROL STATEMENT
  -------------------------------

  Validated staging data was loaded into the final SCIS analytical tables.

  Row-count reconciliation was performed between staging and final tables,
  followed by referential checks on critical parent-child relationships.

  No business-rule assumptions were introduced during loading.

  Signed inventory movements, legitimate NULL operational dates, currency
  identifiers and separate forecast versions were retained.

  The analytical database is now ready for formal reconciliation and QA.


  CHAPTER 5 STATUS:
      LOAD → COMPLETE

  NEXT:
      CHAPTER 6 — DATA VALIDATION & RECONCILIATION
==============================================================================*/


/*==============================================================================
  SOUTHERN CROSS INDUSTRIAL SUPPLY — END-TO-END SQL ANALYSIS
  CHAPTER 6 — DATA VALIDATION & RECONCILIATION
  Analyst: Data Analyst
  Environment: SQL Server / SSMS

  PURPOSE
  -------
  Validate that the final analytical tables are complete, consistent and safe
  to analyse.

  PROCESS FLOW
  -----------
  1. Row counts
  2. Key uniqueness
  3. Orphan checks
  4. Grain checks
  5. NULL checks
  6. Date checks
  7. Currency checks
  8. Forecast-version checks
  9. Join multiplication checks
  10. Reconciliation

  SQL TECHNIQUES APPLIED
  ------------------
  Core retrieval: SELECT / WHERE / DISTINCT
  Aggregation: COUNT / SUM / GROUP BY / HAVING
  Conditional logic: CASE
  Date analysis: date functions
  Relational analysis: JOINs
  Set operations: UNION ALL
  Relational validation: subqueries
==============================================================================*/


USE SCIS;
GO


/*==============================================================================
  6.1 — FINAL TABLE ROW COUNTS

  PURPOSE:
  Confirm all expected analytical tables contain data.

  Unexpected zero-row results in major tables require investigation.
==============================================================================*/

SELECT 'regions' AS table_name, COUNT(*) AS row_count FROM dbo.regions
UNION ALL SELECT 'warehouses',           COUNT(*) FROM dbo.warehouses
UNION ALL SELECT 'suppliers',            COUNT(*) FROM dbo.suppliers
UNION ALL SELECT 'products',             COUNT(*) FROM dbo.products
UNION ALL SELECT 'supplier_products',    COUNT(*) FROM dbo.supplier_products
UNION ALL SELECT 'contracts',            COUNT(*) FROM dbo.contracts
UNION ALL SELECT 'bom',                  COUNT(*) FROM dbo.bom
UNION ALL SELECT 'fx_rates',             COUNT(*) FROM dbo.fx_rates
UNION ALL SELECT 'demand_forecast',      COUNT(*) FROM dbo.demand_forecast
UNION ALL SELECT 'customer_orders',      COUNT(*) FROM dbo.customer_orders
UNION ALL SELECT 'customer_order_lines', COUNT(*) FROM dbo.customer_order_lines
UNION ALL SELECT 'shipments',            COUNT(*) FROM dbo.shipments
UNION ALL SELECT 'shipment_lines',       COUNT(*) FROM dbo.shipment_lines
UNION ALL SELECT 'purchase_orders',      COUNT(*) FROM dbo.purchase_orders
UNION ALL SELECT 'purchase_order_lines', COUNT(*) FROM dbo.purchase_order_lines
UNION ALL SELECT 'goods_receipts',       COUNT(*) FROM dbo.goods_receipts
UNION ALL SELECT 'inventory_snapshots',  COUNT(*) FROM dbo.inventory_snapshots
UNION ALL SELECT 'stock_movements',      COUNT(*) FROM dbo.stock_movements
UNION ALL SELECT 'production_orders',    COUNT(*) FROM dbo.production_orders
UNION ALL SELECT 'production_events',    COUNT(*) FROM dbo.production_events
UNION ALL SELECT 'downtime_events',      COUNT(*) FROM dbo.downtime_events
UNION ALL SELECT 'quality_inspections',  COUNT(*) FROM dbo.quality_inspections
UNION ALL SELECT 'returns',              COUNT(*) FROM dbo.returns
UNION ALL SELECT 'warehouse_operations', COUNT(*) FROM dbo.warehouse_operations
UNION ALL SELECT 'carriers',             COUNT(*) FROM dbo.carriers
ORDER BY table_name;


/*==============================================================================
  6.2 — STAGING VS FINAL RECONCILIATION

  EXPECTED:
      staging_rows = final_rows

  Count variances do not automatically indicate failure and require grain/context review.
  It means the reason must be documented.
==============================================================================*/

SELECT
    'suppliers' AS table_name,
    (SELECT COUNT(*) FROM stg.suppliers) AS staging_rows,
    (SELECT COUNT(*) FROM dbo.suppliers) AS final_rows,
    CASE
        WHEN (SELECT COUNT(*) FROM stg.suppliers)
           = (SELECT COUNT(*) FROM dbo.suppliers)
        THEN 'PASS'
        ELSE 'CHECK'
    END AS status

UNION ALL

SELECT
    'products',
    (SELECT COUNT(*) FROM stg.products),
    (SELECT COUNT(*) FROM dbo.products),
    CASE
        WHEN (SELECT COUNT(*) FROM stg.products)
           = (SELECT COUNT(*) FROM dbo.products)
        THEN 'PASS'
        ELSE 'CHECK'
    END

UNION ALL

SELECT
    'purchase_orders',
    (SELECT COUNT(*) FROM stg.purchase_orders),
    (SELECT COUNT(*) FROM dbo.purchase_orders),
    CASE
        WHEN (SELECT COUNT(*) FROM stg.purchase_orders)
           = (SELECT COUNT(*) FROM dbo.purchase_orders)
        THEN 'PASS'
        ELSE 'CHECK'
    END

UNION ALL

SELECT
    'shipments',
    (SELECT COUNT(*) FROM stg.shipments),
    (SELECT COUNT(*) FROM dbo.shipments),
    CASE
        WHEN (SELECT COUNT(*) FROM stg.shipments)
           = (SELECT COUNT(*) FROM dbo.shipments)
        THEN 'PASS'
        ELSE 'CHECK'
    END;


/*==============================================================================
  6.3 — PRIMARY / BUSINESS KEY UNIQUENESS

  PURPOSE:
  Header/master IDs should normally occur once.

  HAVING COUNT(*) > 1 finds duplicates.
==============================================================================*/

SELECT supplier_id, COUNT(*) AS occurrences
FROM dbo.suppliers
GROUP BY supplier_id
HAVING COUNT(*) > 1;


SELECT product_id, COUNT(*) AS occurrences
FROM dbo.products
GROUP BY product_id
HAVING COUNT(*) > 1;


SELECT purchase_order_id, COUNT(*) AS occurrences
FROM dbo.purchase_orders
GROUP BY purchase_order_id
HAVING COUNT(*) > 1;


SELECT customer_order_id, COUNT(*) AS occurrences
FROM dbo.customer_orders
GROUP BY customer_order_id
HAVING COUNT(*) > 1;


SELECT shipment_id, COUNT(*) AS occurrences
FROM dbo.shipments
GROUP BY shipment_id
HAVING COUNT(*) > 1;


/*==============================================================================
  6.4 — CHILD TABLE GRAIN CHECK

  IMPORTANT:
  Repeated header IDs in line tables are NORMAL.

  Example:
  PO1001
      line 1
      line 2
      line 3

  Repeated purchase_order_id values are expected at line grain and do not indicate duplicate rows.
==============================================================================*/

SELECT purchase_order_id, COUNT(*) AS line_count
FROM dbo.purchase_order_lines
GROUP BY purchase_order_id
ORDER BY line_count DESC;


SELECT customer_order_id, COUNT(*) AS line_count
FROM dbo.customer_order_lines
GROUP BY customer_order_id
ORDER BY line_count DESC;


SELECT shipment_id, COUNT(*) AS line_count
FROM dbo.shipment_lines
GROUP BY shipment_id
ORDER BY line_count DESC;


/*==============================================================================
  6.5 — ORPHAN PURCHASE ORDER LINES

  JOIN COLUMNS:
      purchase_order_lines.purchase_order_id
                    =
      purchase_orders.purchase_order_id

  EXPECTED:
  0 rows
==============================================================================*/

SELECT pol.*
FROM dbo.purchase_order_lines pol
LEFT JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id
WHERE po.purchase_order_id IS NULL;


/*==============================================================================
  6.6 — ORPHAN CUSTOMER ORDER LINES

  JOIN COLUMNS:
      customer_order_lines.customer_order_id
                    =
      customer_orders.customer_order_id
==============================================================================*/

SELECT col.*
FROM dbo.customer_order_lines col
LEFT JOIN dbo.customer_orders co
    ON col.customer_order_id = co.customer_order_id
WHERE co.customer_order_id IS NULL;


/*==============================================================================
  6.7 — ORPHAN SHIPMENT LINES

  JOIN COLUMNS:
      shipment_lines.shipment_id
              =
      shipments.shipment_id
==============================================================================*/

SELECT sl.*
FROM dbo.shipment_lines sl
LEFT JOIN dbo.shipments s
    ON sl.shipment_id = s.shipment_id
WHERE s.shipment_id IS NULL;


/*==============================================================================
  6.8 — PRODUCT RELATIONSHIP CHECKS
==============================================================================*/

SELECT pol.*
FROM dbo.purchase_order_lines pol
LEFT JOIN dbo.products p
    ON pol.product_id = p.product_id
WHERE p.product_id IS NULL;


SELECT col.*
FROM dbo.customer_order_lines col
LEFT JOIN dbo.products p
    ON col.product_id = p.product_id
WHERE p.product_id IS NULL;


SELECT sl.*
FROM dbo.shipment_lines sl
LEFT JOIN dbo.products p
    ON sl.product_id = p.product_id
WHERE p.product_id IS NULL;


/*==============================================================================
  6.9 — SUPPLIER RELATIONSHIP CHECK
==============================================================================*/

SELECT po.*
FROM dbo.purchase_orders po
LEFT JOIN dbo.suppliers s
    ON po.supplier_id = s.supplier_id
WHERE s.supplier_id IS NULL;


/*==============================================================================
  6.10 — NULL PROFILE

  PURPOSE:
  Profile NULL behaviour before using fields in KPI calculations.

  IMPORTANT:
  NULL may be legitimate.

  Example:
  actual_delivery_date NULL
      = shipment may still be open/in transit
==============================================================================*/

SELECT
    COUNT(*) AS total_shipments,
    COUNT(actual_delivery_date) AS delivered_date_present,
    COUNT(*) - COUNT(actual_delivery_date) AS null_delivery_dates
FROM dbo.shipments;


SELECT
    COUNT(*) AS total_production_orders,
    COUNT(actual_end_date) AS actual_end_present,
    COUNT(*) - COUNT(actual_end_date) AS null_actual_end_dates
FROM dbo.production_orders;


/*==============================================================================
  6.11 — DATE LOGIC CHECKS

  PURPOSE:
  Find impossible or suspicious date sequences.
==============================================================================*/


-- Shipment delivered before it was shipped
SELECT *
FROM dbo.shipments
WHERE actual_delivery_date IS NOT NULL
  AND actual_delivery_date < shipment_date;


-- Purchase-order receipt before PO creation
SELECT
    gr.*,
    po.order_date
FROM dbo.goods_receipts gr
JOIN dbo.purchase_orders po
    ON gr.purchase_order_id = po.purchase_order_id
WHERE gr.receipt_date < po.order_date;


/*==============================================================================
  6.12 — PROJECT DATE RANGE CHECK

  Expected project period is approximately:
      2025-01-01 → 2026-06-30

  Out-of-range records are reviewed before any exclusion decision.
==============================================================================*/

SELECT
    MIN(order_date) AS first_order,
    MAX(order_date) AS last_order
FROM dbo.customer_orders;


SELECT
    MIN(order_date) AS first_po,
    MAX(order_date) AS last_po
FROM dbo.purchase_orders;


SELECT
    MIN(shipment_date) AS first_shipment,
    MAX(shipment_date) AS last_shipment
FROM dbo.shipments;


/*==============================================================================
  6.13 — NUMERIC SANITY CHECK

  Signed stock movements are legitimate.

  Therefore:
  quantity < 0 is not an automatic error.
==============================================================================*/

SELECT TOP 50 *
FROM dbo.stock_movements
WHERE quantity < 0
ORDER BY quantity;


/*------------------------------------------------------------------------------
  Values that are more suspicious:
------------------------------------------------------------------------------*/

SELECT *
FROM dbo.purchase_order_lines
WHERE ordered_quantity < 0
   OR unit_price < 0;


/*==============================================================================
  6.14 — CURRENCY VALIDATION

  PURPOSE:
  Identify currencies before financial aggregation.

  CONTROL REQUIREMENTS:
      SUM(all PO values)

  unless different currencies have first been converted consistently.
==============================================================================*/

SELECT
    currency_code,
    COUNT(*) AS purchase_orders
FROM dbo.purchase_orders
GROUP BY currency_code
ORDER BY currency_code;


/*==============================================================================
  6.15 — FX RATE COVERAGE

  JOIN COLUMNS:
      purchase_orders.currency_code = fx_rates.currency_code
      purchase_orders.order_date    = fx_rates.rate_date

  PURPOSE:
  Find transactions that require FX conversion but lack a matching rate.
==============================================================================*/

SELECT
    po.purchase_order_id,
    po.order_date,
    po.currency_code
FROM dbo.purchase_orders po
LEFT JOIN dbo.fx_rates fx
    ON po.currency_code = fx.currency_code
   AND po.order_date = fx.rate_date
WHERE po.currency_code <> 'AUD'
  AND fx.currency_code IS NULL;


/*==============================================================================
  6.16 — FORECAST VERSION VALIDATION

  Different forecast versions must remain separate.

  Example:
      Version 1 = January forecast
      Version 2 = revised February forecast

  Summing both would double-count expected demand.
==============================================================================*/

SELECT
    forecast_version,
    COUNT(*) AS rows_per_version
FROM dbo.demand_forecast
GROUP BY forecast_version
ORDER BY forecast_version;


/*==============================================================================
  6.17 — SHIPMENT GRAIN / DOUBLE-COUNTING TEST

  THIS IS ONE OF THE MOST IMPORTANT CHECKS IN THE PROJECT.

  shipments      = one row per shipment
  shipment_lines = many rows per shipment

  Joining shipment-level freight to shipment_lines causes the freight value to repeat by line:
  freight repeats for every line.

  Example:
      Shipment freight = $100
      3 shipment lines

  Joined output:
      line1 $100
      line2 $100
      line3 $100

  SUM = $300  <-- INVALID AGGREGATION
==============================================================================*/


-- TRUE shipment-level freight
SELECT SUM(freight_cost) AS true_freight
FROM dbo.shipments;


/*------------------------------------------------------------------------------
  Compare against freight after line-grain join.
  If this number is larger, the join multiplied shipment-level freight.
------------------------------------------------------------------------------*/

SELECT SUM(s.freight_cost) AS duplicated_freight_after_join
FROM dbo.shipments s
JOIN dbo.shipment_lines sl
    ON s.shipment_id = sl.shipment_id;


/*------------------------------------------------------------------------------
  JOIN COLUMN:
      shipments.shipment_id = shipment_lines.shipment_id
------------------------------------------------------------------------------*/


/*==============================================================================
  6.18 — JOIN MULTIPLICATION TEST

  BEFORE JOIN:
  Count shipment headers.

  AFTER JOIN:
  Count joined rows.

  Difference is expected because one shipment can contain many lines.

  This demonstrates the importance of grain validation.
==============================================================================*/

SELECT COUNT(*) AS shipment_header_rows
FROM dbo.shipments;


SELECT COUNT(*) AS joined_rows
FROM dbo.shipments s
JOIN dbo.shipment_lines sl
    ON s.shipment_id = sl.shipment_id;


/*==============================================================================
  6.19 — SAFE SHIPMENT-LEVEL ANALYSIS

  If analysing shipment-level freight:
      use shipments directly.

  Join shipment_lines only when line-level information is required.
==============================================================================*/

SELECT
    carrier_id,
    COUNT(*) AS shipments,
    SUM(freight_cost) AS total_freight
FROM dbo.shipments
GROUP BY carrier_id;


/*==============================================================================
  6.20 — PURCHASE ORDER HEADER/LINE GRAIN TEST

  Same principle.

  purchase_orders       = PO header
  purchase_order_lines  = PO lines

  Header-level values may repeat when joined to line-level records.
==============================================================================*/

SELECT COUNT(*) AS po_header_rows
FROM dbo.purchase_orders;


SELECT COUNT(*) AS po_line_rows
FROM dbo.purchase_order_lines;


SELECT COUNT(*) AS joined_rows
FROM dbo.purchase_orders po
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id;


/*==============================================================================
  6.21 — CHECK FOR DUPLICATE MULTIPLICATION ACROSS MULTIPLE JOINS

  Example:
      purchase_orders
           ↓
      purchase_order_lines
           ↓
      goods_receipts

  Multiple lines + multiple receipts can multiply rows.

  Review counts by purchase order before reconciliation.
==============================================================================*/

SELECT
    po.purchase_order_id,
    COUNT(*) AS joined_rows
FROM dbo.purchase_orders po
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id
GROUP BY po.purchase_order_id
ORDER BY joined_rows DESC;


/*==============================================================================
  6.22 — QUANTITY RECONCILIATION EXAMPLE

  ANALYTICAL OBJECTIVE:
  Assess whether ordered quantity broadly reconciles to received quantity.

  IMPORTANT:
  This is a VALIDATION comparison, not yet supplier-performance analysis.
==============================================================================*/

SELECT
    pol.purchase_order_id,
    SUM(pol.ordered_quantity) AS ordered_qty,
    SUM(gr.received_quantity) AS received_qty
FROM dbo.purchase_order_lines pol
JOIN dbo.goods_receipts gr
    ON pol.purchase_order_id = gr.purchase_order_id
GROUP BY pol.purchase_order_id;


/*==============================================================================
  CAUTION:
  The query above is only valid if the grain of goods_receipts supports this
  direct relationship.

  If multiple PO lines and multiple receipts exist independently under the same
  PO, joining only on purchase_order_id could multiply quantities.

  Therefore always confirm whether a more detailed key exists, such as:

      purchase_order_id + line_number
      product_id
      receipt_line_id

  Successful query execution does not establish analytical validity.
==============================================================================*/


/*==============================================================================
  6.23 — INVENTORY MOVEMENT RECONCILIATION

  ANALYTICAL OBJECTIVE:
  Calculate net stock movement by product.

  Signed movement quantities support direct calculation:
      receipts      positive
      issues        negative

  SUM(quantity) gives net movement.
==============================================================================*/

SELECT
    product_id,
    SUM(quantity) AS net_stock_movement
FROM dbo.stock_movements
GROUP BY product_id
ORDER BY product_id;


/*==============================================================================
  6.24 — STATUS DISTRIBUTION CHECK

  PURPOSE:
  Validate category values before KPI calculation.
==============================================================================*/

SELECT shipment_status, COUNT(*) AS rows
FROM dbo.shipments
GROUP BY shipment_status
ORDER BY rows DESC;


SELECT order_status, COUNT(*) AS rows
FROM dbo.customer_orders
GROUP BY order_status
ORDER BY rows DESC;


/*==============================================================================
  6.25 — DENOMINATOR CHECK

  CRITICAL ANALYST RULE:
  Every percentage requires the correct denominator.

  Example:
      Late delivery %
      = late delivered shipments / delivered shipments

  NOT necessarily:
      late shipments / all shipment records

  because open/in-transit shipments may not yet have an actual delivery date.
==============================================================================*/

SELECT
    COUNT(*) AS all_shipments,
    COUNT(actual_delivery_date) AS completed_shipments
FROM dbo.shipments;


/*==============================================================================
  6.26 — EXAMPLE VALIDATED LATE-DELIVERY DENOMINATOR

  DATEDIFF:
      promised date → actual delivery date

  Only completed shipments belong in this denominator.
==============================================================================*/

SELECT
    COUNT(*) AS completed_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date THEN 1
            ELSE 0
        END
    ) AS late_shipments,

    100.0 *
    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date THEN 1
            ELSE 0
        END
    )
    / NULLIF(COUNT(*), 0) AS late_delivery_pct

FROM dbo.shipments
WHERE actual_delivery_date IS NOT NULL;


/*==============================================================================
  NOTE:
  NULLIF prevents divide-by-zero.

  This is standard analytical SQL used to protect calculations from divide-by-zero errors.

  Interpretation:
      NULLIF(COUNT(*),0)

  means:
      "If the denominator is zero, return NULL to prevent a divide-by-zero runtime error."

  Implementation requirement:
      Useful but not required for the current validation step.
==============================================================================*/


/*==============================================================================
  6.27 — VALIDATION SUMMARY

  VALIDATION OUTCOME

  1. Final tables contain expected data.
  2. Staging and final loads reconcile.
  3. Master/header keys are checked for duplication.
  4. Child-table repetition is interpreted according to grain.
  5. Parent-child relationships are checked.
  6. NULL behaviour is understood.
  7. Date relationships are checked.
  8. Currency issues are identified before aggregation.
  9. Forecast versions remain separate.
  10. Shipment-level metrics are protected from line-level duplication.
  11. Multi-table joins are checked for row multiplication.
  12. KPI denominators are defined before business analysis.


  ANALYST VALIDATION SUMMARY
  -----------------------

  [ ] Source → final row counts reconciled
  [ ] Key uniqueness reviewed
  [ ] Child-table grain confirmed
  [ ] Orphan records checked
  [ ] Product relationships checked
  [ ] Supplier relationships checked
  [ ] NULL behaviour reviewed
  [ ] Date ranges reviewed
  [ ] Impossible date sequences checked
  [ ] Signed stock movement logic retained
  [ ] Currency codes reviewed
  [ ] FX-rate coverage checked
  [ ] Forecast versions reviewed
  [ ] Shipment grain tested
  [ ] Header-to-line multiplication tested
  [ ] Multi-table join multiplication considered
  [ ] Denominators validated
  [ ] No query accepted merely because it executed


  REVIEW CONTROL STATEMENT
  -------------------------------

  The final SCIS analytical dataset was reconciled against staging and subjected
  to structural, relational and business-rule validation.

  Key controls included row-count reconciliation, business-key uniqueness,
  orphan detection, grain validation, NULL review, date sequencing, currency
  coverage, forecast-version separation and join-multiplication testing.

  Particular attention was given to shipment-level measures such as freight,
  because these values can be incorrectly duplicated when shipment headers are
  joined to shipment-line data.

  KPI denominator logic was also reviewed before analytical calculations.

  Any unresolved exceptions should be documented before downstream analysis.


  CHAPTER 6 STATUS:
      DATA VALIDATION & RECONCILIATION → COMPLETE

  NEXT:
      CHAPTER 7 — DATA MODELLING
==============================================================================*/
/*==============================================================================
  SOUTHERN CROSS INDUSTRIAL SUPPLY — END-TO-END SQL ANALYSIS
  CHAPTER 7 — DATA MODELLING
  Analyst: Data Analyst
  Environment: SQL Server / SSMS

  PURPOSE
  -------
  Define the analytical structure of the SCIS database before EDA.

  MODEL REVIEW OBJECTIVES:
  1. Define the business purpose of each table.
  2. Document the grain of each table.
  3. Identify relationship columns between tables.
  4. Identify one-to-many relationships.
  5. Identify joins with elevated duplication risk.
  6. Identify potential double-counting paths.

  IMPORTANT:
  The objective is not to introduce unnecessary warehouse complexity.

  This project already has relational analytical tables.

  The analytical requirement is to understand and document the model accurately.

  SQL TECHNIQUES APPLIED
  ------------------
  Core retrieval: SELECT
  Aggregation: COUNT / GROUP BY
  Relational analysis: JOINs
==============================================================================*/


USE SCIS;
GO


/*==============================================================================
  7.1 — IDENTIFY MAIN TABLE GROUPS
==============================================================================*/

/*
  MASTER / DIMENSION-LIKE TABLES
  ------------------------------
  regions
  warehouses
  suppliers
  products
  carriers

  These usually describe business entities.


  RELATIONSHIP / REFERENCE TABLES
  -------------------------------
  supplier_products
  contracts
  bom
  fx_rates


  TRANSACTION / FACT-LIKE TABLES
  ------------------------------
  customer_orders
  customer_order_lines

  purchase_orders
  purchase_order_lines
  goods_receipts

  shipments
  shipment_lines

  inventory_snapshots
  stock_movements

  production_orders
  production_events
  downtime_events

  quality_inspections
  returns
  warehouse_operations

  demand_forecast
*/


/*==============================================================================
  7.2 — DOCUMENT TABLE GRAIN

  GRAIN = the business meaning represented by one row.

  This is one of the most important concepts in the entire project.
==============================================================================*/

/*
  TABLE                         ONE ROW REPRESENTS
  ---------------------------------------------------------------------------
  regions                       one region
  warehouses                    one warehouse
  suppliers                     one supplier
  products                      one product
  carriers                      one carrier

  supplier_products             one supplier-product relationship
  contracts                     one contract
  bom                           one product-component relationship
  fx_rates                      one currency/date exchange rate

  customer_orders               one customer-order header
  customer_order_lines          one customer-order line

  purchase_orders               one purchase-order header
  purchase_order_lines          one purchase-order line
  goods_receipts                one receipt / receipt record

  shipments                     one shipment
  shipment_lines                one shipment line

  inventory_snapshots           one inventory snapshot record
  stock_movements               one inventory movement

  production_orders             one production order
  production_events             one production event
  downtime_events               one downtime event

  quality_inspections           one quality inspection
  returns                       one return record
  warehouse_operations          one warehouse activity/operation

  demand_forecast               one forecast observation/version record
*/


/*==============================================================================
  7.3 — VERIFY HEADER TABLE GRAIN

  PURPOSE:
  IDs expected to identify one header row should normally occur once.
==============================================================================*/

SELECT purchase_order_id, COUNT(*) AS rows_per_po
FROM dbo.purchase_orders
GROUP BY purchase_order_id
HAVING COUNT(*) > 1;


SELECT customer_order_id, COUNT(*) AS rows_per_order
FROM dbo.customer_orders
GROUP BY customer_order_id
HAVING COUNT(*) > 1;


SELECT shipment_id, COUNT(*) AS rows_per_shipment
FROM dbo.shipments
GROUP BY shipment_id
HAVING COUNT(*) > 1;


/*
  EXPECTED:
  Normally 0 rows.

  If rows appear:
  investigate before analysis.
*/


/*==============================================================================
  7.4 — VERIFY LINE TABLE GRAIN

  Repeated HEADER IDs are expected because one header can contain many lines.
==============================================================================*/

SELECT purchase_order_id, COUNT(*) AS number_of_lines
FROM dbo.purchase_order_lines
GROUP BY purchase_order_id
ORDER BY number_of_lines DESC;


SELECT customer_order_id, COUNT(*) AS number_of_lines
FROM dbo.customer_order_lines
GROUP BY customer_order_id
ORDER BY number_of_lines DESC;


SELECT shipment_id, COUNT(*) AS number_of_lines
FROM dbo.shipment_lines
GROUP BY shipment_id
ORDER BY number_of_lines DESC;


/*
  Example:

      purchase_orders

      PO1001
         |
         +------ line 1
         +------ line 2
         +------ line 3

  purchase_orders = ONE side
  purchase_order_lines = MANY side
*/


/*==============================================================================
  7.5 — CORE PROCUREMENT MODEL

      suppliers
          |
          | supplier_id
          v
      purchase_orders
          |
          | purchase_order_id
          v
      purchase_order_lines
          |
          | product_id
          v
       products


  JOIN COLUMNS
  ------------
  suppliers.supplier_id
      =
  purchase_orders.supplier_id


  purchase_orders.purchase_order_id
      =
  purchase_order_lines.purchase_order_id


  purchase_order_lines.product_id
      =
  products.product_id
==============================================================================*/


SELECT TOP 20
    po.purchase_order_id,
    s.supplier_name,
    p.product_name,
    pol.ordered_quantity,
    pol.unit_price
FROM dbo.purchase_orders po
JOIN dbo.suppliers s
    ON po.supplier_id = s.supplier_id
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id
JOIN dbo.products p
    ON pol.product_id = p.product_id;


/*==============================================================================
  7.6 — CUSTOMER ORDER MODEL

      customer_orders
             |
             | customer_order_id
             v
      customer_order_lines
             |
             | product_id
             v
          products
==============================================================================*/

SELECT TOP 20
    co.customer_order_id,
    co.order_date,
    p.product_name,
    col.quantity
FROM dbo.customer_orders co
JOIN dbo.customer_order_lines col
    ON co.customer_order_id = col.customer_order_id
JOIN dbo.products p
    ON col.product_id = p.product_id;


/*==============================================================================
  7.7 — SHIPMENT MODEL

      shipments
          |
          | shipment_id
          v
      shipment_lines
          |
          | product_id
          v
       products


  CRITICAL WARNING:

  shipments = SHIPMENT grain
  shipment_lines = LINE grain

  Therefore shipment-level values can repeat after the join.
==============================================================================*/

SELECT TOP 20
    s.shipment_id,
    s.carrier_id,
    s.freight_cost,
    sl.product_id
FROM dbo.shipments s
JOIN dbo.shipment_lines sl
    ON s.shipment_id = sl.shipment_id;


/*
  Example:

      shipment S001     freight = $100

      lines:
          product A
          product B
          product C


  JOIN RESULT

      S001    A    $100
      S001    B    $100
      S001    C    $100


  $100 did NOT become $300.

  The join repeats the shipment-level value across matching line-level rows.

  Therefore:

      SUM(s.freight_cost)

  after this join may be materially overstated.
*/


/*==============================================================================
  7.8 — CARRIER MODEL

      carriers
          |
          | carrier_id
          v
      shipments
==============================================================================*/

SELECT TOP 20
    s.shipment_id,
    c.carrier_id,
    s.freight_cost
FROM dbo.shipments s
JOIN dbo.carriers c
    ON s.carrier_id = c.carrier_id;


/*==============================================================================
  7.9 — SUPPLIER-PRODUCT MODEL

  supplier_products is a bridge/relationship table.

      suppliers
          |
          | supplier_id
          v
  supplier_products
          ^
          | product_id
          |
       products


  This identifies supplier-to-product sourcing coverage.
==============================================================================*/

SELECT TOP 20
    s.supplier_name,
    p.product_name
FROM dbo.supplier_products sp
JOIN dbo.suppliers s
    ON sp.supplier_id = s.supplier_id
JOIN dbo.products p
    ON sp.product_id = p.product_id;


/*==============================================================================
  7.10 — BOM MODEL

  BOM = Bill of Materials

  Concept:

      Finished Product
            |
            +------ Component A
            +------ Component B
            +------ Component C


  This relationship supports linkage between production requirements and component demand.

  IMPORTANT:
  Use the actual BOM key columns from the dataset when analysing it.

  Relationships must be supported by documented business keys, not inferred solely from similar column names.
==============================================================================*/


/*==============================================================================
  7.11 — INVENTORY MODEL

  Two different inventory concepts exist:

      inventory_snapshots
          = inventory level at a particular point in time

      stock_movements
          = inventory moving in/out over time


  THESE ARE NOT THE SAME THING.


  Example:

      Snapshot:
          Product A = 500 units on hand

      Movements:
          +100 receipt
           -50 issue
           -20 issue


  Net movement = +30

  But +30 is not automatically the current stock balance.

  Snapshot and movement data answer different questions.
==============================================================================*/


SELECT
    product_id,
    SUM(quantity) AS net_movement
FROM dbo.stock_movements
GROUP BY product_id;


/*==============================================================================
  7.12 — PRODUCTION MODEL

  Conceptual flow:

      production_orders
             |
             v
      production_events
             |
             +------ downtime_events
             |
             +------ quality_inspections


  Exact joins must follow the real identifiers in the source tables.

  CONTROL REQUIREMENTS:
  Do not join tables solely because date or product identifiers appear similar.

  Prefer explicit production-order/event keys.
==============================================================================*/


/*==============================================================================
  7.13 — WAREHOUSE MODEL

      warehouses
           |
           +------ inventory_snapshots
           |
           +------ stock_movements
           |
           +------ warehouse_operations


  This allows warehouse-level analysis such as:

      inventory
      throughput
      operational activity
      stock movements
      productivity
==============================================================================*/


/*==============================================================================
  7.14 — REGION → WAREHOUSE MODEL

      regions
         |
         | region_id
         v
      warehouses


  Then warehouse activity may eventually be analysed by region.
==============================================================================*/

SELECT TOP 20
    r.region_name,
    w.*
FROM dbo.warehouses w
JOIN dbo.regions r
    ON w.region_id = r.region_id;


/*==============================================================================
  7.15 — FORECAST MODEL

  demand_forecast contains forecast observations.

  CRITICAL DIMENSIONS may include:

      product
      warehouse/location
      forecast period
      forecast version


  A forecast version is part of the analytical meaning of the row.

  Version A + Version B must not automatically be summed.
==============================================================================*/

SELECT
    forecast_version,
    COUNT(*) AS rows
FROM dbo.demand_forecast
GROUP BY forecast_version;


/*==============================================================================
  7.16 — FX MODEL

  FX rates are used when monetary transactions exist in multiple currencies.

  Concept:

      transaction
          |
          | currency + relevant date
          v
      fx_rates
          |
          v
      AUD-normalised value


  CRITICAL:
  Do not aggregate directly:

      AUD + USD + EUR

  as if they were the same unit.
==============================================================================*/


/*==============================================================================
  7.17 — IDENTIFY ONE-TO-MANY RELATIONSHIPS

  Core relationships:

  suppliers
      1 → many purchase_orders

  purchase_orders
      1 → many purchase_order_lines

  customer_orders
      1 → many customer_order_lines

  shipments
      1 → many shipment_lines

  products
      1 → many order / procurement / shipment records

  warehouses
      1 → many inventory / warehouse activity records

  carriers
      1 → many shipments
==============================================================================*/


/*==============================================================================
  7.18 — ONE-TO-MANY RELATIONSHIP IMPACT

  Imagine:

      purchase_order
          PO1

      purchase_order_lines
          PO1 Product A
          PO1 Product B

      goods_receipts
          PO1 Receipt 1
          PO1 Receipt 2


  Joining all three tables only on purchase_order_id produces:

      2 lines × 2 receipts = 4 rows


  This can create MULTIPLICATION.

  Original:
      2 PO lines
      2 receipts

  Joined:
      4 rows

  The SQL engine returns the relationship specified by the join logic.

  Model grain and relationship cardinality determine analytical validity.
==============================================================================*/


/*==============================================================================
  7.19 — TEST A POSSIBLE MULTIPLICATION
==============================================================================*/

SELECT
    po.purchase_order_id,
    COUNT(*) AS joined_rows
FROM dbo.purchase_orders po
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id
GROUP BY po.purchase_order_id
ORDER BY joined_rows DESC;


/*
  A high joined-row count does not automatically indicate a data-quality issue.

  It indicates:

      Do not proceed until the relationship is validated.

      Check the grain.

      Validate whether goods_receipts requires a more granular join key.
*/


/*==============================================================================
  7.20 — SAFE ANALYTICAL MODEL PRINCIPLE

  PRE-JOIN VALIDATION CHECKLIST:

  1. Confirm the grain of the left table.
  2. Confirm the grain of the right table.
  3. Confirm the columns that define the relationship.
  4. Classify relationship cardinality as 1:1, 1:many, or many:many.
  5. Assess whether monetary or quantity measures will repeat.
  6. Confirm whether the join changes result grain.

  THIS IS ANALYST MODELLING.
==============================================================================*/


/*==============================================================================
  7.21 — SCIS HIGH-LEVEL MODEL

                              REGIONS
                                 |
                            WAREHOUSES
                                 |
              +------------------+------------------+
              |                  |                  |
          INVENTORY          WAREHOUSE          STOCK
          SNAPSHOTS          OPERATIONS        MOVEMENTS


  SUPPLIERS -------- PURCHASE ORDERS -------- PURCHASE ORDER LINES
      |                                             |
      |                                             |
      +------- SUPPLIER PRODUCTS ---------------- PRODUCTS
                                                    |
                                                    |
                              +---------------------+----------------------+
                              |                     |                      |
                     CUSTOMER ORDER LINES     SHIPMENT LINES              BOM
                              |                     |
                       CUSTOMER ORDERS          SHIPMENTS
                                                    |
                                                 CARRIERS


                          PRODUCTION ORDERS
                                  |
                          PRODUCTION EVENTS
                             /          \
                     DOWNTIME        QUALITY


                      DEMAND FORECAST

                           FX RATES
                              |
                    FINANCIAL CONVERSION
==============================================================================*/


/*==============================================================================
  7.22 — MODEL VALIDATION CHECKLIST

  [ ] Every major table has a defined grain

  [ ] Header vs line tables are distinguished

  [ ] Primary business IDs have been reviewed

  [ ] Join columns are explicitly documented

  [ ] One-to-many relationships are understood

  [ ] Potential many-to-many joins are identified

  [ ] Shipment-level values are protected from line multiplication

  [ ] Purchase-order joins are checked for line/receipt multiplication

  [ ] Inventory snapshots are not confused with movements

  [ ] Forecast versions remain part of forecast grain

  [ ] Currencies remain identifiable before financial aggregation

  [ ] BOM relationships are treated separately from transactional quantities

  [ ] Production joins use real production identifiers

  [ ] No relationship is assumed merely because columns have similar names


  REVIEW CONTROL STATEMENT
  -------------------------------

  The SCIS analytical model was reviewed at table and relationship level.

  Grain was documented for the principal master, header, line, transactional
  and operational datasets.

  Core one-to-many relationships were identified across procurement, customer
  orders, logistics, inventory, production and warehouse operations.

  Particular attention was given to relationships capable of changing result
  grain and duplicating measures, including shipment header-to-line joins and
  purchase-order line-to-receipt relationships.

  Forecast version, currency and signed inventory movement semantics remain
  preserved within the model.

  The database structure is now sufficiently understood for exploratory and
  business analysis.


  CHAPTER 7 STATUS:
      DATA MODELLING → COMPLETE


  NEXT:
      CHAPTER 8 — EXPLORATORY DATA ANALYSIS
==============================================================================*/


/*==============================================================================
  SOUTHERN CROSS INDUSTRIAL SUPPLY — END-TO-END SQL ANALYSIS
  CHAPTER 8 — EXPLORATORY DATA ANALYSIS
  Analyst: Data Analyst
  Environment: SQL Server / SSMS

  PURPOSE
  -------
  Establish an initial operating baseline for SCIS before deeper hypothesis
  testing and KPI/root-cause analysis.

  EDA OBJECTIVES
  -------------
  1. Quantify overall business activity.
  2. Identify concentration across products, suppliers, and warehouses.
  3. Assess material trends over time.
  4. Identify concentrations of unusual or exception values.
  5. Prioritise areas for deeper Chapter 9 analysis.

  IMPORTANT:
  EDA finds PATTERNS.
  EDA identifies patterns and exceptions; it does not establish root cause.

  SQL TECHNIQUES APPLIED
  ------------------
  Core retrieval: SELECT / WHERE / DISTINCT / ORDER BY
  Aggregation: COUNT / SUM / AVG / MIN / MAX / GROUP BY
  Conditional logic: CASE
  Date analysis: YEAR / MONTH
  Relational analysis: JOINs
  Structured analysis: CTEs where appropriate
==============================================================================*/


USE SCIS;
GO


/*==============================================================================
  8.1 — BUSINESS ACTIVITY OVERVIEW

  PURPOSE:
  Establish an initial view of operating scale.
==============================================================================*/

SELECT COUNT(*) AS total_products
FROM dbo.products;

SELECT COUNT(*) AS total_suppliers
FROM dbo.suppliers;

SELECT COUNT(*) AS total_customer_orders
FROM dbo.customer_orders;

SELECT COUNT(*) AS total_purchase_orders
FROM dbo.purchase_orders;

SELECT COUNT(*) AS total_shipments
FROM dbo.shipments;

SELECT COUNT(*) AS total_production_orders
FROM dbo.production_orders;


/*==============================================================================
  8.2 — DISTINCT BUSINESS ENTITIES

  PURPOSE:
  Quantify the breadth of operations.
==============================================================================*/

SELECT COUNT(DISTINCT supplier_id) AS active_suppliers
FROM dbo.purchase_orders;

SELECT COUNT(DISTINCT product_id) AS purchased_products
FROM dbo.purchase_order_lines;

SELECT COUNT(DISTINCT product_id) AS sold_products
FROM dbo.customer_order_lines;

SELECT COUNT(DISTINCT carrier_id) AS carriers_used
FROM dbo.shipments;


/*==============================================================================
  8.3 — CUSTOMER ORDER TREND BY MONTH

  ANALYTICAL OBJECTIVE:
  Assess whether demand is stable, rising, declining, or seasonal.

  Date-analysis technique:
  YEAR() + MONTH()
==============================================================================*/

SELECT
    YEAR(order_date) AS order_year,
    MONTH(order_date) AS order_month,
    COUNT(*) AS total_orders
FROM dbo.customer_orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;


/*==============================================================================
  8.4 — CUSTOMER ORDER QUANTITY BY MONTH

  Header count represents the number of orders.

  Line quantity represents units demanded.

  JOIN:
      customer_orders.customer_order_id
                  =
      customer_order_lines.customer_order_id
==============================================================================*/

SELECT
    YEAR(co.order_date) AS order_year,
    MONTH(co.order_date) AS order_month,
    SUM(col.quantity) AS total_quantity_ordered
FROM dbo.customer_orders co
JOIN dbo.customer_order_lines col
    ON co.customer_order_id = col.customer_order_id
GROUP BY YEAR(co.order_date), MONTH(co.order_date)
ORDER BY order_year, order_month;


/*==============================================================================
  8.5 — TOP PRODUCTS BY CUSTOMER DEMAND

  ANALYTICAL OBJECTIVE:
  Identify products generating the highest unit demand.
==============================================================================*/

SELECT TOP 10
    p.product_id,
    p.product_name,
    SUM(col.quantity) AS total_quantity_ordered
FROM dbo.customer_order_lines col
JOIN dbo.products p
    ON col.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_ordered DESC;


/*==============================================================================
  8.6 — LOW-DEMAND PRODUCTS

  PURPOSE:
  Identify products with relatively little customer demand.

  Do not classify these products as "obsolete" without additional lifecycle evidence.

  Low demand could be:
  • specialised products
  • newly introduced products
  • spare parts
  • seasonal products
==============================================================================*/

SELECT
    p.product_id,
    p.product_name,
    SUM(col.quantity) AS total_quantity_ordered
FROM dbo.customer_order_lines col
JOIN dbo.products p
    ON col.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_ordered ASC;


/*==============================================================================
  8.7 — PURCHASE ORDER TREND

  ANALYTICAL OBJECTIVE:
  Assess changes in procurement activity over time.
==============================================================================*/

SELECT
    YEAR(order_date) AS po_year,
    MONTH(order_date) AS po_month,
    COUNT(*) AS purchase_orders
FROM dbo.purchase_orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY po_year, po_month;


/*==============================================================================
  8.8 — PURCHASED QUANTITY BY SUPPLIER

  JOIN COLUMNS:
      purchase_orders.purchase_order_id
            =
      purchase_order_lines.purchase_order_id

      purchase_orders.supplier_id
            =
      suppliers.supplier_id
==============================================================================*/

SELECT
    s.supplier_id,
    s.supplier_name,
    SUM(pol.ordered_quantity) AS total_quantity_ordered
FROM dbo.purchase_orders po
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id
JOIN dbo.suppliers s
    ON po.supplier_id = s.supplier_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY total_quantity_ordered DESC;


/*==============================================================================
  8.9 — PURCHASE PRICE RANGE BY PRODUCT

  PURPOSE:
  Assess pricing variation.

  This does not establish overpayment.

  Analytical objective:
      Quantify purchase-price variation for the same product.
==============================================================================*/

SELECT
    product_id,
    MIN(unit_price) AS lowest_price,
    AVG(unit_price) AS average_price,
    MAX(unit_price) AS highest_price
FROM dbo.purchase_order_lines
GROUP BY product_id
ORDER BY product_id;


/*==============================================================================
  8.10 — PRODUCTS WITH LARGEST PRICE SPREAD

  CASE is not required.
  Standard arithmetic is sufficient.
==============================================================================*/

SELECT
    product_id,
    MIN(unit_price) AS lowest_price,
    MAX(unit_price) AS highest_price,
    MAX(unit_price) - MIN(unit_price) AS price_spread
FROM dbo.purchase_order_lines
GROUP BY product_id
ORDER BY price_spread DESC;


/*==============================================================================
  8.11 — INVENTORY POSITION

  inventory_snapshots = inventory balance at a point in time.

  This is not the same as stock movements.
==============================================================================*/

SELECT
    product_id,
    AVG(quantity_on_hand) AS avg_inventory,
    MIN(quantity_on_hand) AS min_inventory,
    MAX(quantity_on_hand) AS max_inventory
FROM dbo.inventory_snapshots
GROUP BY product_id
ORDER BY avg_inventory DESC;


/*==============================================================================
  8.12 — PRODUCTS WITH ZERO / LOW STOCK

  PURPOSE:
  Identify possible stockout exposure.

  IMPORTANT:
  This is only an exploratory signal.

  True stockout analysis later requires:
  • demand
  • stock availability
  • timing
  • replenishment context
==============================================================================*/

SELECT *
FROM dbo.inventory_snapshots
WHERE quantity_on_hand <= 0
ORDER BY product_id;


/*==============================================================================
  8.13 — STOCK MOVEMENT PROFILE

  Signed quantity tells direction.

  positive → stock entering
  negative → stock leaving
==============================================================================*/

SELECT
    CASE
        WHEN quantity > 0 THEN 'Inbound'
        WHEN quantity < 0 THEN 'Outbound'
        ELSE 'Zero Movement'
    END AS movement_direction,

    COUNT(*) AS movement_count,
    SUM(quantity) AS net_quantity

FROM dbo.stock_movements

GROUP BY
    CASE
        WHEN quantity > 0 THEN 'Inbound'
        WHEN quantity < 0 THEN 'Outbound'
        ELSE 'Zero Movement'
    END;


/*==============================================================================
  8.14 — NET STOCK MOVEMENT BY PRODUCT

  PURPOSE:
  Identify products with unusually large movement volumes.
==============================================================================*/

SELECT
    product_id,
    SUM(quantity) AS net_stock_movement
FROM dbo.stock_movements
GROUP BY product_id
ORDER BY net_stock_movement;


/*==============================================================================
  8.15 — SHIPMENT VOLUME BY MONTH

  IMPORTANT:
  shipments = shipment grain

  The header table is used directly to preserve shipment-level grain.
==============================================================================*/

SELECT
    YEAR(shipment_date) AS shipment_year,
    MONTH(shipment_date) AS shipment_month,
    COUNT(*) AS shipment_count
FROM dbo.shipments
GROUP BY YEAR(shipment_date), MONTH(shipment_date)
ORDER BY shipment_year, shipment_month;


/*==============================================================================
  8.16 — SHIPMENT STATUS PROFILE
==============================================================================*/

SELECT
    shipment_status,
    COUNT(*) AS shipments
FROM dbo.shipments
GROUP BY shipment_status
ORDER BY shipments DESC;


/*==============================================================================
  8.17 — ON-TIME VS LATE DELIVERY PROFILE

  only completed shipments are included.

  Rationale:
  An open shipment has not yet had the chance to become on-time or late.
==============================================================================*/

SELECT
    CASE
        WHEN actual_delivery_date <= promised_delivery_date THEN 'On Time'
        WHEN actual_delivery_date > promised_delivery_date  THEN 'Late'
    END AS delivery_status,

    COUNT(*) AS shipments

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL

GROUP BY
    CASE
        WHEN actual_delivery_date <= promised_delivery_date THEN 'On Time'
        WHEN actual_delivery_date > promised_delivery_date  THEN 'Late'
    END;


/*==============================================================================
  8.18 — DELIVERY DAYS DISTRIBUTION

  PURPOSE:
  Quantify typical shipment transit duration.

  Date-analysis technique:
  DATEDIFF()
==============================================================================*/

SELECT
    MIN(DATEDIFF(DAY, shipment_date, actual_delivery_date)) AS minimum_days,
    AVG(DATEDIFF(DAY, shipment_date, actual_delivery_date) * 1.0) AS average_days,
    MAX(DATEDIFF(DAY, shipment_date, actual_delivery_date)) AS maximum_days
FROM dbo.shipments
WHERE actual_delivery_date IS NOT NULL;


/*==============================================================================
  8.19 — SHIPMENTS BY CARRIER

  JOIN:
      shipments.carrier_id
            =
      carriers.carrier_id
==============================================================================*/

SELECT
    c.carrier_id,
    COUNT(*) AS shipments
FROM dbo.shipments s
JOIN dbo.carriers c
    ON s.carrier_id = c.carrier_id
GROUP BY c.carrier_id
ORDER BY shipments DESC;


/*==============================================================================
  8.20 — FREIGHT COST BY CARRIER

  CRITICAL:
  Use shipment grain.

  Do not join shipment_lines when calculating shipment-level freight unless line-level attributes are required.
==============================================================================*/

SELECT
    carrier_id,
    COUNT(*) AS shipments,
    SUM(freight_cost) AS total_freight,
    AVG(freight_cost) AS average_freight
FROM dbo.shipments
GROUP BY carrier_id
ORDER BY total_freight DESC;


/*==============================================================================
  8.21 — PRODUCTION VOLUME

  PURPOSE:
  Begin with a review of production activity.

  Use actual source quantity field from production_orders if named differently.
==============================================================================*/

SELECT
    product_id,
    COUNT(*) AS production_orders
FROM dbo.production_orders
GROUP BY product_id
ORDER BY production_orders DESC;


/*==============================================================================
  8.22 — PRODUCTION TREND BY MONTH

  Replace planned_start_date with the correct production date if required.
==============================================================================*/

SELECT
    YEAR(planned_start_date) AS production_year,
    MONTH(planned_start_date) AS production_month,
    COUNT(*) AS production_orders
FROM dbo.production_orders
GROUP BY YEAR(planned_start_date), MONTH(planned_start_date)
ORDER BY production_year, production_month;


/*==============================================================================
  8.23 — DOWNTIME PROFILE

  PURPOSE:
  Identify where downtime events appear concentrated.

  At the EDA stage, frequency is reviewed before causal interpretation.
==============================================================================*/

SELECT
    COUNT(*) AS total_downtime_events
FROM dbo.downtime_events;


/*==============================================================================
  If downtime has a reason/category field, inspect distribution:
==============================================================================*/

SELECT
    downtime_reason,
    COUNT(*) AS events
FROM dbo.downtime_events
GROUP BY downtime_reason
ORDER BY events DESC;


/*==============================================================================
  8.24 — QUALITY INSPECTION PROFILE

  Initial validation:
      Quantify inspection volume.
      Assess the distribution of inspection outcomes.
==============================================================================*/

SELECT COUNT(*) AS total_inspections
FROM dbo.quality_inspections;


SELECT
    inspection_result,
    COUNT(*) AS inspections
FROM dbo.quality_inspections
GROUP BY inspection_result
ORDER BY inspections DESC;


/*==============================================================================
  8.25 — RETURNS PROFILE

  PURPOSE:
  Quantify return volume and major return categories.
==============================================================================*/

SELECT COUNT(*) AS total_returns
FROM dbo.returns;


SELECT
    return_reason,
    COUNT(*) AS returns
FROM dbo.returns
GROUP BY return_reason
ORDER BY returns DESC;


/*==============================================================================
  8.26 — WAREHOUSE ACTIVITY PROFILE

  PURPOSE:
  Compare relative activity between warehouses.
==============================================================================*/

SELECT
    warehouse_id,
    COUNT(*) AS operation_count
FROM dbo.warehouse_operations
GROUP BY warehouse_id
ORDER BY operation_count DESC;


/*==============================================================================
  8.27 — INVENTORY BY WAREHOUSE

  This provides an initial view of inventory concentration.
==============================================================================*/

SELECT
    warehouse_id,
    SUM(quantity_on_hand) AS total_inventory_units
FROM dbo.inventory_snapshots
GROUP BY warehouse_id
ORDER BY total_inventory_units DESC;


/*==============================================================================
  8.28 — SUPPLIER DEPENDENCY

  ANALYTICAL OBJECTIVE:
  Assess purchase-order concentration across suppliers.
==============================================================================*/

SELECT
    supplier_id,
    COUNT(*) AS purchase_orders
FROM dbo.purchase_orders
GROUP BY supplier_id
ORDER BY purchase_orders DESC;


/*==============================================================================
  8.29 — PRODUCT SUPPLIER COVERAGE

  ANALYTICAL OBJECTIVE:
  Quantify approved/available supplier coverage by product.

  Potential signal:
  Product with 1 supplier may have higher sourcing concentration risk.
==============================================================================*/

SELECT
    product_id,
    COUNT(DISTINCT supplier_id) AS supplier_count
FROM dbo.supplier_products
GROUP BY product_id
ORDER BY supplier_count;


/*==============================================================================
  8.30 — SINGLE-SOURCE PRODUCTS

  Exploratory signal only.

  Single-source exposure requires contextual assessment and is not inherently evidence of deficient procurement strategy.
==============================================================================*/

SELECT
    product_id,
    COUNT(DISTINCT supplier_id) AS supplier_count
FROM dbo.supplier_products
GROUP BY product_id
HAVING COUNT(DISTINCT supplier_id) = 1;


/*==============================================================================
  8.31 — FORECAST DATA PROFILE

  CRITICAL:
  Keep forecast versions separate.
==============================================================================*/

SELECT
    forecast_version,
    COUNT(*) AS forecast_rows
FROM dbo.demand_forecast
GROUP BY forecast_version
ORDER BY forecast_version;


/*==============================================================================
  8.32 — FORECAST BY PRODUCT

  Forecast versions must be evaluated independently.

  Therefore version is included in GROUP BY.
==============================================================================*/

SELECT
    product_id,
    forecast_version,
    SUM(forecast_quantity) AS total_forecast_quantity
FROM dbo.demand_forecast
GROUP BY product_id, forecast_version
ORDER BY product_id, forecast_version;


/*==============================================================================
  8.33 — BASIC DEMAND VS FORECAST EXPLORATION

  IMPORTANT:
  This requires matching grain and date period.

  The following tables should not be joined without a validated relationship:
      total forecast
  to
      total customer demand

  until:
      product
      period
      location
      version

  are aligned.

  Therefore Chapter 8 documents the requirement.

  Full forecast accuracy analysis belongs in Chapter 9.
==============================================================================*/


/*==============================================================================
  8.34 — SEARCH FOR EXTREME PURCHASE QUANTITIES

  TOP + ORDER BY provides a concise exploratory view.
==============================================================================*/

SELECT TOP 20 *
FROM dbo.purchase_order_lines
ORDER BY ordered_quantity DESC;


/*==============================================================================
  8.35 — SEARCH FOR EXTREME UNIT PRICES
==============================================================================*/

SELECT TOP 20 *
FROM dbo.purchase_order_lines
ORDER BY unit_price DESC;


/*==============================================================================
  8.36 — SEARCH FOR HIGH FREIGHT SHIPMENTS

  Again:
  use shipment table directly.
==============================================================================*/

SELECT TOP 20
    shipment_id,
    carrier_id,
    shipment_date,
    freight_cost
FROM dbo.shipments
ORDER BY freight_cost DESC;


/*==============================================================================
  8.37 — EXPLORATORY EXCEPTION CLASSIFICATION

  CASE supports rapid classification of records for investigation.

  Example:
  classify shipment lateness.

  These thresholds should not be treated as management policy unless supported.
==============================================================================*/

SELECT
    shipment_id,

    DATEDIFF(DAY, promised_delivery_date, actual_delivery_date) AS days_late,

    CASE
        WHEN actual_delivery_date IS NULL THEN 'Incomplete'
        WHEN actual_delivery_date <= promised_delivery_date THEN 'On Time'
        WHEN DATEDIFF(DAY, promised_delivery_date, actual_delivery_date) <= 3
             THEN '1-3 Days Late'
        ELSE 'More Than 3 Days Late'
    END AS delivery_group

FROM dbo.shipments;


/*==============================================================================
  8.38 — EDA OUTPUTS FOR CHAPTER 9

  EDA should not produce unsupported conclusions such as:
      "Supplier X is underperforming."
      "Warehouse Y is inefficient."
      "Forecasting caused stockouts."

  EDA produces evidence-based investigation themes such as:

  • Drivers of elevated inventory by product
  • Stockout concentration by product and warehouse
  • Purchase-price variation for identical products
  • Concentration of late purchase orders by supplier
  • Suppliers with elevated late-delivery frequency
  • Customer-fulfilment performance over time
  • Carrier association with late delivery and freight cost
  • Production areas with elevated downtime
  • Products with elevated quality-defect incidence
  • Dominant return-reason categories
  • Forecast-error concentration by product and period
  • Operational-exception concentration by warehouse

  THESE THEMES FORM THE BASIS OF CHAPTER 9 ANALYSIS.
==============================================================================*/


/*==============================================================================
  8.39 — EDA QA CHECKLIST

  [ ] Overall operational volumes reviewed

  [ ] Demand trend reviewed

  [ ] Product demand concentration reviewed

  [ ] Procurement trend reviewed

  [ ] Supplier purchasing concentration reviewed

  [ ] Purchase-price variation reviewed

  [ ] Inventory levels reviewed

  [ ] Stock movements reviewed

  [ ] Shipment volume reviewed

  [ ] Shipment statuses reviewed

  [ ] Late-delivery pattern reviewed

  [ ] Carrier usage reviewed

  [ ] Freight profile reviewed at shipment grain

  [ ] Production activity reviewed

  [ ] Downtime profile reviewed

  [ ] Quality inspection outcomes reviewed

  [ ] Returns reviewed

  [ ] Warehouse activity reviewed

  [ ] Supplier coverage reviewed

  [ ] Forecast versions kept separate

  [ ] Extreme values inspected

  [ ] No EDA pattern was incorrectly presented as proven root cause


  REVIEW CONTROL STATEMENT
  -------------------------------

  Exploratory analysis was performed across SCIS demand, procurement,
  inventory, logistics, production, quality, returns and warehouse operations.

  The analysis identified operational concentrations, trends, distributions and
  potential exceptions requiring deeper investigation.

  Grain-sensitive measures, including shipment freight, were analysed at their
  correct level.

  Forecast versions were retained separately, and exploratory observations were
  not treated as confirmed root causes.

  The EDA results provide the question set for detailed supply-chain analysis
  in Chapter 9.


  CHAPTER 8 STATUS:
      EXPLORATORY DATA ANALYSIS → COMPLETE


  NEXT:
      CHAPTER 9 — SUPPLY-CHAIN SQL ANALYSIS
==============================================================================*/

/*==============================================================================
  SOUTHERN CROSS INDUSTRIAL SUPPLY
  CHAPTER 9 — SUPPLY-CHAIN SQL ANALYSIS
  INTEGRATED ANALYSIS

  RULE:
  KEEP THE CALCULATION.
  SIMPLIFY THE SQL.

  CORE SQL TECHNIQUES:
  Core analytical SQL patterns.
==============================================================================*/

USE SCIS;
GO


/*##############################################################################
  9.1 INVENTORY ANALYSIS
##############################################################################*/


/*==============================================================================
  9.1.1 INVENTORY LEVELS
==============================================================================*/

SELECT
    product_id,
    AVG(quantity_on_hand * 1.0) AS avg_inventory,
    MIN(quantity_on_hand) AS min_inventory,
    MAX(quantity_on_hand) AS max_inventory
FROM dbo.inventory_snapshots
GROUP BY product_id
ORDER BY avg_inventory DESC;


/*==============================================================================
  9.1.2 INVENTORY BY WAREHOUSE
==============================================================================*/

SELECT
    warehouse_id,
    SUM(quantity_on_hand) AS inventory_units
FROM dbo.inventory_snapshots
GROUP BY warehouse_id
ORDER BY inventory_units DESC;


/*==============================================================================
  9.1.3 INVENTORY VALUE

  If unit cost exists in products:
      inventory quantity × standard cost
==============================================================================*/

SELECT
    i.product_id,
    AVG(i.quantity_on_hand * 1.0) AS avg_inventory_qty,
    p.standard_cost_aud,
    AVG(i.quantity_on_hand * 1.0) * p.standard_cost_aud AS avg_inventory_value_aud

FROM dbo.inventory_snapshots i
JOIN dbo.products p
    ON i.product_id = p.product_id

GROUP BY
    i.product_id,
    p.standard_cost_aud

ORDER BY avg_inventory_value_aud DESC;


/*==============================================================================
  9.1.4 INVENTORY TURNOVER

  Outbound stock movement / average inventory

  negative movement = stock leaving
==============================================================================*/

WITH Inventory AS
(
    SELECT
        product_id,
        AVG(quantity_on_hand * 1.0) AS avg_inventory
    FROM dbo.inventory_snapshots
    GROUP BY product_id
),

Outbound AS
(
    SELECT
        product_id,
        SUM(
            CASE
                WHEN quantity < 0 THEN quantity * -1
                ELSE 0
            END
        ) AS outbound_qty
    FROM dbo.stock_movements
    GROUP BY product_id
)

SELECT
    i.product_id,
    i.avg_inventory,
    o.outbound_qty,

    CASE
        WHEN i.avg_inventory > 0
        THEN o.outbound_qty / i.avg_inventory
        ELSE NULL
    END AS inventory_turnover

FROM Inventory i
JOIN Outbound o
    ON i.product_id = o.product_id

ORDER BY inventory_turnover DESC;


/*==============================================================================
  9.1.5 DAYS IN INVENTORY

  Approximation:
      analysis days / turnover
==============================================================================*/

WITH Inventory AS
(
    SELECT
        product_id,
        AVG(quantity_on_hand * 1.0) AS avg_inventory
    FROM dbo.inventory_snapshots
    GROUP BY product_id
),

Outbound AS
(
    SELECT
        product_id,
        SUM(CASE WHEN quantity < 0 THEN quantity * -1 ELSE 0 END) AS outbound_qty
    FROM dbo.stock_movements
    GROUP BY product_id
)

SELECT
    i.product_id,

    CASE
        WHEN o.outbound_qty > 0
        THEN (i.avg_inventory / o.outbound_qty) * 365
        ELSE NULL
    END AS approximate_days_inventory

FROM Inventory i
JOIN Outbound o
    ON i.product_id = o.product_id

ORDER BY approximate_days_inventory DESC;


/*==============================================================================
  9.1.6 STOCKOUT EVENTS
==============================================================================*/

SELECT
    product_id,
    COUNT(*) AS zero_stock_events
FROM dbo.inventory_snapshots
WHERE quantity_on_hand <= 0
GROUP BY product_id
ORDER BY zero_stock_events DESC;


/*==============================================================================
  9.1.7 STOCKOUTS BY WAREHOUSE
==============================================================================*/

SELECT
    warehouse_id,
    COUNT(*) AS zero_stock_events
FROM dbo.inventory_snapshots
WHERE quantity_on_hand <= 0
GROUP BY warehouse_id
ORDER BY zero_stock_events DESC;


/*==============================================================================
  9.1.8 SLOW / FAST MOVING PRODUCTS

  Movement quantity is used as a baseline activity indicator.
==============================================================================*/

SELECT
    product_id,

    SUM(
        CASE
            WHEN quantity < 0 THEN quantity * -1
            ELSE quantity
        END
    ) AS movement_volume,

    CASE
        WHEN SUM(
            CASE
                WHEN quantity < 0 THEN quantity * -1
                ELSE quantity
            END
        ) = 0
        THEN 'No Movement'

        WHEN SUM(
            CASE
                WHEN quantity < 0 THEN quantity * -1
                ELSE quantity
            END
        ) < 100
        THEN 'Slow Moving'

        ELSE 'Fast Moving'
    END AS movement_class

FROM dbo.stock_movements

GROUP BY product_id
ORDER BY movement_volume;


/*==============================================================================
  9.1.9 DEAD STOCK CANDIDATES

  Inventory exists
  BUT no outbound movement exists.
==============================================================================*/

SELECT
    i.product_id,
    AVG(i.quantity_on_hand * 1.0) AS avg_inventory

FROM dbo.inventory_snapshots i

WHERE i.quantity_on_hand > 0
  AND NOT EXISTS
(
    SELECT 1
    FROM dbo.stock_movements sm
    WHERE sm.product_id = i.product_id
      AND sm.quantity < 0
)

GROUP BY i.product_id

ORDER BY avg_inventory DESC;


/*==============================================================================
  9.1.10 ABC ANALYSIS

  Baseline method:
  Rank products by outbound volume,
  then divide them into three relative groups.
==============================================================================*/

WITH Usage AS
(
    SELECT
        product_id,
        SUM(CASE WHEN quantity < 0 THEN quantity * -1 ELSE 0 END) AS outbound_qty
    FROM dbo.stock_movements
    GROUP BY product_id
),

ABC AS
(
    SELECT
        product_id,
        outbound_qty,
        NTILE(3) OVER(ORDER BY outbound_qty DESC) AS abc_group
    FROM Usage
)

SELECT
    product_id,
    outbound_qty,

    CASE
        WHEN abc_group = 1 THEN 'A'
        WHEN abc_group = 2 THEN 'B'
        ELSE 'C'
    END AS abc_class

FROM ABC
ORDER BY outbound_qty DESC;


/*==============================================================================
  9.1.11 REORDER / UNDERSTOCK SIGNAL

  Uses product reorder point if available.
==============================================================================*/

SELECT
    i.product_id,
    i.warehouse_id,
    i.quantity_on_hand,
    p.reorder_point,

    CASE
        WHEN i.quantity_on_hand <= p.reorder_point
            THEN 'Reorder Review'
        ELSE 'Stock OK'
    END AS reorder_status

FROM dbo.inventory_snapshots i
JOIN dbo.products p
    ON i.product_id = p.product_id

WHERE i.quantity_on_hand <= p.reorder_point;


/*==============================================================================
  9.1.12 SAFETY-STOCK SIGNAL
==============================================================================*/

SELECT
    i.product_id,
    i.warehouse_id,
    i.quantity_on_hand,
    p.safety_stock,

    CASE
        WHEN i.quantity_on_hand < p.safety_stock
            THEN 'Below Safety Stock'
        ELSE 'Above Safety Stock'
    END AS safety_stock_status

FROM dbo.inventory_snapshots i
JOIN dbo.products p
    ON i.product_id = p.product_id;


/*##############################################################################
  9.2 DEMAND & FORECAST
##############################################################################*/


/*==============================================================================
  9.2.1 TOTAL DEMAND BY PRODUCT
==============================================================================*/

SELECT
    product_id,
    SUM(quantity) AS demand_qty
FROM dbo.customer_order_lines
GROUP BY product_id
ORDER BY demand_qty DESC;


/*==============================================================================
  9.2.2 MONTHLY DEMAND TREND
==============================================================================*/

SELECT
    YEAR(co.order_date) AS demand_year,
    MONTH(co.order_date) AS demand_month,
    SUM(col.quantity) AS demand_qty

FROM dbo.customer_orders co
JOIN dbo.customer_order_lines col
    ON co.customer_order_id = col.customer_order_id

GROUP BY
    YEAR(co.order_date),
    MONTH(co.order_date)

ORDER BY
    demand_year,
    demand_month;


/*==============================================================================
  9.2.3 DEMAND VARIABILITY

  Implementation approach:
      highest month - lowest month
==============================================================================*/

WITH MonthlyDemand AS
(
    SELECT
        YEAR(co.order_date) AS yr,
        MONTH(co.order_date) AS mn,
        col.product_id,
        SUM(col.quantity) AS demand_qty

    FROM dbo.customer_orders co
    JOIN dbo.customer_order_lines col
        ON co.customer_order_id = col.customer_order_id

    GROUP BY
        YEAR(co.order_date),
        MONTH(co.order_date),
        col.product_id
)

SELECT
    product_id,
    AVG(demand_qty * 1.0) AS avg_monthly_demand,
    MIN(demand_qty) AS lowest_month,
    MAX(demand_qty) AS highest_month,
    MAX(demand_qty) - MIN(demand_qty) AS demand_range

FROM MonthlyDemand

GROUP BY product_id

ORDER BY demand_range DESC;


/*==============================================================================
  9.2.4 SEASONALITY
==============================================================================*/

SELECT
    MONTH(co.order_date) AS month_number,
    SUM(col.quantity) AS demand_qty

FROM dbo.customer_orders co
JOIN dbo.customer_order_lines col
    ON co.customer_order_id = col.customer_order_id

GROUP BY MONTH(co.order_date)
ORDER BY month_number;


/*==============================================================================
  9.2.5 FORECAST BY VERSION

  FORECAST VERSIONS MUST BE EVALUATED INDEPENDENTLY.
==============================================================================*/

SELECT
    forecast_version,
    SUM(forecast_quantity) AS forecast_qty

FROM dbo.demand_forecast

GROUP BY forecast_version
ORDER BY forecast_version;


/*==============================================================================
  9.2.6 FORECAST VS ACTUAL

  Keep product + version visible.

  Add date/location keys as applicable to actual dataset.
==============================================================================*/

WITH ActualDemand AS
(
    SELECT
        product_id,
        SUM(quantity) AS actual_qty
    FROM dbo.customer_order_lines
    GROUP BY product_id
),

Forecast AS
(
    SELECT
        product_id,
        forecast_version,
        SUM(forecast_quantity) AS forecast_qty
    FROM dbo.demand_forecast
    GROUP BY product_id, forecast_version
)

SELECT
    f.product_id,
    f.forecast_version,
    f.forecast_qty,
    a.actual_qty,
    a.actual_qty - f.forecast_qty AS forecast_error

FROM Forecast f
LEFT JOIN ActualDemand a
    ON f.product_id = a.product_id;


/*==============================================================================
  9.2.7 ABSOLUTE FORECAST ERROR
==============================================================================*/

WITH ActualDemand AS
(
    SELECT product_id, SUM(quantity) AS actual_qty
    FROM dbo.customer_order_lines
    GROUP BY product_id
),

Forecast AS
(
    SELECT product_id, forecast_version, SUM(forecast_quantity) AS forecast_qty
    FROM dbo.demand_forecast
    GROUP BY product_id, forecast_version
)

SELECT
    f.product_id,
    f.forecast_version,
    f.forecast_qty,
    a.actual_qty,

    CASE
        WHEN a.actual_qty - f.forecast_qty < 0
            THEN (a.actual_qty - f.forecast_qty) * -1
        ELSE a.actual_qty - f.forecast_qty
    END AS absolute_forecast_error

FROM Forecast f
JOIN ActualDemand a
    ON f.product_id = a.product_id

ORDER BY absolute_forecast_error DESC;


/*##############################################################################
  9.3 PROCUREMENT
##############################################################################*/


/*==============================================================================
  9.3.1 PURCHASED QUANTITY
==============================================================================*/

SELECT
    product_id,
    SUM(ordered_quantity) AS purchased_qty
FROM dbo.purchase_order_lines
GROUP BY product_id
ORDER BY purchased_qty DESC;


/*==============================================================================
  9.3.2 PROCUREMENT VALUE

  Keep currencies separated unless converted.
==============================================================================*/

SELECT
    po.currency_code,
    SUM(pol.ordered_quantity * pol.unit_price) AS procurement_value

FROM dbo.purchase_orders po
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id

GROUP BY po.currency_code;


/*==============================================================================
  9.3.3 SPEND BY SUPPLIER
==============================================================================*/

SELECT
    po.supplier_id,
    po.currency_code,
    SUM(pol.ordered_quantity * pol.unit_price) AS procurement_value

FROM dbo.purchase_orders po
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id

GROUP BY
    po.supplier_id,
    po.currency_code

ORDER BY procurement_value DESC;


/*==============================================================================
  9.3.4 SPEND BY CATEGORY
==============================================================================*/

SELECT
    p.category,
    po.currency_code,
    SUM(pol.ordered_quantity * pol.unit_price) AS procurement_value

FROM dbo.purchase_order_lines pol
JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id
JOIN dbo.products p
    ON pol.product_id = p.product_id

GROUP BY
    p.category,
    po.currency_code

ORDER BY procurement_value DESC;


/*==============================================================================
  9.3.5 CONTRACT COMPLIANCE

  Uses actual compliance flag if available.
==============================================================================*/

SELECT
    contract_compliant_flag,
    COUNT(*) AS purchase_lines

FROM dbo.purchase_order_lines

GROUP BY contract_compliant_flag;


/*==============================================================================
  9.3.6 COMPLIANCE %
==============================================================================*/

SELECT
    COUNT(*) AS purchase_lines,

    SUM(
        CASE
            WHEN contract_compliant_flag = 1 THEN 1
            ELSE 0
        END
    ) AS compliant_lines,

    SUM(
        CASE
            WHEN contract_compliant_flag = 1 THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS compliance_pct

FROM dbo.purchase_order_lines;


/*==============================================================================
  9.3.7 MAVERICK / NON-COMPLIANT SPEND
==============================================================================*/

SELECT
    po.currency_code,

    SUM(
        CASE
            WHEN pol.contract_compliant_flag = 0
            THEN pol.ordered_quantity * pol.unit_price
            ELSE 0
        END
    ) AS non_compliant_spend

FROM dbo.purchase_orders po
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id

GROUP BY po.currency_code;


/*==============================================================================
  9.3.8 PURCHASE PRICE VARIATION
==============================================================================*/

SELECT
    product_id,
    MIN(unit_price) AS min_price,
    AVG(unit_price) AS avg_price,
    MAX(unit_price) AS max_price,
    MAX(unit_price) - MIN(unit_price) AS price_spread

FROM dbo.purchase_order_lines

GROUP BY product_id

ORDER BY price_spread DESC;


/*==============================================================================
  9.3.9 PRICE BY SUPPLIER
==============================================================================*/

SELECT
    pol.product_id,
    po.supplier_id,
    AVG(pol.unit_price) AS avg_unit_price

FROM dbo.purchase_order_lines pol
JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id

GROUP BY
    pol.product_id,
    po.supplier_id

ORDER BY
    pol.product_id,
    avg_unit_price DESC;


/*==============================================================================
  9.3.10 PPV

  actual price - reference/contract price

  Only use where supplier_products has valid reference contract pricing.
==============================================================================*/

SELECT
    pol.product_id,
    po.supplier_id,
    pol.unit_price AS actual_price,
    sp.contract_unit_price AS reference_price,

    pol.unit_price - sp.contract_unit_price AS unit_ppv,

    (pol.unit_price - sp.contract_unit_price)
        * pol.ordered_quantity AS total_ppv

FROM dbo.purchase_order_lines pol
JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id
JOIN dbo.supplier_products sp
    ON po.supplier_id = sp.supplier_id
   AND pol.product_id = sp.product_id

ORDER BY total_ppv DESC;


/*==============================================================================
  9.3.11 FAVOURABLE PRICE VARIANCE / SAVING SIGNAL
==============================================================================*/

SELECT
    pol.product_id,

    SUM(
        CASE
            WHEN pol.unit_price < sp.contract_unit_price
            THEN
                (sp.contract_unit_price - pol.unit_price)
                * pol.ordered_quantity
            ELSE 0
        END
    ) AS favourable_price_variance

FROM dbo.purchase_order_lines pol
JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id
JOIN dbo.supplier_products sp
    ON po.supplier_id = sp.supplier_id
   AND pol.product_id = sp.product_id

GROUP BY pol.product_id

ORDER BY favourable_price_variance DESC;


/*##############################################################################
  9.4 SUPPLIERS
##############################################################################*/


/*==============================================================================
  9.4.1 ORDERS BY SUPPLIER
==============================================================================*/

SELECT
    supplier_id,
    COUNT(*) AS purchase_orders
FROM dbo.purchase_orders
GROUP BY supplier_id
ORDER BY purchase_orders DESC;


/*==============================================================================
  9.4.2 SUPPLIER LEAD TIME
==============================================================================*/

SELECT
    po.supplier_id,

    AVG(
        DATEDIFF(DAY, po.order_date, gr.receipt_date) * 1.0
    ) AS avg_lead_time_days

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id
ORDER BY avg_lead_time_days DESC;


/*==============================================================================
  9.4.3 LEAD-TIME VARIABILITY
==============================================================================*/

SELECT
    po.supplier_id,

    MIN(DATEDIFF(DAY, po.order_date, gr.receipt_date))
        AS shortest_lead_time,

    MAX(DATEDIFF(DAY, po.order_date, gr.receipt_date))
        AS longest_lead_time,

    MAX(DATEDIFF(DAY, po.order_date, gr.receipt_date))
    -
    MIN(DATEDIFF(DAY, po.order_date, gr.receipt_date))
        AS lead_time_range

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id
ORDER BY lead_time_range DESC;


/*==============================================================================
  9.4.4 ON-TIME RECEIPT %
==============================================================================*/

SELECT
    po.supplier_id,

    COUNT(*) AS receipts,

    SUM(
        CASE
            WHEN gr.receipt_date <= po.expected_delivery_date THEN 1
            ELSE 0
        END
    ) AS on_time_receipts,

    SUM(
        CASE
            WHEN gr.receipt_date <= po.expected_delivery_date THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS on_time_pct

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY on_time_pct DESC;


/*==============================================================================
  9.4.5 SUPPLIER QUALITY

  rejected / received
==============================================================================*/

SELECT
    po.supplier_id,

    SUM(gr.received_quantity) AS received_qty,
    SUM(gr.rejected_quantity) AS rejected_qty,

    CASE
        WHEN SUM(gr.received_quantity) > 0
        THEN
            SUM(gr.rejected_quantity) * 100.0
            / SUM(gr.received_quantity)
        ELSE NULL
    END AS rejection_rate_pct

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY rejection_rate_pct DESC;


/*==============================================================================
  9.4.6 SUPPLIER OTIF

  On time AND quantity received in full.
==============================================================================*/

SELECT
    po.supplier_id,

    COUNT(*) AS receipt_records,

    SUM(
        CASE
            WHEN gr.receipt_date <= po.expected_delivery_date
             AND gr.received_quantity >= gr.ordered_quantity
            THEN 1
            ELSE 0
        END
    ) AS otif_records,

    SUM(
        CASE
            WHEN gr.receipt_date <= po.expected_delivery_date
             AND gr.received_quantity >= gr.ordered_quantity
            THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS otif_pct

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY otif_pct DESC;


/*==============================================================================
  9.4.7 SUPPLIER RANKING
==============================================================================*/

WITH SupplierPerformance AS
(
    SELECT
        po.supplier_id,

        SUM(
            CASE
                WHEN gr.receipt_date <= po.expected_delivery_date THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*) AS on_time_pct

    FROM dbo.purchase_orders po
    JOIN dbo.goods_receipts gr
        ON po.purchase_order_id = gr.purchase_order_id

    GROUP BY po.supplier_id
)

SELECT
    supplier_id,
    on_time_pct,

    RANK() OVER(ORDER BY on_time_pct DESC)
        AS supplier_rank

FROM SupplierPerformance;


/*==============================================================================
  9.4.8 SINGLE-SOURCE PRODUCTS
==============================================================================*/

SELECT
    product_id,
    COUNT(DISTINCT supplier_id) AS supplier_count

FROM dbo.supplier_products

GROUP BY product_id

HAVING COUNT(DISTINCT supplier_id) = 1;


/*##############################################################################
  9.5 PURCHASE ORDERS
##############################################################################*/


/*==============================================================================
  9.5.1 PO VOLUME
==============================================================================*/

SELECT
    YEAR(order_date) AS po_year,
    MONTH(order_date) AS po_month,
    COUNT(*) AS po_count

FROM dbo.purchase_orders

GROUP BY
    YEAR(order_date),
    MONTH(order_date)

ORDER BY po_year, po_month;


/*==============================================================================
  9.5.2 OPEN POs
==============================================================================*/

SELECT *
FROM dbo.purchase_orders
WHERE po_status IN ('Open', 'Partial', 'Pending');


/*==============================================================================
  9.5.3 LATE PO RECEIPTS
==============================================================================*/

SELECT
    po.purchase_order_id,
    po.supplier_id,
    po.expected_delivery_date,
    gr.receipt_date,

    DATEDIFF(
        DAY,
        po.expected_delivery_date,
        gr.receipt_date
    ) AS days_late

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

WHERE gr.receipt_date > po.expected_delivery_date

ORDER BY days_late DESC;


/*==============================================================================
  9.5.4 PARTIAL RECEIPTS
==============================================================================*/

SELECT
    purchase_order_id,
    SUM(ordered_quantity) AS ordered_qty,
    SUM(received_quantity) AS received_qty

FROM dbo.goods_receipts

GROUP BY purchase_order_id

HAVING SUM(received_quantity) < SUM(ordered_quantity);


/*==============================================================================
  9.5.5 PO CYCLE TIME
==============================================================================*/

SELECT
    po.purchase_order_id,

    DATEDIFF(
        DAY,
        po.order_date,
        MAX(gr.receipt_date)
    ) AS po_cycle_days

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY
    po.purchase_order_id,
    po.order_date

ORDER BY po_cycle_days DESC;


/*##############################################################################
  9.6 CUSTOMER FULFILMENT
##############################################################################*/


/*==============================================================================
  9.6.1 ORDERED QUANTITY
==============================================================================*/

SELECT
    customer_order_id,
    SUM(quantity) AS ordered_qty
FROM dbo.customer_order_lines
GROUP BY customer_order_id;


/*==============================================================================
  9.6.2 SHIPPED QUANTITY
==============================================================================*/

SELECT
    customer_order_id,
    SUM(shipped_quantity) AS shipped_qty

FROM dbo.shipment_lines

GROUP BY customer_order_id;


/*==============================================================================
  9.6.3 FILL RATE
==============================================================================*/

WITH Ordered AS
(
    SELECT
        customer_order_id,
        SUM(quantity) AS ordered_qty
    FROM dbo.customer_order_lines
    GROUP BY customer_order_id
),

Shipped AS
(
    SELECT
        customer_order_id,
        SUM(shipped_quantity) AS shipped_qty
    FROM dbo.shipment_lines
    GROUP BY customer_order_id
)

SELECT
    o.customer_order_id,
    o.ordered_qty,

    CASE
        WHEN s.shipped_qty IS NULL THEN 0
        ELSE s.shipped_qty
    END AS shipped_qty,

    CASE
        WHEN o.ordered_qty > 0
        THEN
            CASE
                WHEN s.shipped_qty IS NULL THEN 0
                ELSE s.shipped_qty
            END * 100.0 / o.ordered_qty
        ELSE NULL
    END AS fill_rate_pct

FROM Ordered o
LEFT JOIN Shipped s
    ON o.customer_order_id = s.customer_order_id

ORDER BY fill_rate_pct;


/*==============================================================================
  9.6.4 BACKORDER QUANTITY
==============================================================================*/

WITH Ordered AS
(
    SELECT customer_order_id, SUM(quantity) AS ordered_qty
    FROM dbo.customer_order_lines
    GROUP BY customer_order_id
),

Shipped AS
(
    SELECT customer_order_id, SUM(shipped_quantity) AS shipped_qty
    FROM dbo.shipment_lines
    GROUP BY customer_order_id
)

SELECT
    o.customer_order_id,

    CASE
        WHEN s.shipped_qty IS NULL
            THEN o.ordered_qty

        WHEN o.ordered_qty > s.shipped_qty
            THEN o.ordered_qty - s.shipped_qty

        ELSE 0
    END AS backorder_qty

FROM Ordered o
LEFT JOIN Shipped s
    ON o.customer_order_id = s.customer_order_id

ORDER BY backorder_qty DESC;


/*==============================================================================
  9.6.5 ON-TIME CUSTOMER DELIVERY
==============================================================================*/

SELECT
    COUNT(*) AS completed_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date <= promised_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS on_time_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date <= promised_delivery_date
            THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS on_time_delivery_pct

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL;


/*==============================================================================
  9.6.6 PERFECT ORDER

  Implementation approach:
  fulfilled + on time + no return.
==============================================================================*/

WITH Ordered AS
(
    SELECT customer_order_id, SUM(quantity) AS ordered_qty
    FROM dbo.customer_order_lines
    GROUP BY customer_order_id
),

Shipped AS
(
    SELECT customer_order_id, SUM(shipped_quantity) AS shipped_qty
    FROM dbo.shipment_lines
    GROUP BY customer_order_id
),

Returned AS
(
    SELECT customer_order_id, COUNT(*) AS return_count
    FROM dbo.returns
    GROUP BY customer_order_id
)

SELECT
    o.customer_order_id,

    CASE
        WHEN s.shipped_qty >= o.ordered_qty
         AND r.return_count IS NULL
        THEN 'Potential Perfect Order'

        ELSE 'Exception Order'
    END AS order_quality

FROM Ordered o
LEFT JOIN Shipped s
    ON o.customer_order_id = s.customer_order_id
LEFT JOIN Returned r
    ON o.customer_order_id = r.customer_order_id;


/*==============================================================================
  9.6.7 ORDER CYCLE TIME
==============================================================================*/

SELECT
    co.customer_order_id,

    DATEDIFF(
        DAY,
        co.order_date,
        MAX(s.actual_delivery_date)
    ) AS order_cycle_days

FROM dbo.customer_orders co
JOIN dbo.shipments s
    ON co.customer_order_id = s.customer_order_id

WHERE s.actual_delivery_date IS NOT NULL

GROUP BY
    co.customer_order_id,
    co.order_date

ORDER BY order_cycle_days DESC;


/*##############################################################################
  9.7 WAREHOUSE
##############################################################################*/


/*==============================================================================
  9.7.1 WAREHOUSE ACTIVITY
==============================================================================*/

SELECT
    warehouse_id,
    COUNT(*) AS operations
FROM dbo.warehouse_operations
GROUP BY warehouse_id
ORDER BY operations DESC;


/*==============================================================================
  9.7.2 THROUGHPUT
==============================================================================*/

SELECT
    warehouse_id,
    SUM(units_processed) AS units_processed
FROM dbo.warehouse_operations
GROUP BY warehouse_id
ORDER BY units_processed DESC;


/*==============================================================================
  9.7.3 PICK PRODUCTIVITY
==============================================================================*/

SELECT
    warehouse_id,

    SUM(lines_picked) AS lines_picked,
    SUM(labour_hours) AS labour_hours,

    CASE
        WHEN SUM(labour_hours) > 0
        THEN SUM(lines_picked) * 1.0
             / SUM(labour_hours)
        ELSE NULL
    END AS lines_per_labour_hour

FROM dbo.warehouse_operations

GROUP BY warehouse_id

ORDER BY lines_per_labour_hour DESC;


/*==============================================================================
  9.7.4 PICK ERROR RATE
==============================================================================*/

SELECT
    warehouse_id,

    SUM(pick_errors) AS pick_errors,
    SUM(lines_picked) AS lines_picked,

    CASE
        WHEN SUM(lines_picked) > 0
        THEN SUM(pick_errors) * 100.0
             / SUM(lines_picked)
        ELSE NULL
    END AS pick_error_rate_pct

FROM dbo.warehouse_operations

GROUP BY warehouse_id

ORDER BY pick_error_rate_pct DESC;


/*==============================================================================
  9.7.5 CAPACITY UTILISATION

  Use actual capacity field from warehouses.
==============================================================================*/

SELECT
    wo.warehouse_id,

    SUM(wo.units_processed) AS processed_units,
    w.daily_capacity,

    CASE
        WHEN w.daily_capacity > 0
        THEN SUM(wo.units_processed) * 100.0
             / w.daily_capacity
        ELSE NULL
    END AS capacity_utilisation_pct

FROM dbo.warehouse_operations wo
JOIN dbo.warehouses w
    ON wo.warehouse_id = w.warehouse_id

GROUP BY
    wo.warehouse_id,
    w.daily_capacity

ORDER BY capacity_utilisation_pct DESC;


/*##############################################################################
  9.8 PRODUCTION
##############################################################################*/


/*==============================================================================
  9.8.1 PRODUCTION VOLUME
==============================================================================*/

SELECT
    product_id,
    SUM(actual_good_quantity) AS good_output_qty
FROM dbo.production_orders
GROUP BY product_id
ORDER BY good_output_qty DESC;


/*==============================================================================
  9.8.2 CYCLE TIME
==============================================================================*/

SELECT
    production_order_id,

    DATEDIFF(
        DAY,
        actual_start_date,
        actual_end_date
    ) AS production_days

FROM dbo.production_orders

WHERE actual_start_date IS NOT NULL
  AND actual_end_date IS NOT NULL

ORDER BY production_days DESC;


/*==============================================================================
  9.8.3 SCHEDULE ADHERENCE
==============================================================================*/

SELECT
    production_order_id,

    CASE
        WHEN actual_start_date <= planned_start_date
            THEN 'On Schedule'
        ELSE 'Late Start'
    END AS schedule_status

FROM dbo.production_orders

WHERE actual_start_date IS NOT NULL;


/*==============================================================================
  9.8.4 YIELD
==============================================================================*/

SELECT
    product_id,

    SUM(actual_good_quantity) AS good_qty,
    SUM(scrap_quantity) AS scrap_qty,

    CASE
        WHEN SUM(actual_good_quantity + scrap_quantity) > 0

        THEN SUM(actual_good_quantity) * 100.0
             / SUM(actual_good_quantity + scrap_quantity)

        ELSE NULL
    END AS yield_pct

FROM dbo.production_orders

GROUP BY product_id

ORDER BY yield_pct;


/*==============================================================================
  9.8.5 SCRAP RATE
==============================================================================*/

SELECT
    product_id,

    CASE
        WHEN SUM(actual_good_quantity + scrap_quantity) > 0

        THEN SUM(scrap_quantity) * 100.0
             / SUM(actual_good_quantity + scrap_quantity)

        ELSE NULL
    END AS scrap_rate_pct

FROM dbo.production_orders

GROUP BY product_id

ORDER BY scrap_rate_pct DESC;


/*==============================================================================
  9.8.6 SCRAP VALUE
==============================================================================*/

SELECT
    po.product_id,

    SUM(po.scrap_quantity) AS scrap_qty,

    SUM(
        po.scrap_quantity * p.standard_cost_aud
    ) AS scrap_value_aud

FROM dbo.production_orders po
JOIN dbo.products p
    ON po.product_id = p.product_id

GROUP BY po.product_id

ORDER BY scrap_value_aud DESC;


/*==============================================================================
  9.8.7 DOWNTIME
==============================================================================*/

SELECT
    downtime_reason,
    COUNT(*) AS downtime_events,
    SUM(duration_minutes) AS downtime_minutes,
    SUM(duration_minutes) / 60.0 AS downtime_hours

FROM dbo.downtime_events

GROUP BY downtime_reason

ORDER BY downtime_minutes DESC;


/*##############################################################################
  9.9 MATERIAL / BOM
##############################################################################*/


/*==============================================================================
  9.9.1 BOM COMPONENT REQUIREMENT
==============================================================================*/

SELECT
    po.production_order_id,
    b.component_product_id,

    po.planned_quantity
        * b.quantity_per_parent AS required_component_qty

FROM dbo.production_orders po
JOIN dbo.bom b
    ON po.product_id = b.parent_product_id;


/*==============================================================================
  9.9.2 COMPONENT SHORTAGE
==============================================================================*/

WITH Required AS
(
    SELECT
        po.production_order_id,
        po.warehouse_id,
        b.component_product_id,

        po.planned_quantity
            * b.quantity_per_parent AS required_qty

    FROM dbo.production_orders po
    JOIN dbo.bom b
        ON po.product_id = b.parent_product_id
),

Available AS
(
    SELECT
        warehouse_id,
        product_id,
        AVG(quantity_on_hand * 1.0) AS available_qty

    FROM dbo.inventory_snapshots

    GROUP BY
        warehouse_id,
        product_id
)

SELECT
    r.production_order_id,
    r.component_product_id,
    r.required_qty,

    CASE
        WHEN a.available_qty IS NULL THEN 0
        ELSE a.available_qty
    END AS available_qty,

    CASE
        WHEN a.available_qty IS NULL
            THEN r.required_qty

        WHEN r.required_qty > a.available_qty
            THEN r.required_qty - a.available_qty

        ELSE 0
    END AS shortage_qty

FROM Required r
LEFT JOIN Available a
    ON r.warehouse_id = a.warehouse_id
   AND r.component_product_id = a.product_id

ORDER BY shortage_qty DESC;


/*==============================================================================
  9.9.3 MATERIAL CONSUMPTION
==============================================================================*/

SELECT
    product_id,

    SUM(
        CASE
            WHEN quantity < 0 THEN quantity * -1
            ELSE 0
        END
    ) AS consumed_qty

FROM dbo.stock_movements

GROUP BY product_id

ORDER BY consumed_qty DESC;


/*##############################################################################
  9.10 QUALITY
##############################################################################*/


/*==============================================================================
  9.10.1 INSPECTION RESULTS
==============================================================================*/

SELECT
    inspection_result,
    COUNT(*) AS inspections

FROM dbo.quality_inspections

GROUP BY inspection_result

ORDER BY inspections DESC;


/*==============================================================================
  9.10.2 DEFECT RATE BY PRODUCT
==============================================================================*/

SELECT
    product_id,

    SUM(inspected_quantity) AS inspected_qty,
    SUM(defect_quantity) AS defect_qty,

    CASE
        WHEN SUM(inspected_quantity) > 0

        THEN SUM(defect_quantity) * 100.0
             / SUM(inspected_quantity)

        ELSE NULL
    END AS defect_rate_pct

FROM dbo.quality_inspections

GROUP BY product_id

ORDER BY defect_rate_pct DESC;


/*==============================================================================
  9.10.3 DEFECT TYPE
==============================================================================*/

SELECT
    defect_type,
    COUNT(*) AS defect_records

FROM dbo.quality_inspections

WHERE defect_type IS NOT NULL

GROUP BY defect_type

ORDER BY defect_records DESC;


/*==============================================================================
  9.10.4 SUPPLIER VS PRODUCTION QUALITY
==============================================================================*/

SELECT
    source_type,

    SUM(inspected_quantity) AS inspected_qty,
    SUM(defect_quantity) AS defect_qty,

    CASE
        WHEN SUM(inspected_quantity) > 0

        THEN SUM(defect_quantity) * 100.0
             / SUM(inspected_quantity)

        ELSE NULL
    END AS defect_rate_pct

FROM dbo.quality_inspections

GROUP BY source_type

ORDER BY defect_rate_pct DESC;


/*##############################################################################
  9.11 LOGISTICS
##############################################################################*/


/*==============================================================================
  9.11.1 TOTAL FREIGHT COST

  Stay at SHIPMENT GRAIN.
==============================================================================*/

SELECT
    SUM(freight_cost) AS total_freight_cost
FROM dbo.shipments;


/*==============================================================================
  9.11.2 FREIGHT BY CARRIER
==============================================================================*/

SELECT
    carrier_id,

    COUNT(*) AS shipment_count,
    SUM(freight_cost) AS total_freight,
    AVG(freight_cost) AS avg_freight

FROM dbo.shipments

GROUP BY carrier_id

ORDER BY total_freight DESC;


/*==============================================================================
  9.11.3 TRANSPORT LEAD TIME
==============================================================================*/

SELECT
    carrier_id,

    AVG(
        DATEDIFF(
            DAY,
            shipment_date,
            actual_delivery_date
        ) * 1.0
    ) AS avg_transport_days

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL

GROUP BY carrier_id

ORDER BY avg_transport_days DESC;


/*==============================================================================
  9.11.4 DELIVERY PERFORMANCE
==============================================================================*/

SELECT
    carrier_id,

    COUNT(*) AS completed_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date <= promised_delivery_date
                THEN 1
            ELSE 0
        END
    ) AS on_time_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date <= promised_delivery_date
                THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS on_time_pct

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL

GROUP BY carrier_id

ORDER BY on_time_pct DESC;


/*==============================================================================
  9.11.5 LATE DELIVERY
==============================================================================*/

SELECT
    shipment_id,
    carrier_id,

    DATEDIFF(
        DAY,
        promised_delivery_date,
        actual_delivery_date
    ) AS days_late

FROM dbo.shipments

WHERE actual_delivery_date > promised_delivery_date

ORDER BY days_late DESC;


/*==============================================================================
  9.11.6 MODE PERFORMANCE

  If shipment mode exists.
==============================================================================*/

SELECT
    shipping_mode,

    COUNT(*) AS shipments,
    AVG(freight_cost) AS avg_freight,

    AVG(
        CASE
            WHEN actual_delivery_date IS NOT NULL
            THEN
                DATEDIFF(
                    DAY,
                    shipment_date,
                    actual_delivery_date
                ) * 1.0
        END
    ) AS avg_delivery_days

FROM dbo.shipments

GROUP BY shipping_mode;


/*==============================================================================
  9.11.7 SHIPMENT STATUS
==============================================================================*/

SELECT
    shipment_status,
    COUNT(*) AS shipments

FROM dbo.shipments

GROUP BY shipment_status

ORDER BY shipments DESC;


/*##############################################################################
  9.12 RETURNS
##############################################################################*/


/*==============================================================================
  9.12.1 RETURNS BY REASON
==============================================================================*/

SELECT
    return_reason,
    COUNT(*) AS return_events

FROM dbo.returns

GROUP BY return_reason

ORDER BY return_events DESC;


/*==============================================================================
  9.12.2 RETURNS BY PRODUCT
==============================================================================*/

SELECT
    product_id,
    SUM(return_quantity) AS returned_qty

FROM dbo.returns

GROUP BY product_id

ORDER BY returned_qty DESC;


/*==============================================================================
  9.12.3 RETURN RATE
==============================================================================*/

WITH Shipped AS
(
    SELECT
        product_id,
        SUM(shipped_quantity) AS shipped_qty

    FROM dbo.shipment_lines

    GROUP BY product_id
),

Returned AS
(
    SELECT
        product_id,
        SUM(return_quantity) AS returned_qty

    FROM dbo.returns

    GROUP BY product_id
)

SELECT
    s.product_id,
    s.shipped_qty,

    CASE
        WHEN r.returned_qty IS NULL THEN 0
        ELSE r.returned_qty
    END AS returned_qty,

    CASE
        WHEN s.shipped_qty > 0

        THEN
            CASE
                WHEN r.returned_qty IS NULL THEN 0
                ELSE r.returned_qty
            END
            * 100.0 / s.shipped_qty

        ELSE NULL
    END AS return_rate_pct

FROM Shipped s
LEFT JOIN Returned r
    ON s.product_id = r.product_id

ORDER BY return_rate_pct DESC;


/*==============================================================================
  9.12.4 RETURN VALUE PROXY
==============================================================================*/

SELECT
    r.product_id,

    SUM(r.return_quantity) AS returned_qty,

    SUM(
        r.return_quantity * p.standard_cost_aud
    ) AS returned_value_proxy_aud

FROM dbo.returns r
JOIN dbo.products p
    ON r.product_id = p.product_id

GROUP BY r.product_id

ORDER BY returned_value_proxy_aud DESC;


/*##############################################################################
  9.13 NETWORK
##############################################################################*/


/*==============================================================================
  9.13.1 INVENTORY BY REGION
==============================================================================*/

SELECT
    r.region_name,
    SUM(i.quantity_on_hand) AS inventory_units

FROM dbo.inventory_snapshots i
JOIN dbo.warehouses w
    ON i.warehouse_id = w.warehouse_id
JOIN dbo.regions r
    ON w.region_id = r.region_id

GROUP BY r.region_name

ORDER BY inventory_units DESC;


/*==============================================================================
  9.13.2 DEMAND BY REGION
==============================================================================*/

SELECT
    r.region_name,
    SUM(col.quantity) AS demand_qty

FROM dbo.customer_orders co
JOIN dbo.customer_order_lines col
    ON co.customer_order_id = col.customer_order_id
JOIN dbo.warehouses w
    ON co.warehouse_id = w.warehouse_id
JOIN dbo.regions r
    ON w.region_id = r.region_id

GROUP BY r.region_name

ORDER BY demand_qty DESC;


/*==============================================================================
  9.13.3 SUPPLY-DEMAND COMPARISON BY WAREHOUSE
==============================================================================*/

WITH Demand AS
(
    SELECT
        co.warehouse_id,
        SUM(col.quantity) AS demand_qty

    FROM dbo.customer_orders co
    JOIN dbo.customer_order_lines col
        ON co.customer_order_id = col.customer_order_id

    GROUP BY co.warehouse_id
),

Inventory AS
(
    SELECT
        warehouse_id,
        AVG(quantity_on_hand * 1.0) AS avg_inventory_qty

    FROM dbo.inventory_snapshots

    GROUP BY warehouse_id
)

SELECT
    i.warehouse_id,
    i.avg_inventory_qty,

    CASE
        WHEN d.demand_qty IS NULL THEN 0
        ELSE d.demand_qty
    END AS demand_qty

FROM Inventory i
LEFT JOIN Demand d
    ON i.warehouse_id = d.warehouse_id

ORDER BY i.avg_inventory_qty DESC;


/*##############################################################################
  9.14 BOTTLENECKS / EXCEPTIONS / SLA
##############################################################################*/


/*==============================================================================
  9.14.1 OPERATIONAL EXCEPTION COUNTS

  Set operation — UNION ALL
==============================================================================*/

SELECT
    'Stockout' AS exception_type,
    COUNT(*) AS exception_count
FROM dbo.inventory_snapshots
WHERE quantity_on_hand <= 0

UNION ALL

SELECT
    'Late Shipment',
    COUNT(*)
FROM dbo.shipments
WHERE actual_delivery_date > promised_delivery_date

UNION ALL

SELECT
    'Quality Failure',
    COUNT(*)
FROM dbo.quality_inspections
WHERE inspection_result = 'Fail'

UNION ALL

SELECT
    'Return',
    COUNT(*)
FROM dbo.returns

UNION ALL

SELECT
    'Downtime',
    COUNT(*)
FROM dbo.downtime_events;


/*==============================================================================
  9.14.2 CUSTOMER SLA BREACH
==============================================================================*/

SELECT
    shipment_id,
    customer_order_id,
    promised_delivery_date,
    actual_delivery_date,

    DATEDIFF(
        DAY,
        promised_delivery_date,
        actual_delivery_date
    ) AS sla_days_late

FROM dbo.shipments

WHERE actual_delivery_date > promised_delivery_date

ORDER BY sla_days_late DESC;


/*==============================================================================
  9.14.3 OPEN OVERDUE SHIPMENTS
==============================================================================*/

SELECT
    shipment_id,
    customer_order_id,
    promised_delivery_date,

    DATEDIFF(
        DAY,
        promised_delivery_date,
        GETDATE()
    ) AS days_overdue

FROM dbo.shipments

WHERE actual_delivery_date IS NULL
  AND promised_delivery_date < GETDATE()

ORDER BY days_overdue DESC;


/*==============================================================================
  9.14.4 PRODUCT BOTTLENECK SIGNAL

  Stockout + single supplier.
==============================================================================*/

WITH Stockout AS
(
    SELECT
        product_id,
        COUNT(*) AS stockout_events

    FROM dbo.inventory_snapshots

    WHERE quantity_on_hand <= 0

    GROUP BY product_id
),

Suppliers AS
(
    SELECT
        product_id,
        COUNT(DISTINCT supplier_id) AS supplier_count

    FROM dbo.supplier_products

    GROUP BY product_id
)

SELECT
    s.product_id,
    s.stockout_events,
    sp.supplier_count

FROM Stockout s
JOIN Suppliers sp
    ON s.product_id = sp.product_id

WHERE sp.supplier_count = 1

ORDER BY s.stockout_events DESC;


/*==============================================================================
  CHAPTER 9 — FINAL COVERAGE CHECK
==============================================================================*/

/*

  INVENTORY
  [X] levels
  [X] value
  [X] turnover
  [X] days inventory
  [X] stockout
  [X] understock/reorder
  [X] safety stock
  [X] slow/fast
  [X] dead stock
  [X] ABC

  DEMAND / FORECAST
  [X] volume
  [X] trend
  [X] variability
  [X] seasonality
  [X] forecast vs actual
  [X] forecast error

  PROCUREMENT
  [X] purchased quantity
  [X] spend
  [X] supplier spend
  [X] category spend
  [X] contract compliance
  [X] maverick spend
  [X] price variation
  [X] PPV
  [X] favourable variance

  SUPPLIERS
  [X] volume
  [X] lead time
  [X] variability
  [X] on-time
  [X] quality
  [X] OTIF
  [X] ranking
  [X] concentration

  PURCHASE ORDERS
  [X] volume
  [X] open
  [X] late
  [X] partial receipt
  [X] cycle time

  FULFILMENT
  [X] ordered
  [X] shipped
  [X] fill rate
  [X] backorders
  [X] customer service
  [X] perfect-order signal
  [X] order cycle time

  WAREHOUSE
  [X] activity
  [X] throughput
  [X] productivity
  [X] error rate
  [X] capacity

  PRODUCTION
  [X] throughput
  [X] cycle time
  [X] schedule adherence
  [X] yield
  [X] scrap
  [X] scrap value
  [X] downtime

  BOM
  [X] requirement
  [X] shortage
  [X] consumption

  QUALITY
  [X] inspections
  [X] defect rate
  [X] defect type
  [X] source comparison

  LOGISTICS
  [X] freight
  [X] carrier performance
  [X] transport time
  [X] late delivery
  [X] mode
  [X] shipment status

  RETURNS
  [X] reason
  [X] product
  [X] rate
  [X] value proxy

  NETWORK
  [X] warehouse
  [X] region
  [X] supply-demand matching

  END-TO-END
  [X] exceptions
  [X] SLA breaches
  [X] overdue shipments
  [X] bottleneck signals


  CHAPTER 9 STATUS:
      COMPLETE — INTEGRATED ANALYSIS

  NEXT:
      CHAPTER 10 — KPI DEVELOPMENT
*/


/*==============================================================================
  SOUTHERN CROSS INDUSTRIAL SUPPLY
  CHAPTER 10 — KPI DEVELOPMENT
  INTEGRATED ANALYSIS

  PURPOSE:
  Chapter 9 = investigate the supply chain.
  Chapter 10 = convert important calculations into repeatable KPIs.

  EVERY KPI SHOULD HAVE:
      1. Business meaning
      2. Formula
      3. Numerator
      4. Denominator
      5. Grain
      6. Time period
      7. Interpretation

  CORE SQL TECHNIQUES:
      core analytical SQL patterns

  RULE:
      Targets must be sourced from approved business thresholds or contractual requirements.
      Calculate actual performance first.
==============================================================================*/

USE SCIS;
GO


/*##############################################################################
  10.1 INVENTORY KPIs
##############################################################################*/


/*==============================================================================
  KPI 10.1.1 — AVERAGE INVENTORY

  Meaning:
      Typical quantity held for each product.

  Formula:
      SUM(snapshot quantity) / number of snapshots

  Grain:
      Product
==============================================================================*/

SELECT
    product_id,
    AVG(quantity_on_hand * 1.0) AS avg_inventory_qty
FROM dbo.inventory_snapshots
GROUP BY product_id
ORDER BY avg_inventory_qty DESC;


/*==============================================================================
  KPI 10.1.2 — INVENTORY VALUE

  Formula:
      average inventory × standard cost
==============================================================================*/

SELECT
    i.product_id,
    AVG(i.quantity_on_hand * 1.0) AS avg_inventory_qty,
    p.standard_cost_aud,

    AVG(i.quantity_on_hand * 1.0)
        * p.standard_cost_aud AS avg_inventory_value_aud

FROM dbo.inventory_snapshots i
JOIN dbo.products p
    ON i.product_id = p.product_id

GROUP BY
    i.product_id,
    p.standard_cost_aud

ORDER BY avg_inventory_value_aud DESC;


/*==============================================================================
  KPI 10.1.3 — INVENTORY TURNOVER

  Meaning:
      How many times inventory moves through the system.

  Numerator:
      outbound quantity

  Denominator:
      average inventory
==============================================================================*/

WITH Inventory AS
(
    SELECT
        product_id,
        AVG(quantity_on_hand * 1.0) AS avg_inventory
    FROM dbo.inventory_snapshots
    GROUP BY product_id
),

Outbound AS
(
    SELECT
        product_id,

        SUM(
            CASE
                WHEN quantity < 0 THEN quantity * -1
                ELSE 0
            END
        ) AS outbound_qty

    FROM dbo.stock_movements
    GROUP BY product_id
)

SELECT
    i.product_id,
    i.avg_inventory,
    o.outbound_qty,

    CASE
        WHEN i.avg_inventory > 0
        THEN o.outbound_qty / i.avg_inventory
        ELSE NULL
    END AS inventory_turnover

FROM Inventory i
JOIN Outbound o
    ON i.product_id = o.product_id

ORDER BY inventory_turnover DESC;


/*==============================================================================
  KPI 10.1.4 — DAYS INVENTORY

  Meaning:
      Approximate number of days current inventory represents.

  Formula:
      average inventory / outbound quantity × 365
==============================================================================*/

WITH Inventory AS
(
    SELECT
        product_id,
        AVG(quantity_on_hand * 1.0) AS avg_inventory
    FROM dbo.inventory_snapshots
    GROUP BY product_id
),

Outbound AS
(
    SELECT
        product_id,
        SUM(CASE WHEN quantity < 0 THEN quantity * -1 ELSE 0 END)
            AS outbound_qty
    FROM dbo.stock_movements
    GROUP BY product_id
)

SELECT
    i.product_id,

    CASE
        WHEN o.outbound_qty > 0
        THEN i.avg_inventory / o.outbound_qty * 365
        ELSE NULL
    END AS days_inventory

FROM Inventory i
JOIN Outbound o
    ON i.product_id = o.product_id

ORDER BY days_inventory DESC;


/*==============================================================================
  KPI 10.1.5 — STOCKOUT RATE

  Numerator:
      snapshots where inventory <= 0

  Denominator:
      all inventory snapshots
==============================================================================*/

SELECT
    COUNT(*) AS total_inventory_snapshots,

    SUM(
        CASE
            WHEN quantity_on_hand <= 0 THEN 1
            ELSE 0
        END
    ) AS stockout_snapshots,

    SUM(
        CASE
            WHEN quantity_on_hand <= 0 THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS stockout_rate_pct

FROM dbo.inventory_snapshots;


/*==============================================================================
  KPI 10.1.6 — STOCKOUT RATE BY PRODUCT
==============================================================================*/

SELECT
    product_id,

    COUNT(*) AS snapshots,

    SUM(
        CASE WHEN quantity_on_hand <= 0 THEN 1 ELSE 0 END
    ) AS stockout_snapshots,

    SUM(
        CASE WHEN quantity_on_hand <= 0 THEN 1 ELSE 0 END
    ) * 100.0 / COUNT(*) AS stockout_rate_pct

FROM dbo.inventory_snapshots

GROUP BY product_id

ORDER BY stockout_rate_pct DESC;


/*==============================================================================
  KPI 10.1.7 — BELOW REORDER POINT %

  Numerator:
      inventory records <= reorder point

  Denominator:
      inventory records with matching product
==============================================================================*/

SELECT
    COUNT(*) AS inventory_records,

    SUM(
        CASE
            WHEN i.quantity_on_hand <= p.reorder_point THEN 1
            ELSE 0
        END
    ) AS reorder_breach_records,

    SUM(
        CASE
            WHEN i.quantity_on_hand <= p.reorder_point THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS reorder_breach_pct

FROM dbo.inventory_snapshots i
JOIN dbo.products p
    ON i.product_id = p.product_id;


/*==============================================================================
  KPI 10.1.8 — SAFETY STOCK BREACH %
==============================================================================*/

SELECT
    COUNT(*) AS inventory_records,

    SUM(
        CASE
            WHEN i.quantity_on_hand < p.safety_stock THEN 1
            ELSE 0
        END
    ) AS safety_stock_breaches,

    SUM(
        CASE
            WHEN i.quantity_on_hand < p.safety_stock THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS safety_stock_breach_pct

FROM dbo.inventory_snapshots i
JOIN dbo.products p
    ON i.product_id = p.product_id;


/*##############################################################################
  10.2 DEMAND & FORECAST KPIs
##############################################################################*/


/*==============================================================================
  KPI 10.2.1 — AVERAGE MONTHLY DEMAND
==============================================================================*/

WITH MonthlyDemand AS
(
    SELECT
        YEAR(co.order_date) AS yr,
        MONTH(co.order_date) AS mn,
        col.product_id,
        SUM(col.quantity) AS demand_qty

    FROM dbo.customer_orders co
    JOIN dbo.customer_order_lines col
        ON co.customer_order_id = col.customer_order_id

    GROUP BY
        YEAR(co.order_date),
        MONTH(co.order_date),
        col.product_id
)

SELECT
    product_id,
    AVG(demand_qty * 1.0) AS avg_monthly_demand
FROM MonthlyDemand
GROUP BY product_id
ORDER BY avg_monthly_demand DESC;


/*==============================================================================
  KPI 10.2.2 — DEMAND RANGE

  Baseline variability KPI.

  Formula:
      highest month - lowest month
==============================================================================*/

WITH MonthlyDemand AS
(
    SELECT
        YEAR(co.order_date) AS yr,
        MONTH(co.order_date) AS mn,
        col.product_id,
        SUM(col.quantity) AS demand_qty

    FROM dbo.customer_orders co
    JOIN dbo.customer_order_lines col
        ON co.customer_order_id = col.customer_order_id

    GROUP BY
        YEAR(co.order_date),
        MONTH(co.order_date),
        col.product_id
)

SELECT
    product_id,
    MIN(demand_qty) AS min_monthly_demand,
    MAX(demand_qty) AS max_monthly_demand,
    MAX(demand_qty) - MIN(demand_qty) AS demand_range

FROM MonthlyDemand

GROUP BY product_id
ORDER BY demand_range DESC;


/*==============================================================================
  KPI 10.2.3 — FORECAST ERROR

  Formula:
      actual demand - forecast demand

  Positive:
      demand exceeded forecast

  Negative:
      forecast exceeded demand
==============================================================================*/

WITH Actual AS
(
    SELECT
        product_id,
        SUM(quantity) AS actual_qty
    FROM dbo.customer_order_lines
    GROUP BY product_id
),

Forecast AS
(
    SELECT
        product_id,
        forecast_version,
        SUM(forecast_quantity) AS forecast_qty

    FROM dbo.demand_forecast

    GROUP BY
        product_id,
        forecast_version
)

SELECT
    f.product_id,
    f.forecast_version,
    f.forecast_qty,
    a.actual_qty,

    a.actual_qty - f.forecast_qty AS forecast_error

FROM Forecast f
JOIN Actual a
    ON f.product_id = a.product_id;


/*==============================================================================
  KPI 10.2.4 — ABSOLUTE FORECAST ERROR %
==============================================================================*/

WITH Actual AS
(
    SELECT
        product_id,
        SUM(quantity) AS actual_qty
    FROM dbo.customer_order_lines
    GROUP BY product_id
),

Forecast AS
(
    SELECT
        product_id,
        forecast_version,
        SUM(forecast_quantity) AS forecast_qty
    FROM dbo.demand_forecast
    GROUP BY product_id, forecast_version
)

SELECT
    f.product_id,
    f.forecast_version,
    a.actual_qty,
    f.forecast_qty,

    CASE
        WHEN a.actual_qty > 0
        THEN
            CASE
                WHEN a.actual_qty - f.forecast_qty < 0
                THEN (a.actual_qty - f.forecast_qty) * -100.0
                     / a.actual_qty

                ELSE (a.actual_qty - f.forecast_qty) * 100.0
                     / a.actual_qty
            END

        ELSE NULL
    END AS absolute_forecast_error_pct

FROM Forecast f
JOIN Actual a
    ON f.product_id = a.product_id

ORDER BY absolute_forecast_error_pct DESC;


/*##############################################################################
  10.3 PROCUREMENT KPIs
##############################################################################*/


/*==============================================================================
  KPI 10.3.1 — PROCUREMENT SPEND

  Keep currency separated unless converted.
==============================================================================*/

SELECT
    po.currency_code,

    SUM(
        pol.ordered_quantity * pol.unit_price
    ) AS procurement_spend

FROM dbo.purchase_orders po
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id

GROUP BY po.currency_code;


/*==============================================================================
  KPI 10.3.2 — CONTRACT COMPLIANCE RATE
==============================================================================*/

SELECT
    COUNT(*) AS po_lines,

    SUM(
        CASE
            WHEN contract_compliant_flag = 1 THEN 1
            ELSE 0
        END
    ) AS compliant_lines,

    SUM(
        CASE
            WHEN contract_compliant_flag = 1 THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS contract_compliance_pct

FROM dbo.purchase_order_lines;


/*==============================================================================
  KPI 10.3.3 — MAVERICK SPEND %

  Numerator:
      non-compliant spend

  Denominator:
      total spend

  Keep currencies separate.
==============================================================================*/

SELECT
    po.currency_code,

    SUM(
        CASE
            WHEN pol.contract_compliant_flag = 0
            THEN pol.ordered_quantity * pol.unit_price
            ELSE 0
        END
    ) AS non_compliant_spend,

    SUM(
        pol.ordered_quantity * pol.unit_price
    ) AS total_spend,

    CASE
        WHEN SUM(pol.ordered_quantity * pol.unit_price) > 0

        THEN
            SUM(
                CASE
                    WHEN pol.contract_compliant_flag = 0
                    THEN pol.ordered_quantity * pol.unit_price
                    ELSE 0
                END
            ) * 100.0
            /
            SUM(pol.ordered_quantity * pol.unit_price)

        ELSE NULL
    END AS maverick_spend_pct

FROM dbo.purchase_orders po
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id

GROUP BY po.currency_code;


/*==============================================================================
  KPI 10.3.4 — PURCHASE PRICE SPREAD
==============================================================================*/

SELECT
    product_id,

    MIN(unit_price) AS min_price,
    AVG(unit_price) AS avg_price,
    MAX(unit_price) AS max_price,

    MAX(unit_price) - MIN(unit_price)
        AS purchase_price_spread

FROM dbo.purchase_order_lines

GROUP BY product_id

ORDER BY purchase_price_spread DESC;


/*==============================================================================
  KPI 10.3.5 — PURCHASE PRICE VARIANCE

  actual - contract/reference price
==============================================================================*/

SELECT
    pol.product_id,
    po.supplier_id,

    AVG(
        pol.unit_price - sp.contract_unit_price
    ) AS avg_unit_ppv

FROM dbo.purchase_order_lines pol
JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id
JOIN dbo.supplier_products sp
    ON po.supplier_id = sp.supplier_id
   AND pol.product_id = sp.product_id

GROUP BY
    pol.product_id,
    po.supplier_id

ORDER BY avg_unit_ppv DESC;


/*##############################################################################
  10.4 SUPPLIER KPIs
##############################################################################*/


/*==============================================================================
  KPI 10.4.1 — AVERAGE SUPPLIER LEAD TIME
==============================================================================*/

SELECT
    po.supplier_id,

    AVG(
        DATEDIFF(
            DAY,
            po.order_date,
            gr.receipt_date
        ) * 1.0
    ) AS avg_lead_time_days

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY avg_lead_time_days DESC;


/*==============================================================================
  KPI 10.4.2 — SUPPLIER ON-TIME DELIVERY RATE
==============================================================================*/

SELECT
    po.supplier_id,

    COUNT(*) AS receipts,

    SUM(
        CASE
            WHEN gr.receipt_date <= po.expected_delivery_date THEN 1
            ELSE 0
        END
    ) AS on_time_receipts,

    SUM(
        CASE
            WHEN gr.receipt_date <= po.expected_delivery_date THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS supplier_on_time_pct

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY supplier_on_time_pct DESC;


/*==============================================================================
  KPI 10.4.3 — SUPPLIER OTIF

  OTIF =
      delivered on time
      AND delivered in full
==============================================================================*/

SELECT
    po.supplier_id,

    COUNT(*) AS receipt_records,

    SUM(
        CASE
            WHEN gr.receipt_date <= po.expected_delivery_date
             AND gr.received_quantity >= gr.ordered_quantity
            THEN 1
            ELSE 0
        END
    ) AS otif_records,

    SUM(
        CASE
            WHEN gr.receipt_date <= po.expected_delivery_date
             AND gr.received_quantity >= gr.ordered_quantity
            THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS supplier_otif_pct

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY supplier_otif_pct DESC;


/*==============================================================================
  KPI 10.4.4 — SUPPLIER REJECTION RATE
==============================================================================*/

SELECT
    po.supplier_id,

    SUM(gr.received_quantity) AS received_qty,
    SUM(gr.rejected_quantity) AS rejected_qty,

    CASE
        WHEN SUM(gr.received_quantity) > 0

        THEN
            SUM(gr.rejected_quantity) * 100.0
            / SUM(gr.received_quantity)

        ELSE NULL
    END AS supplier_rejection_rate_pct

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY supplier_rejection_rate_pct DESC;


/*==============================================================================
  KPI 10.4.5 — SUPPLIER CONCENTRATION

  Percentage of PO quantity supplied by each supplier.
==============================================================================*/

WITH SupplierVolume AS
(
    SELECT
        po.supplier_id,
        SUM(pol.ordered_quantity) AS supplied_qty

    FROM dbo.purchase_orders po
    JOIN dbo.purchase_order_lines pol
        ON po.purchase_order_id = pol.purchase_order_id

    GROUP BY po.supplier_id
)

SELECT
    supplier_id,
    supplied_qty,

    supplied_qty * 100.0
        / SUM(supplied_qty) OVER()
        AS supply_concentration_pct

FROM SupplierVolume

ORDER BY supply_concentration_pct DESC;


/*==============================================================================
  KPI 10.4.6 — SINGLE-SOURCE PRODUCT COUNT
==============================================================================*/

SELECT
    COUNT(*) AS single_source_products

FROM
(
    SELECT
        product_id

    FROM dbo.supplier_products

    GROUP BY product_id

    HAVING COUNT(DISTINCT supplier_id) = 1
) x;


/*##############################################################################
  10.5 PURCHASE ORDER KPIs
##############################################################################*/


/*==============================================================================
  KPI 10.5.1 — OPEN PO COUNT
==============================================================================*/

SELECT
    COUNT(*) AS open_po_count
FROM dbo.purchase_orders
WHERE po_status IN ('Open', 'Partial', 'Pending');


/*==============================================================================
  KPI 10.5.2 — LATE RECEIPT RATE
==============================================================================*/

SELECT
    COUNT(*) AS receipt_count,

    SUM(
        CASE
            WHEN gr.receipt_date > po.expected_delivery_date THEN 1
            ELSE 0
        END
    ) AS late_receipts,

    SUM(
        CASE
            WHEN gr.receipt_date > po.expected_delivery_date THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS late_receipt_pct

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id;


/*==============================================================================
  KPI 10.5.3 — PARTIAL RECEIPT RATE
==============================================================================*/

WITH ReceiptStatus AS
(
    SELECT
        purchase_order_id,

        SUM(ordered_quantity) AS ordered_qty,
        SUM(received_quantity) AS received_qty

    FROM dbo.goods_receipts

    GROUP BY purchase_order_id
)

SELECT
    COUNT(*) AS purchase_orders,

    SUM(
        CASE
            WHEN received_qty < ordered_qty THEN 1
            ELSE 0
        END
    ) AS partial_receipt_pos,

    SUM(
        CASE
            WHEN received_qty < ordered_qty THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS partial_receipt_pct

FROM ReceiptStatus;


/*==============================================================================
  KPI 10.5.4 — AVERAGE PO CYCLE TIME
==============================================================================*/

WITH POCycle AS
(
    SELECT
        po.purchase_order_id,
        po.order_date,
        MAX(gr.receipt_date) AS final_receipt_date

    FROM dbo.purchase_orders po
    JOIN dbo.goods_receipts gr
        ON po.purchase_order_id = gr.purchase_order_id

    GROUP BY
        po.purchase_order_id,
        po.order_date
)

SELECT
    AVG(
        DATEDIFF(
            DAY,
            order_date,
            final_receipt_date
        ) * 1.0
    ) AS avg_po_cycle_days

FROM POCycle;


/*##############################################################################
  10.6 CUSTOMER FULFILMENT KPIs
##############################################################################*/


/*==============================================================================
  KPI 10.6.1 — FILL RATE

  Numerator:
      shipped quantity

  Denominator:
      ordered quantity
==============================================================================*/

WITH Ordered AS
(
    SELECT
        customer_order_id,
        SUM(quantity) AS ordered_qty

    FROM dbo.customer_order_lines

    GROUP BY customer_order_id
),

Shipped AS
(
    SELECT
        customer_order_id,
        SUM(shipped_quantity) AS shipped_qty

    FROM dbo.shipment_lines

    GROUP BY customer_order_id
)

SELECT
    SUM(
        CASE
            WHEN s.shipped_qty IS NULL THEN 0
            ELSE s.shipped_qty
        END
    ) AS shipped_qty,

    SUM(o.ordered_qty) AS ordered_qty,

    CASE
        WHEN SUM(o.ordered_qty) > 0

        THEN
            SUM(
                CASE
                    WHEN s.shipped_qty IS NULL THEN 0
                    ELSE s.shipped_qty
                END
            ) * 100.0
            / SUM(o.ordered_qty)

        ELSE NULL
    END AS overall_fill_rate_pct

FROM Ordered o
LEFT JOIN Shipped s
    ON o.customer_order_id = s.customer_order_id;


/*==============================================================================
  KPI 10.6.2 — BACKORDER RATE

  Backorder quantity / ordered quantity
==============================================================================*/

WITH Ordered AS
(
    SELECT
        customer_order_id,
        SUM(quantity) AS ordered_qty

    FROM dbo.customer_order_lines

    GROUP BY customer_order_id
),

Shipped AS
(
    SELECT
        customer_order_id,
        SUM(shipped_quantity) AS shipped_qty

    FROM dbo.shipment_lines

    GROUP BY customer_order_id
),

Result AS
(
    SELECT
        o.customer_order_id,
        o.ordered_qty,

        CASE
            WHEN s.shipped_qty IS NULL
                THEN o.ordered_qty

            WHEN o.ordered_qty > s.shipped_qty
                THEN o.ordered_qty - s.shipped_qty

            ELSE 0
        END AS backorder_qty

    FROM Ordered o
    LEFT JOIN Shipped s
        ON o.customer_order_id = s.customer_order_id
)

SELECT
    SUM(backorder_qty) AS backorder_qty,
    SUM(ordered_qty) AS ordered_qty,

    CASE
        WHEN SUM(ordered_qty) > 0
        THEN SUM(backorder_qty) * 100.0
             / SUM(ordered_qty)
        ELSE NULL
    END AS backorder_rate_pct

FROM Result;


/*==============================================================================
  KPI 10.6.3 — ON-TIME DELIVERY RATE
==============================================================================*/

SELECT
    COUNT(*) AS delivered_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date <= promised_delivery_date THEN 1
            ELSE 0
        END
    ) AS on_time_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date <= promised_delivery_date THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS on_time_delivery_pct

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL;


/*==============================================================================
  KPI 10.6.4 — LATE DELIVERY RATE
==============================================================================*/

SELECT
    COUNT(*) AS delivered_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date THEN 1
            ELSE 0
        END
    ) AS late_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS late_delivery_pct

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL;


/*==============================================================================
  KPI 10.6.5 — AVERAGE DAYS LATE

  Only late deliveries enter denominator.
==============================================================================*/

SELECT
    AVG(
        DATEDIFF(
            DAY,
            promised_delivery_date,
            actual_delivery_date
        ) * 1.0
    ) AS avg_days_late

FROM dbo.shipments

WHERE actual_delivery_date > promised_delivery_date;


/*==============================================================================
  KPI 10.6.6 — PERFECT ORDER RATE

  Operational definition:
      fully shipped
      AND no return

  Delivery timeliness can be added once order-level shipment logic
  is confirmed at exact grain.
==============================================================================*/

WITH Ordered AS
(
    SELECT
        customer_order_id,
        SUM(quantity) AS ordered_qty

    FROM dbo.customer_order_lines

    GROUP BY customer_order_id
),

Shipped AS
(
    SELECT
        customer_order_id,
        SUM(shipped_quantity) AS shipped_qty

    FROM dbo.shipment_lines

    GROUP BY customer_order_id
),

Returned AS
(
    SELECT
        customer_order_id,
        COUNT(*) AS return_events

    FROM dbo.returns

    GROUP BY customer_order_id
),

Result AS
(
    SELECT
        o.customer_order_id,

        CASE
            WHEN s.shipped_qty >= o.ordered_qty
             AND r.return_events IS NULL
            THEN 1

            ELSE 0
        END AS perfect_order_flag

    FROM Ordered o

    LEFT JOIN Shipped s
        ON o.customer_order_id = s.customer_order_id

    LEFT JOIN Returned r
        ON o.customer_order_id = r.customer_order_id
)

SELECT
    COUNT(*) AS orders,
    SUM(perfect_order_flag) AS perfect_orders,

    SUM(perfect_order_flag) * 100.0
        / COUNT(*) AS perfect_order_rate_pct

FROM Result;


/*==============================================================================
  KPI 10.6.7 — AVERAGE ORDER CYCLE TIME
==============================================================================*/

WITH OrderCycle AS
(
    SELECT
        co.customer_order_id,
        co.order_date,
        MAX(s.actual_delivery_date) AS final_delivery_date

    FROM dbo.customer_orders co
    JOIN dbo.shipments s
        ON co.customer_order_id = s.customer_order_id

    WHERE s.actual_delivery_date IS NOT NULL

    GROUP BY
        co.customer_order_id,
        co.order_date
)

SELECT
    AVG(
        DATEDIFF(
            DAY,
            order_date,
            final_delivery_date
        ) * 1.0
    ) AS avg_order_cycle_days

FROM OrderCycle;


/*##############################################################################
  10.7 WAREHOUSE KPIs
##############################################################################*/


/*==============================================================================
  KPI 10.7.1 — WAREHOUSE THROUGHPUT
==============================================================================*/

SELECT
    warehouse_id,
    SUM(units_processed) AS throughput_units
FROM dbo.warehouse_operations
GROUP BY warehouse_id
ORDER BY throughput_units DESC;


/*==============================================================================
  KPI 10.7.2 — LINES PICKED PER LABOUR HOUR
==============================================================================*/

SELECT
    warehouse_id,

    SUM(lines_picked) AS lines_picked,
    SUM(labour_hours) AS labour_hours,

    CASE
        WHEN SUM(labour_hours) > 0

        THEN SUM(lines_picked) * 1.0
             / SUM(labour_hours)

        ELSE NULL
    END AS lines_per_labour_hour

FROM dbo.warehouse_operations

GROUP BY warehouse_id

ORDER BY lines_per_labour_hour DESC;


/*==============================================================================
  KPI 10.7.3 — PICK ERROR RATE
==============================================================================*/

SELECT
    warehouse_id,

    SUM(pick_errors) AS pick_errors,
    SUM(lines_picked) AS lines_picked,

    CASE
        WHEN SUM(lines_picked) > 0

        THEN SUM(pick_errors) * 100.0
             / SUM(lines_picked)

        ELSE NULL
    END AS pick_error_rate_pct

FROM dbo.warehouse_operations

GROUP BY warehouse_id

ORDER BY pick_error_rate_pct DESC;


/*==============================================================================
  KPI 10.7.4 — CAPACITY UTILISATION
==============================================================================*/

SELECT
    wo.warehouse_id,

    SUM(wo.units_processed) AS processed_units,
    w.daily_capacity,

    CASE
        WHEN w.daily_capacity > 0

        THEN SUM(wo.units_processed) * 100.0
             / w.daily_capacity

        ELSE NULL
    END AS capacity_utilisation_pct

FROM dbo.warehouse_operations wo
JOIN dbo.warehouses w
    ON wo.warehouse_id = w.warehouse_id

GROUP BY
    wo.warehouse_id,
    w.daily_capacity

ORDER BY capacity_utilisation_pct DESC;


/*##############################################################################
  10.8 PRODUCTION KPIs
##############################################################################*/


/*==============================================================================
  KPI 10.8.1 — PRODUCTION THROUGHPUT
==============================================================================*/

SELECT
    product_id,
    SUM(actual_good_quantity) AS good_output_qty
FROM dbo.production_orders
GROUP BY product_id
ORDER BY good_output_qty DESC;


/*==============================================================================
  KPI 10.8.2 — PRODUCTION YIELD
==============================================================================*/

SELECT
    product_id,

    SUM(actual_good_quantity) AS good_qty,
    SUM(scrap_quantity) AS scrap_qty,

    CASE
        WHEN SUM(actual_good_quantity + scrap_quantity) > 0

        THEN
            SUM(actual_good_quantity) * 100.0
            / SUM(actual_good_quantity + scrap_quantity)

        ELSE NULL
    END AS yield_pct

FROM dbo.production_orders

GROUP BY product_id

ORDER BY yield_pct;


/*==============================================================================
  KPI 10.8.3 — SCRAP RATE
==============================================================================*/

SELECT
    product_id,

    CASE
        WHEN SUM(actual_good_quantity + scrap_quantity) > 0

        THEN
            SUM(scrap_quantity) * 100.0
            / SUM(actual_good_quantity + scrap_quantity)

        ELSE NULL
    END AS scrap_rate_pct

FROM dbo.production_orders

GROUP BY product_id

ORDER BY scrap_rate_pct DESC;


/*==============================================================================
  KPI 10.8.4 — SCHEDULE ADHERENCE RATE
==============================================================================*/

SELECT
    COUNT(*) AS started_orders,

    SUM(
        CASE
            WHEN actual_start_date <= planned_start_date THEN 1
            ELSE 0
        END
    ) AS on_schedule_orders,

    SUM(
        CASE
            WHEN actual_start_date <= planned_start_date THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS schedule_adherence_pct

FROM dbo.production_orders

WHERE actual_start_date IS NOT NULL;


/*==============================================================================
  KPI 10.8.5 — AVERAGE PRODUCTION CYCLE TIME
==============================================================================*/

SELECT
    AVG(
        DATEDIFF(
            DAY,
            actual_start_date,
            actual_end_date
        ) * 1.0
    ) AS avg_production_cycle_days

FROM dbo.production_orders

WHERE actual_start_date IS NOT NULL
  AND actual_end_date IS NOT NULL;


/*==============================================================================
  KPI 10.8.6 — DOWNTIME HOURS
==============================================================================*/

SELECT
    SUM(duration_minutes) / 60.0
        AS total_downtime_hours

FROM dbo.downtime_events;


/*==============================================================================
  KPI 10.8.7 — DOWNTIME BY REASON
==============================================================================*/

SELECT
    downtime_reason,
    SUM(duration_minutes) / 60.0 AS downtime_hours

FROM dbo.downtime_events

GROUP BY downtime_reason

ORDER BY downtime_hours DESC;


/*==============================================================================
  KPI 10.8.8 — SCRAP VALUE
==============================================================================*/

SELECT
    SUM(
        po.scrap_quantity
        * p.standard_cost_aud
    ) AS scrap_value_aud

FROM dbo.production_orders po
JOIN dbo.products p
    ON po.product_id = p.product_id;


/*##############################################################################
  10.9 QUALITY KPIs
##############################################################################*/


/*==============================================================================
  KPI 10.9.1 — DEFECT RATE
==============================================================================*/

SELECT
    SUM(inspected_quantity) AS inspected_qty,
    SUM(defect_quantity) AS defect_qty,

    CASE
        WHEN SUM(inspected_quantity) > 0

        THEN SUM(defect_quantity) * 100.0
             / SUM(inspected_quantity)

        ELSE NULL
    END AS defect_rate_pct

FROM dbo.quality_inspections;


/*==============================================================================
  KPI 10.9.2 — DEFECT RATE BY PRODUCT
==============================================================================*/

SELECT
    product_id,

    SUM(inspected_quantity) AS inspected_qty,
    SUM(defect_quantity) AS defect_qty,

    CASE
        WHEN SUM(inspected_quantity) > 0

        THEN SUM(defect_quantity) * 100.0
             / SUM(inspected_quantity)

        ELSE NULL
    END AS defect_rate_pct

FROM dbo.quality_inspections

GROUP BY product_id

ORDER BY defect_rate_pct DESC;


/*==============================================================================
  KPI 10.9.3 — QUALITY FAILURE RATE
==============================================================================*/

SELECT
    COUNT(*) AS inspections,

    SUM(
        CASE
            WHEN inspection_result = 'Fail' THEN 1
            ELSE 0
        END
    ) AS failed_inspections,

    SUM(
        CASE
            WHEN inspection_result = 'Fail' THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS inspection_failure_pct

FROM dbo.quality_inspections;


/*==============================================================================
  KPI 10.9.4 — DEFECT RATE BY SOURCE
==============================================================================*/

SELECT
    source_type,

    SUM(inspected_quantity) AS inspected_qty,
    SUM(defect_quantity) AS defect_qty,

    CASE
        WHEN SUM(inspected_quantity) > 0

        THEN SUM(defect_quantity) * 100.0
             / SUM(inspected_quantity)

        ELSE NULL
    END AS defect_rate_pct

FROM dbo.quality_inspections

GROUP BY source_type

ORDER BY defect_rate_pct DESC;


/*##############################################################################
  10.10 LOGISTICS KPIs
##############################################################################*/


/*==============================================================================
  KPI 10.10.1 — TOTAL FREIGHT COST

  IMPORTANT:
      SHIPMENT GRAIN.
      Freight must remain at shipment grain and must not be multiplied by shipment-line cardinality.
==============================================================================*/

SELECT
    SUM(freight_cost) AS total_freight_cost
FROM dbo.shipments;


/*==============================================================================
  KPI 10.10.2 — AVERAGE FREIGHT PER SHIPMENT
==============================================================================*/

SELECT
    AVG(freight_cost) AS avg_freight_per_shipment
FROM dbo.shipments;


/*==============================================================================
  KPI 10.10.3 — FREIGHT PER CARRIER
==============================================================================*/

SELECT
    carrier_id,
    COUNT(*) AS shipments,
    SUM(freight_cost) AS freight_cost,
    AVG(freight_cost) AS avg_freight

FROM dbo.shipments

GROUP BY carrier_id

ORDER BY freight_cost DESC;


/*==============================================================================
  KPI 10.10.4 — CARRIER ON-TIME DELIVERY RATE
==============================================================================*/

SELECT
    carrier_id,

    COUNT(*) AS completed_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date <= promised_delivery_date THEN 1
            ELSE 0
        END
    ) AS on_time_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date <= promised_delivery_date THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS carrier_on_time_pct

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL

GROUP BY carrier_id

ORDER BY carrier_on_time_pct DESC;


/*==============================================================================
  KPI 10.10.5 — AVERAGE TRANSPORT LEAD TIME
==============================================================================*/

SELECT
    carrier_id,

    AVG(
        DATEDIFF(
            DAY,
            shipment_date,
            actual_delivery_date
        ) * 1.0
    ) AS avg_transport_days

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL

GROUP BY carrier_id

ORDER BY avg_transport_days DESC;


/*==============================================================================
  KPI 10.10.6 — LATE SHIPMENT RATE
==============================================================================*/

SELECT
    COUNT(*) AS completed_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date THEN 1
            ELSE 0
        END
    ) AS late_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS late_shipment_pct

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL;


/*##############################################################################
  10.11 RETURNS KPIs
##############################################################################*/


/*==============================================================================
  KPI 10.11.1 — TOTAL RETURN QUANTITY
==============================================================================*/

SELECT
    SUM(return_quantity) AS total_returned_qty
FROM dbo.returns;


/*==============================================================================
  KPI 10.11.2 — RETURN RATE

  Numerator:
      returned quantity

  Denominator:
      shipped quantity
==============================================================================*/

WITH Shipped AS
(
    SELECT
        product_id,
        SUM(shipped_quantity) AS shipped_qty

    FROM dbo.shipment_lines

    GROUP BY product_id
),

Returned AS
(
    SELECT
        product_id,
        SUM(return_quantity) AS returned_qty

    FROM dbo.returns

    GROUP BY product_id
)

SELECT
    SUM(
        CASE
            WHEN r.returned_qty IS NULL THEN 0
            ELSE r.returned_qty
        END
    ) AS returned_qty,

    SUM(s.shipped_qty) AS shipped_qty,

    CASE
        WHEN SUM(s.shipped_qty) > 0

        THEN
            SUM(
                CASE
                    WHEN r.returned_qty IS NULL THEN 0
                    ELSE r.returned_qty
                END
            ) * 100.0
            / SUM(s.shipped_qty)

        ELSE NULL
    END AS overall_return_rate_pct

FROM Shipped s
LEFT JOIN Returned r
    ON s.product_id = r.product_id;


/*==============================================================================
  KPI 10.11.3 — RETURN RATE BY PRODUCT
==============================================================================*/

WITH Shipped AS
(
    SELECT
        product_id,
        SUM(shipped_quantity) AS shipped_qty
    FROM dbo.shipment_lines
    GROUP BY product_id
),

Returned AS
(
    SELECT
        product_id,
        SUM(return_quantity) AS returned_qty
    FROM dbo.returns
    GROUP BY product_id
)

SELECT
    s.product_id,
    s.shipped_qty,

    CASE
        WHEN r.returned_qty IS NULL THEN 0
        ELSE r.returned_qty
    END AS returned_qty,

    CASE
        WHEN s.shipped_qty > 0

        THEN
            CASE
                WHEN r.returned_qty IS NULL THEN 0
                ELSE r.returned_qty
            END * 100.0
            / s.shipped_qty

        ELSE NULL
    END AS return_rate_pct

FROM Shipped s
LEFT JOIN Returned r
    ON s.product_id = r.product_id

ORDER BY return_rate_pct DESC;


/*==============================================================================
  KPI 10.11.4 — RETURN VALUE EXPOSURE
==============================================================================*/

SELECT
    SUM(
        r.return_quantity
        * p.standard_cost_aud
    ) AS return_value_proxy_aud

FROM dbo.returns r
JOIN dbo.products p
    ON r.product_id = p.product_id;


/*##############################################################################
  10.12 END-TO-END / RISK KPIs
##############################################################################*/


/*==============================================================================
  KPI 10.12.1 — SLA BREACH RATE
==============================================================================*/

SELECT
    COUNT(*) AS completed_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS sla_breaches,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS sla_breach_pct

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL;


/*==============================================================================
  KPI 10.12.2 — SINGLE-SOURCE STOCKOUT EXPOSURE

  Products that:
      have experienced stockouts
      AND have only one supplier
==============================================================================*/

WITH Stockout AS
(
    SELECT DISTINCT
        product_id

    FROM dbo.inventory_snapshots

    WHERE quantity_on_hand <= 0
),

SupplierCount AS
(
    SELECT
        product_id,
        COUNT(DISTINCT supplier_id) AS supplier_count

    FROM dbo.supplier_products

    GROUP BY product_id
)

SELECT
    COUNT(*) AS single_source_stockout_products

FROM Stockout s
JOIN SupplierCount sc
    ON s.product_id = sc.product_id

WHERE sc.supplier_count = 1;


/*==============================================================================
  KPI 10.12.3 — TOTAL OPERATIONAL EXCEPTION COUNT

  NOTE:
  These counts are not aggregated into a single KPI because they
  represent different processes.

  Display them side-by-side instead.
==============================================================================*/

SELECT
    'Stockout Snapshots' AS exception_type,
    COUNT(*) AS exception_count
FROM dbo.inventory_snapshots
WHERE quantity_on_hand <= 0

UNION ALL

SELECT
    'Late Shipments',
    COUNT(*)
FROM dbo.shipments
WHERE actual_delivery_date > promised_delivery_date

UNION ALL

SELECT
    'Quality Failures',
    COUNT(*)
FROM dbo.quality_inspections
WHERE inspection_result = 'Fail'

UNION ALL

SELECT
    'Returns',
    COUNT(*)
FROM dbo.returns

UNION ALL

SELECT
    'Downtime Events',
    COUNT(*)
FROM dbo.downtime_events;


/*##############################################################################
  10.13 KPI VALIDATION
##############################################################################*/


/*==============================================================================
  10.13.1 CHECK DENOMINATORS BEFORE PERCENTAGES
==============================================================================*/

SELECT
    COUNT(*) AS inventory_rows
FROM dbo.inventory_snapshots;

SELECT
    COUNT(*) AS shipment_rows
FROM dbo.shipments;

SELECT
    COUNT(*) AS inspection_rows
FROM dbo.quality_inspections;

SELECT
    COUNT(*) AS return_rows
FROM dbo.returns;


/*==============================================================================
  10.13.2 SHIPMENT FREIGHT VALIDATION

  Correct:
      one freight amount per shipment

  Do not aggregate shipment-header freight after joining to multiple shipment lines
  and then SUM freight.
==============================================================================*/

SELECT
    COUNT(*) AS shipment_count,
    SUM(freight_cost) AS freight_cost
FROM dbo.shipments;


/*==============================================================================
  10.13.3 CHECK SHIPMENT HEADER ↔ LINE MULTIPLICATION
==============================================================================*/

SELECT
    COUNT(*) AS joined_rows,
    COUNT(DISTINCT s.shipment_id) AS distinct_shipments

FROM dbo.shipments s
JOIN dbo.shipment_lines sl
    ON s.shipment_id = sl.shipment_id;


/*
  If joined_rows > distinct_shipments:

      THAT IS NORMAL FOR A 1:MANY JOIN.

  But:

      SUM(s.freight_cost)

  after this join would repeat shipment freight.

  Therefore freight KPIs remain at shipment grain.
*/


/*==============================================================================
  10.13.4 FORECAST VERSION CHECK
==============================================================================*/

SELECT
    forecast_version,
    COUNT(*) AS forecast_rows
FROM dbo.demand_forecast
GROUP BY forecast_version
ORDER BY forecast_version;


/*
  Do not combine different forecast versions into a single forecast KPI
  unless the business definition specifically requires it.
*/


/*==============================================================================
  10.13.5 CURRENCY CHECK
==============================================================================*/

SELECT
    currency_code,
    COUNT(*) AS purchase_orders
FROM dbo.purchase_orders
GROUP BY currency_code;


/*
  CONTROL REQUIREMENTS:

      SUM(AUD + USD + EUR + ...)

  Convert currencies first or report each currency separately.
*/


/*==============================================================================
  10.13.6 NULL DELIVERY CHECK

  NULL actual delivery may mean:
      shipment still incomplete

  This condition does not inherently indicate a data-quality issue.
==============================================================================*/

SELECT
    COUNT(*) AS shipments_without_actual_delivery
FROM dbo.shipments
WHERE actual_delivery_date IS NULL;


/*==============================================================================
  10.13.7 SIGNED STOCK MOVEMENT CHECK
==============================================================================*/

SELECT
    CASE
        WHEN quantity < 0 THEN 'Outbound'
        WHEN quantity > 0 THEN 'Inbound'
        ELSE 'Zero'
    END AS movement_direction,

    COUNT(*) AS movement_records,
    SUM(quantity) AS signed_quantity

FROM dbo.stock_movements

GROUP BY
    CASE
        WHEN quantity < 0 THEN 'Outbound'
        WHEN quantity > 0 THEN 'Inbound'
        ELSE 'Zero'
    END;


/*##############################################################################
  CHAPTER 10 — KPI COVERAGE AUDIT
##############################################################################*/

/*

  INVENTORY KPIs
  [X] average inventory
  [X] inventory value
  [X] turnover
  [X] days inventory
  [X] stockout rate
  [X] reorder-point breach
  [X] safety-stock breach

  DEMAND / FORECAST KPIs
  [X] average demand
  [X] demand variability
  [X] forecast error
  [X] absolute forecast error %

  PROCUREMENT KPIs
  [X] spend
  [X] contract compliance %
  [X] maverick spend %
  [X] price spread
  [X] PPV

  SUPPLIER KPIs
  [X] lead time
  [X] on-time %
  [X] OTIF
  [X] rejection rate
  [X] concentration
  [X] single-source exposure

  PO KPIs
  [X] open PO count
  [X] late receipt rate
  [X] partial receipt rate
  [X] PO cycle time

  CUSTOMER / FULFILMENT KPIs
  [X] fill rate
  [X] backorder rate
  [X] on-time delivery
  [X] late delivery
  [X] average days late
  [X] perfect-order rate
  [X] order cycle time

  WAREHOUSE KPIs
  [X] throughput
  [X] productivity
  [X] error rate
  [X] capacity utilisation

  PRODUCTION KPIs
  [X] throughput
  [X] yield
  [X] scrap rate
  [X] schedule adherence
  [X] cycle time
  [X] downtime
  [X] scrap value

  QUALITY KPIs
  [X] defect rate
  [X] product defect rate
  [X] inspection failure rate
  [X] source defect rate

  LOGISTICS KPIs
  [X] freight cost
  [X] average freight
  [X] carrier freight
  [X] carrier on-time %
  [X] transportation lead time
  [X] late shipment %

  RETURNS KPIs
  [X] return quantity
  [X] return rate
  [X] product return rate
  [X] return-value exposure

  END-TO-END RISK KPIs
  [X] SLA breach %
  [X] single-source + stockout exposure
  [X] operational exception visibility

  KPI VALIDATION
  [X] denominator checks
  [X] shipment freight grain
  [X] join multiplication
  [X] forecast versions
  [X] currencies
  [X] legitimate NULL delivery
  [X] signed stock movement


  IMPLEMENTATION PROFILE:
      STANDARD ANALYTICAL SQL

  MAIN SQL:
      SELECT
      WHERE
      GROUP BY
      HAVING
      CASE
      DATE FUNCTIONS
      JOIN
      UNION ALL
      SUBQUERIES
      CTE
      WINDOW FUNCTION

  CHAPTER 10 STATUS:
      COMPLETE — INTEGRATED KPI VERSION

  NEXT:
      CHAPTER 11 — ROOT CAUSE ANALYSIS
*/

/*==============================================================================
  SOUTHERN CROSS INDUSTRIAL SUPPLY
  CHAPTER 11 — ROOT-CAUSE ANALYSIS
  INTEGRATED ANALYSIS

  PURPOSE:
      Chapter 9  = Current-state assessment
      Chapter 10 = Materiality and performance assessment
      Chapter 11 = Root-cause assessment

  ROOT-CAUSE LOGIC:

      PROBLEM
         ↓
      DRIVER
         ↓
      ROOT CAUSE
         ↓
      BUSINESS CONSEQUENCE

  IMPORTANT:
      Correlation / overlap does not automatically prove causation.

      Required analytical controls:
          1. find poor KPI
          2. segment it
          3. compare control and exception groups
          4. drill into drivers
          5. test timing + relationships
          6. only then describe supported root cause

  CORE SQL TECHNIQUES:
      core analytical SQL patterns

  IMPLEMENTATION PROFILE:
      STANDARD ANALYTICAL SQL
==============================================================================*/

USE SCIS;
GO


/*##############################################################################
  11.1 — IDENTIFY POOR-PERFORMING AREAS
##############################################################################*/


/*==============================================================================
  11.1.1 STOCKOUT HOTSPOTS
==============================================================================*/

SELECT
    product_id,
    warehouse_id,
    COUNT(*) AS stockout_events

FROM dbo.inventory_snapshots

WHERE quantity_on_hand <= 0

GROUP BY
    product_id,
    warehouse_id

ORDER BY stockout_events DESC;


/*==============================================================================
  11.1.2 WORST FORECAST ERROR PRODUCTS
==============================================================================*/

WITH Actual AS
(
    SELECT
        product_id,
        SUM(quantity) AS actual_qty

    FROM dbo.customer_order_lines

    GROUP BY product_id
),

Forecast AS
(
    SELECT
        product_id,
        forecast_version,
        SUM(forecast_quantity) AS forecast_qty

    FROM dbo.demand_forecast

    GROUP BY
        product_id,
        forecast_version
)

SELECT
    f.product_id,
    f.forecast_version,
    f.forecast_qty,
    a.actual_qty,

    CASE
        WHEN a.actual_qty - f.forecast_qty < 0
            THEN (a.actual_qty - f.forecast_qty) * -1
        ELSE a.actual_qty - f.forecast_qty
    END AS absolute_error

FROM Forecast f
JOIN Actual a
    ON f.product_id = a.product_id

ORDER BY absolute_error DESC;


/*==============================================================================
  11.1.3 LOWEST SUPPLIER OTIF
==============================================================================*/

SELECT
    po.supplier_id,

    SUM(
        CASE
            WHEN gr.receipt_date <= po.expected_delivery_date
             AND gr.received_quantity >= gr.ordered_quantity
            THEN 1 ELSE 0
        END
    ) * 100.0 / COUNT(*) AS supplier_otif_pct

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY supplier_otif_pct;


/*==============================================================================
  11.1.4 LOWEST CUSTOMER FILL RATE
==============================================================================*/

WITH Ordered AS
(
    SELECT
        customer_order_id,
        SUM(quantity) AS ordered_qty
    FROM dbo.customer_order_lines
    GROUP BY customer_order_id
),

Shipped AS
(
    SELECT
        customer_order_id,
        SUM(shipped_quantity) AS shipped_qty
    FROM dbo.shipment_lines
    GROUP BY customer_order_id
)

SELECT
    o.customer_order_id,
    o.ordered_qty,

    CASE
        WHEN s.shipped_qty IS NULL THEN 0
        ELSE s.shipped_qty
    END AS shipped_qty,

    CASE
        WHEN o.ordered_qty > 0
        THEN
            CASE
                WHEN s.shipped_qty IS NULL THEN 0
                ELSE s.shipped_qty
            END * 100.0 / o.ordered_qty
    END AS fill_rate_pct

FROM Ordered o
LEFT JOIN Shipped s
    ON o.customer_order_id = s.customer_order_id

ORDER BY fill_rate_pct;


/*==============================================================================
  11.1.5 LOWEST PRODUCTION YIELD
==============================================================================*/

SELECT
    product_id,

    CASE
        WHEN SUM(actual_good_quantity + scrap_quantity) > 0
        THEN
            SUM(actual_good_quantity) * 100.0
            / SUM(actual_good_quantity + scrap_quantity)
        ELSE NULL
    END AS yield_pct

FROM dbo.production_orders

GROUP BY product_id

ORDER BY yield_pct;


/*==============================================================================
  11.1.6 HIGHEST RETURN RATE
==============================================================================*/

WITH Shipped AS
(
    SELECT
        product_id,
        SUM(shipped_quantity) AS shipped_qty

    FROM dbo.shipment_lines

    GROUP BY product_id
),

Returned AS
(
    SELECT
        product_id,
        SUM(return_quantity) AS returned_qty

    FROM dbo.returns

    GROUP BY product_id
)

SELECT
    s.product_id,

    CASE
        WHEN s.shipped_qty > 0
        THEN
            CASE
                WHEN r.returned_qty IS NULL THEN 0
                ELSE r.returned_qty
            END * 100.0 / s.shipped_qty
        ELSE NULL
    END AS return_rate_pct

FROM Shipped s
LEFT JOIN Returned r
    ON s.product_id = r.product_id

ORDER BY return_rate_pct DESC;


/*##############################################################################
  11.2 — STOCKOUT ROOT-CAUSE ANALYSIS
##############################################################################*/


/*==============================================================================
  11.2.1 STOCKOUT + DEMAND

  Analytical objective:
      Assess whether stockouts are concentrated among high-demand products.
==============================================================================*/

WITH Stockouts AS
(
    SELECT
        product_id,
        COUNT(*) AS stockout_events

    FROM dbo.inventory_snapshots

    WHERE quantity_on_hand <= 0

    GROUP BY product_id
),

Demand AS
(
    SELECT
        product_id,
        SUM(quantity) AS demand_qty

    FROM dbo.customer_order_lines

    GROUP BY product_id
)

SELECT
    s.product_id,
    s.stockout_events,
    d.demand_qty

FROM Stockouts s
LEFT JOIN Demand d
    ON s.product_id = d.product_id

ORDER BY s.stockout_events DESC;


/*==============================================================================
  11.2.2 STOCKOUT + FORECAST ERROR

  Possible driver:
      demand consistently exceeds forecast.
==============================================================================*/

WITH Stockouts AS
(
    SELECT
        product_id,
        COUNT(*) AS stockout_events

    FROM dbo.inventory_snapshots

    WHERE quantity_on_hand <= 0

    GROUP BY product_id
),

Actual AS
(
    SELECT
        product_id,
        SUM(quantity) AS actual_qty

    FROM dbo.customer_order_lines

    GROUP BY product_id
),

Forecast AS
(
    SELECT
        product_id,
        SUM(forecast_quantity) AS forecast_qty

    FROM dbo.demand_forecast

    GROUP BY product_id
)

SELECT
    s.product_id,
    s.stockout_events,
    a.actual_qty,
    f.forecast_qty,
    a.actual_qty - f.forecast_qty AS forecast_gap

FROM Stockouts s
LEFT JOIN Actual a
    ON s.product_id = a.product_id
LEFT JOIN Forecast f
    ON s.product_id = f.product_id

ORDER BY s.stockout_events DESC;


/*==============================================================================
  11.2.3 STOCKOUT + SUPPLIER COUNT

  Possible driver:
      supply concentration / single sourcing.
==============================================================================*/

WITH Stockouts AS
(
    SELECT
        product_id,
        COUNT(*) AS stockout_events

    FROM dbo.inventory_snapshots

    WHERE quantity_on_hand <= 0

    GROUP BY product_id
),

SupplierCount AS
(
    SELECT
        product_id,
        COUNT(DISTINCT supplier_id) AS supplier_count

    FROM dbo.supplier_products

    GROUP BY product_id
)

SELECT
    s.product_id,
    s.stockout_events,
    sc.supplier_count,

    CASE
        WHEN sc.supplier_count = 1
            THEN 'Single Source'
        ELSE 'Multiple Sources'
    END AS sourcing_status

FROM Stockouts s
JOIN SupplierCount sc
    ON s.product_id = sc.product_id

ORDER BY s.stockout_events DESC;


/*==============================================================================
  11.2.4 STOCKOUT + SUPPLIER DELAYS

  Test:
      Assess whether stockout products are associated with late supplier receipts.
==============================================================================*/

SELECT
    pol.product_id,

    COUNT(*) AS receipt_records,

    SUM(
        CASE
            WHEN gr.receipt_date > po.expected_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_receipts

FROM dbo.purchase_order_lines pol
JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

WHERE pol.product_id IN
(
    SELECT DISTINCT product_id
    FROM dbo.inventory_snapshots
    WHERE quantity_on_hand <= 0
)

GROUP BY pol.product_id

ORDER BY late_receipts DESC;


/*==============================================================================
  INTERPRETATION

  If a stockout product also has:
      high demand
      + under-forecasting
      + one supplier
      + late receipts

  This combination provides stronger evidence of a supply-planning issue.

  Stockout alone is only the symptom.
==============================================================================*/


/*##############################################################################
  11.3 — INVENTORY / OVERSTOCK ROOT CAUSE
##############################################################################*/


/*==============================================================================
  11.3.1 HIGH INVENTORY + LOW MOVEMENT
==============================================================================*/

WITH Inventory AS
(
    SELECT
        product_id,
        AVG(quantity_on_hand * 1.0) AS avg_inventory

    FROM dbo.inventory_snapshots

    GROUP BY product_id
),

Usage AS
(
    SELECT
        product_id,

        SUM(
            CASE
                WHEN quantity < 0 THEN quantity * -1
                ELSE 0
            END
        ) AS outbound_qty

    FROM dbo.stock_movements

    GROUP BY product_id
)

SELECT
    i.product_id,
    i.avg_inventory,
    u.outbound_qty

FROM Inventory i
LEFT JOIN Usage u
    ON i.product_id = u.product_id

ORDER BY
    i.avg_inventory DESC,
    u.outbound_qty;


/*==============================================================================
  11.3.2 HIGH INVENTORY + OVER-FORECASTING
==============================================================================*/

WITH Inventory AS
(
    SELECT
        product_id,
        AVG(quantity_on_hand * 1.0) AS avg_inventory

    FROM dbo.inventory_snapshots

    GROUP BY product_id
),

Actual AS
(
    SELECT
        product_id,
        SUM(quantity) AS actual_qty

    FROM dbo.customer_order_lines

    GROUP BY product_id
),

Forecast AS
(
    SELECT
        product_id,
        SUM(forecast_quantity) AS forecast_qty

    FROM dbo.demand_forecast

    GROUP BY product_id
)

SELECT
    i.product_id,
    i.avg_inventory,
    f.forecast_qty,
    a.actual_qty,

    f.forecast_qty - a.actual_qty AS overforecast_qty

FROM Inventory i
JOIN Forecast f
    ON i.product_id = f.product_id
JOIN Actual a
    ON i.product_id = a.product_id

WHERE f.forecast_qty > a.actual_qty

ORDER BY
    i.avg_inventory DESC,
    overforecast_qty DESC;


/*==============================================================================
  POSSIBLE ROOT-CAUSE CHAIN

      Over-forecast
          ↓
      Excess procurement / production
          ↓
      High inventory
          ↓
      Slow-moving / dead inventory
          ↓
      Working-capital pressure
==============================================================================*/


/*##############################################################################
  11.4 — FORECAST ROOT-CAUSE ANALYSIS
##############################################################################*/


/*==============================================================================
  11.4.1 FORECAST ERROR BY VERSION
==============================================================================*/

WITH Actual AS
(
    SELECT
        product_id,
        SUM(quantity) AS actual_qty

    FROM dbo.customer_order_lines

    GROUP BY product_id
),

Forecast AS
(
    SELECT
        product_id,
        forecast_version,
        SUM(forecast_quantity) AS forecast_qty

    FROM dbo.demand_forecast

    GROUP BY
        product_id,
        forecast_version
)

SELECT
    f.forecast_version,

    AVG(
        CASE
            WHEN a.actual_qty - f.forecast_qty < 0
                THEN (a.actual_qty - f.forecast_qty) * -1
            ELSE a.actual_qty - f.forecast_qty
        END * 1.0
    ) AS avg_absolute_error

FROM Forecast f
JOIN Actual a
    ON f.product_id = a.product_id

GROUP BY f.forecast_version

ORDER BY avg_absolute_error;


/*==============================================================================
  11.4.2 UNDER-FORECAST VS OVER-FORECAST COUNTS
==============================================================================*/

WITH Actual AS
(
    SELECT product_id, SUM(quantity) AS actual_qty
    FROM dbo.customer_order_lines
    GROUP BY product_id
),

Forecast AS
(
    SELECT product_id, SUM(forecast_quantity) AS forecast_qty
    FROM dbo.demand_forecast
    GROUP BY product_id
)

SELECT
    CASE
        WHEN a.actual_qty > f.forecast_qty
            THEN 'Under-Forecast'

        WHEN a.actual_qty < f.forecast_qty
            THEN 'Over-Forecast'

        ELSE 'Matched'
    END AS forecast_direction,

    COUNT(*) AS products

FROM Actual a
JOIN Forecast f
    ON a.product_id = f.product_id

GROUP BY
    CASE
        WHEN a.actual_qty > f.forecast_qty
            THEN 'Under-Forecast'

        WHEN a.actual_qty < f.forecast_qty
            THEN 'Over-Forecast'

        ELSE 'Matched'
    END;


/*##############################################################################
  11.5 — PROCUREMENT / PPV ROOT CAUSE
##############################################################################*/


/*==============================================================================
  11.5.1 PPV BY SUPPLIER
==============================================================================*/

SELECT
    po.supplier_id,

    AVG(
        pol.unit_price - sp.contract_unit_price
    ) AS avg_ppv,

    SUM(
        (pol.unit_price - sp.contract_unit_price)
        * pol.ordered_quantity
    ) AS total_ppv

FROM dbo.purchase_order_lines pol
JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id
JOIN dbo.supplier_products sp
    ON po.supplier_id = sp.supplier_id
   AND pol.product_id = sp.product_id

GROUP BY po.supplier_id

ORDER BY total_ppv DESC;


/*==============================================================================
  11.5.2 PPV + CONTRACT COMPLIANCE

  Analytical objective:
      Assess the relationship between unfavourable PPV and non-compliant purchasing.
==============================================================================*/

SELECT
    pol.contract_compliant_flag,

    AVG(
        pol.unit_price - sp.contract_unit_price
    ) AS avg_ppv

FROM dbo.purchase_order_lines pol
JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id
JOIN dbo.supplier_products sp
    ON po.supplier_id = sp.supplier_id
   AND pol.product_id = sp.product_id

GROUP BY pol.contract_compliant_flag;


/*==============================================================================
  11.5.3 PRICE VARIATION BY SUPPLIER
==============================================================================*/

SELECT
    po.supplier_id,
    pol.product_id,

    MIN(pol.unit_price) AS min_price,
    MAX(pol.unit_price) AS max_price,

    MAX(pol.unit_price)
    - MIN(pol.unit_price) AS price_spread

FROM dbo.purchase_order_lines pol
JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id

GROUP BY
    po.supplier_id,
    pol.product_id

ORDER BY price_spread DESC;


/*==============================================================================
  POSSIBLE ROOT-CAUSE CHAIN

      Contract non-compliance
             ↓
      purchase outside preferred pricing
             ↓
      higher unit price / PPV
             ↓
      procurement cost pressure
==============================================================================*/


/*##############################################################################
  11.6 — SUPPLIER ROOT-CAUSE ANALYSIS
##############################################################################*/


/*==============================================================================
  11.6.1 COMPARE ON-TIME VS LATE SUPPLIERS
==============================================================================*/

SELECT
    po.supplier_id,

    SUM(
        CASE
            WHEN gr.receipt_date <= po.expected_delivery_date
            THEN 1 ELSE 0
        END
    ) AS on_time_receipts,

    SUM(
        CASE
            WHEN gr.receipt_date > po.expected_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_receipts

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY late_receipts DESC;


/*==============================================================================
  11.6.2 SUPPLIER DELAY + REJECTION

  Analytical objective:
      Assess whether lower delivery performance coincides with lower supplier quality performance.
==============================================================================*/

SELECT
    po.supplier_id,

    SUM(
        CASE
            WHEN gr.receipt_date > po.expected_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_receipts,

    SUM(gr.rejected_quantity) AS rejected_qty

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY
    late_receipts DESC,
    rejected_qty DESC;


/*==============================================================================
  11.6.3 SUPPLIER DEPENDENCY + LOW OTIF
==============================================================================*/

WITH SupplierCount AS
(
    SELECT
        product_id,
        COUNT(DISTINCT supplier_id) AS supplier_count

    FROM dbo.supplier_products

    GROUP BY product_id
)

SELECT
    sp.product_id,
    sc.supplier_count,
    sp.supplier_id

FROM dbo.supplier_products sp
JOIN SupplierCount sc
    ON sp.product_id = sc.product_id

WHERE sc.supplier_count = 1

ORDER BY sp.product_id;


/*##############################################################################
  11.7 — PURCHASE ORDER ROOT CAUSE
##############################################################################*/


/*==============================================================================
  11.7.1 PARTIAL RECEIPT BY SUPPLIER
==============================================================================*/

SELECT
    po.supplier_id,

    COUNT(*) AS receipt_records,

    SUM(
        CASE
            WHEN gr.received_quantity < gr.ordered_quantity
            THEN 1 ELSE 0
        END
    ) AS partial_receipts

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY partial_receipts DESC;


/*==============================================================================
  11.7.2 LATE + PARTIAL RECEIPT COMBINATION
==============================================================================*/

SELECT
    po.supplier_id,

    SUM(
        CASE
            WHEN gr.receipt_date > po.expected_delivery_date
             AND gr.received_quantity < gr.ordered_quantity
            THEN 1
            ELSE 0
        END
    ) AS late_and_partial_receipts

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY late_and_partial_receipts DESC;


/*##############################################################################
  11.8 — CUSTOMER FULFILMENT ROOT CAUSE
##############################################################################*/


/*==============================================================================
  11.8.1 LOW FILL RATE + STOCKOUT
==============================================================================*/

WITH ProductOrders AS
(
    SELECT
        product_id,
        SUM(quantity) AS ordered_qty

    FROM dbo.customer_order_lines

    GROUP BY product_id
),

ProductShipped AS
(
    SELECT
        product_id,
        SUM(shipped_quantity) AS shipped_qty

    FROM dbo.shipment_lines

    GROUP BY product_id
),

Stockouts AS
(
    SELECT
        product_id,
        COUNT(*) AS stockout_events

    FROM dbo.inventory_snapshots

    WHERE quantity_on_hand <= 0

    GROUP BY product_id
)

SELECT
    o.product_id,
    o.ordered_qty,

    CASE
        WHEN s.shipped_qty IS NULL THEN 0
        ELSE s.shipped_qty
    END AS shipped_qty,

    CASE
        WHEN o.ordered_qty > 0
        THEN
            CASE
                WHEN s.shipped_qty IS NULL THEN 0
                ELSE s.shipped_qty
            END * 100.0 / o.ordered_qty
    END AS fill_rate_pct,

    CASE
        WHEN st.stockout_events IS NULL THEN 0
        ELSE st.stockout_events
    END AS stockout_events

FROM ProductOrders o
LEFT JOIN ProductShipped s
    ON o.product_id = s.product_id
LEFT JOIN Stockouts st
    ON o.product_id = st.product_id

ORDER BY fill_rate_pct;


/*==============================================================================
  11.8.2 LATE DELIVERY BY WAREHOUSE
==============================================================================*/

SELECT
    warehouse_id,

    COUNT(*) AS delivered_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1 ELSE 0
        END
    ) * 100.0 / COUNT(*) AS late_delivery_pct

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL

GROUP BY warehouse_id

ORDER BY late_delivery_pct DESC;


/*==============================================================================
  11.8.3 LATE DELIVERY BY CARRIER
==============================================================================*/

SELECT
    carrier_id,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1 ELSE 0
        END
    ) * 100.0 / COUNT(*) AS late_delivery_pct

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL

GROUP BY carrier_id

ORDER BY late_delivery_pct DESC;


/*==============================================================================
  INTERPRETATION

  If lateness follows WAREHOUSE:
      warehouse/process issue becomes stronger candidate.

  If lateness follows CARRIER:
      transport/carrier issue becomes stronger candidate.

  If both:
      Assess both dimensions; do not impose a single-cause explanation.
==============================================================================*/


/*##############################################################################
  11.9 — WAREHOUSE ROOT-CAUSE ANALYSIS
##############################################################################*/


/*==============================================================================
  11.9.1 PRODUCTIVITY VS PICK ERRORS
==============================================================================*/

SELECT
    warehouse_id,

    CASE
        WHEN SUM(labour_hours) > 0
        THEN SUM(lines_picked) * 1.0
             / SUM(labour_hours)
    END AS lines_per_labour_hour,

    CASE
        WHEN SUM(lines_picked) > 0
        THEN SUM(pick_errors) * 100.0
             / SUM(lines_picked)
    END AS pick_error_pct

FROM dbo.warehouse_operations

GROUP BY warehouse_id

ORDER BY lines_per_labour_hour;


/*==============================================================================
  11.9.2 CAPACITY UTILISATION VS LATE SHIPMENTS
==============================================================================*/

WITH Capacity AS
(
    SELECT
        wo.warehouse_id,

        SUM(wo.units_processed) * 100.0
        / w.daily_capacity AS capacity_utilisation_pct

    FROM dbo.warehouse_operations wo
    JOIN dbo.warehouses w
        ON wo.warehouse_id = w.warehouse_id

    GROUP BY
        wo.warehouse_id,
        w.daily_capacity
),

Late AS
(
    SELECT
        warehouse_id,

        SUM(
            CASE
                WHEN actual_delivery_date > promised_delivery_date
                THEN 1 ELSE 0
            END
        ) AS late_shipments

    FROM dbo.shipments

    GROUP BY warehouse_id
)

SELECT
    c.warehouse_id,
    c.capacity_utilisation_pct,
    l.late_shipments

FROM Capacity c
LEFT JOIN Late l
    ON c.warehouse_id = l.warehouse_id

ORDER BY capacity_utilisation_pct DESC;


/*==============================================================================
  POSSIBLE ROOT-CAUSE TEST

      high utilisation
          +
      falling productivity
          +
      higher errors / lateness

  = evidence consistent with warehouse capacity / process pressure.

  Not proven from utilisation alone.
==============================================================================*/


/*##############################################################################
  11.10 — PRODUCTION ROOT-CAUSE ANALYSIS
##############################################################################*/


/*==============================================================================
  11.10.1 LOW YIELD + DOWNTIME
==============================================================================*/

WITH Yield AS
(
    SELECT
        product_id,

        CASE
            WHEN SUM(actual_good_quantity + scrap_quantity) > 0
            THEN
                SUM(actual_good_quantity) * 100.0
                / SUM(actual_good_quantity + scrap_quantity)
        END AS yield_pct

    FROM dbo.production_orders

    GROUP BY product_id
),

Downtime AS
(
    SELECT
        po.product_id,
        SUM(d.duration_minutes) AS downtime_minutes

    FROM dbo.production_orders po
    JOIN dbo.downtime_events d
        ON po.production_order_id = d.production_order_id

    GROUP BY po.product_id
)

SELECT
    y.product_id,
    y.yield_pct,

    CASE
        WHEN d.downtime_minutes IS NULL THEN 0
        ELSE d.downtime_minutes
    END AS downtime_minutes

FROM Yield y
LEFT JOIN Downtime d
    ON y.product_id = d.product_id

ORDER BY yield_pct;


/*==============================================================================
  11.10.2 SCRAP BY DOWNTIME REASON
==============================================================================*/

SELECT
    d.downtime_reason,
    SUM(po.scrap_quantity) AS scrap_qty,
    SUM(d.duration_minutes) AS downtime_minutes

FROM dbo.downtime_events d
JOIN dbo.production_orders po
    ON d.production_order_id = po.production_order_id

GROUP BY d.downtime_reason

ORDER BY scrap_qty DESC;


/*==============================================================================
  11.10.3 LATE PRODUCTION START + MATERIAL SHORTAGE

  BOM and inventory data are used to determine whether late orders also face
  component shortages.
==============================================================================*/

WITH Required AS
(
    SELECT
        po.production_order_id,
        po.product_id,
        po.warehouse_id,

        b.component_product_id,

        po.planned_quantity
            * b.quantity_per_parent AS required_qty,

        po.planned_start_date,
        po.actual_start_date

    FROM dbo.production_orders po
    JOIN dbo.bom b
        ON po.product_id = b.parent_product_id
),

Available AS
(
    SELECT
        warehouse_id,
        product_id,
        AVG(quantity_on_hand * 1.0) AS available_qty

    FROM dbo.inventory_snapshots

    GROUP BY
        warehouse_id,
        product_id
)

SELECT
    r.production_order_id,
    r.component_product_id,
    r.required_qty,
    a.available_qty,

    CASE
        WHEN r.actual_start_date > r.planned_start_date
            THEN 'Late Start'
        ELSE 'On Time'
    END AS start_status,

    CASE
        WHEN a.available_qty IS NULL
          OR a.available_qty < r.required_qty
            THEN 'Material Shortage'
        ELSE 'Material Available'
    END AS material_status

FROM Required r
LEFT JOIN Available a
    ON r.warehouse_id = a.warehouse_id
   AND r.component_product_id = a.product_id

ORDER BY r.production_order_id;


/*##############################################################################
  11.11 — QUALITY ROOT-CAUSE ANALYSIS
##############################################################################*/


/*==============================================================================
  11.11.1 DEFECTS BY SOURCE
==============================================================================*/

SELECT
    source_type,

    SUM(inspected_quantity) AS inspected_qty,
    SUM(defect_quantity) AS defect_qty,

    CASE
        WHEN SUM(inspected_quantity) > 0
        THEN SUM(defect_quantity) * 100.0
             / SUM(inspected_quantity)
    END AS defect_rate_pct

FROM dbo.quality_inspections

GROUP BY source_type

ORDER BY defect_rate_pct DESC;


/*==============================================================================
  11.11.2 DEFECT TYPE BY PRODUCT
==============================================================================*/

SELECT
    product_id,
    defect_type,
    SUM(defect_quantity) AS defect_qty

FROM dbo.quality_inspections

WHERE defect_type IS NOT NULL

GROUP BY
    product_id,
    defect_type

ORDER BY defect_qty DESC;


/*==============================================================================
  11.11.3 QUALITY + RETURNS

  Analytical objective:
      Assess whether high-defect products also exhibit elevated return volumes.
==============================================================================*/

WITH Defects AS
(
    SELECT
        product_id,

        CASE
            WHEN SUM(inspected_quantity) > 0
            THEN SUM(defect_quantity) * 100.0
                 / SUM(inspected_quantity)
        END AS defect_rate_pct

    FROM dbo.quality_inspections

    GROUP BY product_id
),

Returns AS
(
    SELECT
        product_id,
        SUM(return_quantity) AS returned_qty

    FROM dbo.returns

    GROUP BY product_id
)

SELECT
    d.product_id,
    d.defect_rate_pct,

    CASE
        WHEN r.returned_qty IS NULL THEN 0
        ELSE r.returned_qty
    END AS returned_qty

FROM Defects d
LEFT JOIN Returns r
    ON d.product_id = r.product_id

ORDER BY
    defect_rate_pct DESC,
    returned_qty DESC;


/*##############################################################################
  11.12 — LOGISTICS ROOT-CAUSE ANALYSIS
##############################################################################*/


/*==============================================================================
  11.12.1 LATE DELIVERY BY CARRIER
==============================================================================*/

SELECT
    carrier_id,

    COUNT(*) AS shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1 ELSE 0
        END
    ) * 100.0 / COUNT(*) AS late_pct

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL

GROUP BY carrier_id

ORDER BY late_pct DESC;


/*==============================================================================
  11.12.2 LATE DELIVERY BY SHIPPING MODE
==============================================================================*/

SELECT
    shipping_mode,

    COUNT(*) AS shipments,

    AVG(
        CASE
            WHEN actual_delivery_date IS NOT NULL
            THEN
                DATEDIFF(
                    DAY,
                    shipment_date,
                    actual_delivery_date
                ) * 1.0
        END
    ) AS avg_transport_days,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1 ELSE 0
        END
    ) AS late_shipments

FROM dbo.shipments

GROUP BY shipping_mode

ORDER BY late_shipments DESC;


/*==============================================================================
  11.12.3 FREIGHT COST VS PERFORMANCE

  Higher freight cost does not imply improved delivery performance.
==============================================================================*/

SELECT
    carrier_id,

    AVG(freight_cost) AS avg_freight,

    AVG(
        CASE
            WHEN actual_delivery_date IS NOT NULL
            THEN
                DATEDIFF(
                    DAY,
                    shipment_date,
                    actual_delivery_date
                ) * 1.0
        END
    ) AS avg_transport_days,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1 ELSE 0
        END
    ) * 100.0
    /
    SUM(
        CASE
            WHEN actual_delivery_date IS NOT NULL THEN 1
            ELSE 0
        END
    ) AS late_pct

FROM dbo.shipments

GROUP BY carrier_id

ORDER BY avg_freight DESC;


/*##############################################################################
  11.13 — RETURNS ROOT-CAUSE ANALYSIS
##############################################################################*/


/*==============================================================================
  11.13.1 RETURN REASON BY PRODUCT
==============================================================================*/

SELECT
    product_id,
    return_reason,

    COUNT(*) AS return_events,
    SUM(return_quantity) AS returned_qty

FROM dbo.returns

GROUP BY
    product_id,
    return_reason

ORDER BY returned_qty DESC;


/*==============================================================================
  11.13.2 RETURNS + QUALITY
==============================================================================*/

WITH Quality AS
(
    SELECT
        product_id,

        SUM(defect_quantity) AS defect_qty

    FROM dbo.quality_inspections

    GROUP BY product_id
),

Returns AS
(
    SELECT
        product_id,

        SUM(return_quantity) AS returned_qty

    FROM dbo.returns

    GROUP BY product_id
)

SELECT
    r.product_id,
    r.returned_qty,

    CASE
        WHEN q.defect_qty IS NULL THEN 0
        ELSE q.defect_qty
    END AS defect_qty

FROM Returns r
LEFT JOIN Quality q
    ON r.product_id = q.product_id

ORDER BY r.returned_qty DESC;


/*==============================================================================
  11.13.3 RETURNS + LATE DELIVERY
==============================================================================*/

SELECT
    r.return_reason,

    COUNT(*) AS return_events,

    SUM(
        CASE
            WHEN s.actual_delivery_date > s.promised_delivery_date
            THEN 1 ELSE 0
        END
    ) AS associated_late_shipments

FROM dbo.returns r
LEFT JOIN dbo.shipments s
    ON r.customer_order_id = s.customer_order_id

GROUP BY r.return_reason

ORDER BY return_events DESC;


/*==============================================================================
  IMPORTANT:
  Late delivery and return occurrence may be associated, but this does not establish causation.

  Return reason + timing must support that conclusion.
==============================================================================*/


/*##############################################################################
  11.14 — END-TO-END BOTTLENECK ANALYSIS
##############################################################################*/


/*==============================================================================
  11.14.1 PRODUCT RISK PROFILE

  Bring together:
      stockout
      supplier concentration
      returns
      defects

  Aggregate to the required grain before joining.
==============================================================================*/

WITH Stockout AS
(
    SELECT
        product_id,
        COUNT(*) AS stockout_events

    FROM dbo.inventory_snapshots

    WHERE quantity_on_hand <= 0

    GROUP BY product_id
),

SupplierCount AS
(
    SELECT
        product_id,
        COUNT(DISTINCT supplier_id) AS supplier_count

    FROM dbo.supplier_products

    GROUP BY product_id
),

Quality AS
(
    SELECT
        product_id,
        SUM(defect_quantity) AS defects

    FROM dbo.quality_inspections

    GROUP BY product_id
),

Returns AS
(
    SELECT
        product_id,
        SUM(return_quantity) AS returned_qty

    FROM dbo.returns

    GROUP BY product_id
)

SELECT
    p.product_id,

    CASE
        WHEN s.stockout_events IS NULL THEN 0
        ELSE s.stockout_events
    END AS stockout_events,

    sc.supplier_count,

    CASE
        WHEN q.defects IS NULL THEN 0
        ELSE q.defects
    END AS defect_qty,

    CASE
        WHEN r.returned_qty IS NULL THEN 0
        ELSE r.returned_qty
    END AS returned_qty

FROM dbo.products p

LEFT JOIN Stockout s
    ON p.product_id = s.product_id

LEFT JOIN SupplierCount sc
    ON p.product_id = sc.product_id

LEFT JOIN Quality q
    ON p.product_id = q.product_id

LEFT JOIN Returns r
    ON p.product_id = r.product_id

ORDER BY stockout_events DESC;


/*==============================================================================
  11.14.2 WAREHOUSE RISK PROFILE

  Combine:
      stockouts
      pick errors
      late shipments
==============================================================================*/

WITH Stockout AS
(
    SELECT
        warehouse_id,
        COUNT(*) AS stockout_events

    FROM dbo.inventory_snapshots

    WHERE quantity_on_hand <= 0

    GROUP BY warehouse_id
),

Errors AS
(
    SELECT
        warehouse_id,
        SUM(pick_errors) AS pick_errors

    FROM dbo.warehouse_operations

    GROUP BY warehouse_id
),

Late AS
(
    SELECT
        warehouse_id,

        SUM(
            CASE
                WHEN actual_delivery_date > promised_delivery_date
                THEN 1 ELSE 0
            END
        ) AS late_shipments

    FROM dbo.shipments

    GROUP BY warehouse_id
)

SELECT
    w.warehouse_id,
    w.warehouse_name,

    CASE
        WHEN s.stockout_events IS NULL THEN 0
        ELSE s.stockout_events
    END AS stockout_events,

    CASE
        WHEN e.pick_errors IS NULL THEN 0
        ELSE e.pick_errors
    END AS pick_errors,

    CASE
        WHEN l.late_shipments IS NULL THEN 0
        ELSE l.late_shipments
    END AS late_shipments

FROM dbo.warehouses w

LEFT JOIN Stockout s
    ON w.warehouse_id = s.warehouse_id

LEFT JOIN Errors e
    ON w.warehouse_id = e.warehouse_id

LEFT JOIN Late l
    ON w.warehouse_id = l.warehouse_id

ORDER BY late_shipments DESC;


/*##############################################################################
  11.15 — COMPARATIVE PERFORMANCE ANALYSIS
##############################################################################*/


/*==============================================================================
  11.15.1 SUPPLIER DELIVERY PERFORMANCE GROUP COMPARISON

  Instead of inventing arbitrary performance thresholds:

      On Time
      Late

  Then compare quality.
==============================================================================*/

SELECT
    CASE
        WHEN gr.receipt_date <= po.expected_delivery_date
            THEN 'On-Time Receipt'
        ELSE 'Late Receipt'
    END AS delivery_group,

    AVG(gr.rejected_quantity * 1.0)
        AS avg_rejected_qty

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY
    CASE
        WHEN gr.receipt_date <= po.expected_delivery_date
            THEN 'On-Time Receipt'
        ELSE 'Late Receipt'
    END;


/*==============================================================================
  11.15.2 STOCKOUT PRODUCTS VS NON-STOCKOUT PRODUCTS — DEMAND
==============================================================================*/

WITH StockoutProducts AS
(
    SELECT DISTINCT product_id
    FROM dbo.inventory_snapshots
    WHERE quantity_on_hand <= 0
),

Demand AS
(
    SELECT
        product_id,
        SUM(quantity) AS demand_qty

    FROM dbo.customer_order_lines

    GROUP BY product_id
)

SELECT
    CASE
        WHEN s.product_id IS NOT NULL
            THEN 'Stockout Product'
        ELSE 'No Stockout Recorded'
    END AS inventory_group,

    AVG(d.demand_qty * 1.0) AS avg_product_demand

FROM Demand d
LEFT JOIN StockoutProducts s
    ON d.product_id = s.product_id

GROUP BY
    CASE
        WHEN s.product_id IS NOT NULL
            THEN 'Stockout Product'
        ELSE 'No Stockout Recorded'
    END;


/*##############################################################################
  11.16 — SEPARATE SYMPTOM FROM ROOT CAUSE
##############################################################################*/

/*

  ------------------------------------------------------------
  EXAMPLE 1 — STOCKOUT
  ------------------------------------------------------------

  SYMPTOM:
      Product has zero stock.

  POSSIBLE DRIVERS:
      High demand
      Under-forecasting
      Supplier delay
      Single sourcing
      Production shortage

  ROOT CAUSE:
      Only use after evidence supports one or more drivers.


  ------------------------------------------------------------
  EXAMPLE 2 — LATE CUSTOMER DELIVERY
  ------------------------------------------------------------

  SYMPTOM:
      Shipment arrived late.

  POSSIBLE DRIVERS:
      Stockout
      Warehouse congestion
      carrier delay
      production delay
      material shortage

  ROOT CAUSE:
      Needs timing + relationship evidence.


  ------------------------------------------------------------
  EXAMPLE 3 — HIGH INVENTORY
  ------------------------------------------------------------

  SYMPTOM:
      Inventory is high.

  POSSIBLE DRIVERS:
      Over-forecast
      weak demand
      excess purchasing
      slow movement
      excess production


  ------------------------------------------------------------
  EXAMPLE 4 — HIGH RETURN RATE
  ------------------------------------------------------------

  SYMPTOM:
      Customer returns are high.

  POSSIBLE DRIVERS:
      defects
      picking error
      damage
      late delivery
      customer-specific issue

*/


/*##############################################################################
  11.17 — ROOT-CAUSE CHAINS
##############################################################################*/

/*

  CHAIN A — STOCKOUT / SERVICE FAILURE

      Under-forecast
             ↓
      insufficient replenishment
             ↓
      stockout
             ↓
      backorder / low fill rate
             ↓
      customer service failure


  CHAIN B — SUPPLIER FAILURE

      Poor supplier OTIF
             ↓
      late / partial receipt
             ↓
      material shortage
             ↓
      production delay
             ↓
      customer delivery delay


  CHAIN C — PROCUREMENT COST

      Contract non-compliance
             ↓
      higher purchase price
             ↓
      unfavourable PPV
             ↓
      procurement cost pressure


  CHAIN D — INVENTORY PRESSURE

      Over-forecast
             ↓
      excess purchasing / production
             ↓
      slow-moving inventory
             ↓
      high inventory value
             ↓
      working-capital pressure


  CHAIN E — PRODUCTION

      Downtime / component shortage
             ↓
      schedule delay
             ↓
      lower production output
             ↓
      finished-goods shortage
             ↓
      fulfilment risk


  CHAIN F — QUALITY

      supplier / process defect
             ↓
      failed inspection
             ↓
      scrap or defective shipment
             ↓
      return
             ↓
      financial + service impact


  CHAIN G — WAREHOUSE

      high capacity pressure
             ↓
      lower productivity / errors
             ↓
      slower fulfilment
             ↓
      delayed shipment
             ↓
      SLA breach


  CHAIN H — LOGISTICS

      poor carrier / mode performance
             ↓
      longer transport lead time
             ↓
      late delivery
             ↓
      SLA failure / customer impact

*/


/*##############################################################################
  CHAPTER 11 — COVERAGE AUDIT
##############################################################################*/

/*

  INVENTORY ROOT CAUSE
  [X] stockouts vs demand
  [X] stockouts vs forecast
  [X] stockouts vs supplier concentration
  [X] stockouts vs supplier delay
  [X] high inventory vs movement
  [X] high inventory vs overforecasting

  FORECAST ROOT CAUSE
  [X] error by version
  [X] underforecast vs overforecast

  PROCUREMENT
  [X] PPV by supplier
  [X] PPV vs compliance
  [X] supplier price variation

  SUPPLIER
  [X] on-time vs late
  [X] quality vs delivery
  [X] single-source exposure

  PURCHASE ORDER
  [X] partial receipt
  [X] late + partial

  CUSTOMER FULFILMENT
  [X] low fill rate vs stockout
  [X] warehouse lateness
  [X] carrier lateness

  WAREHOUSE
  [X] productivity vs error
  [X] capacity vs lateness

  PRODUCTION
  [X] yield vs downtime
  [X] scrap vs downtime
  [X] material shortage vs schedule

  QUALITY
  [X] defects by source
  [X] defects by product/type
  [X] defects vs returns

  LOGISTICS
  [X] lateness by carrier
  [X] lateness by mode
  [X] freight vs performance

  RETURNS
  [X] reason
  [X] quality relationship
  [X] late-delivery relationship

  END-TO-END
  [X] product risk profile
  [X] warehouse risk profile
  [X] comparative performance analysis
  [X] symptom vs cause
  [X] root-cause chains


  ROOT-CAUSE STANDARD:
      Do not infer causation solely because two adverse metrics occur together.

      Evidence becomes stronger when:
          keys match
          timing makes sense
          business process makes sense
          performance groups differ materially
          multiple supporting indicators agree


  IMPLEMENTATION PROFILE:
      STANDARD ANALYTICAL SQL

  SQL TECHNIQUES APPLIED:
      Core retrieval: SELECT / WHERE / ORDER BY
      Aggregation: aggregate functions / GROUP BY
      Conditional logic: CASE
      Date analysis: DATEDIFF
      Relational analysis: JOINs
      Relational validation: subqueries / EXISTS
      Structured analysis: CTEs

  The analysis uses standard SQL Server analytical constructs.


  CHAPTER 11 STATUS:
      COMPLETE — INTEGRATED ROOT-CAUSE VERSION

  NEXT:
      CHAPTER 12 — BUSINESS IMPACT QUANTIFICATION
*/

/*==============================================================================
  SOUTHERN CROSS INDUSTRIAL SUPPLY
  CHAPTER 12 — BUSINESS IMPACT QUANTIFICATION
  INTEGRATED ANALYSIS

  PURPOSE:
      Chapter 9  = Current-state assessment
      Chapter 10 = Materiality and performance assessment
      Chapter 11 = Root-cause assessment
      Chapter 12 = Financial and operational impact assessment

  MAIN IMPACT AREAS:
      12.1 Financial Impact
      12.2 Working-Capital Impact
      12.3 Revenue / Customer Impact
      12.4 Service-Level Impact
      12.5 Productivity Impact
      12.6 Capacity Impact
      12.7 Risk Impact
      12.8 Materiality Ranking

  RULE:
      Monetary impact must only be quantified where supported by available data.

      Use:
          actual cost/value where available
          operational proxy where appropriate
          clear labels when a number is only exposure / proxy

  CORE SQL TECHNIQUES:
      core analytical SQL patterns

  IMPLEMENTATION PROFILE:
      STANDARD ANALYTICAL SQL
==============================================================================*/

USE SCIS;
GO


/*##############################################################################
  12.1 — FINANCIAL IMPACT
##############################################################################*/


/*==============================================================================
  12.1.1 TOTAL PROCUREMENT SPEND

  Keep currencies separate unless converted.
==============================================================================*/

SELECT
    po.currency_code,

    SUM(
        pol.ordered_quantity * pol.unit_price
    ) AS procurement_spend

FROM dbo.purchase_orders po
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id

GROUP BY po.currency_code

ORDER BY procurement_spend DESC;


/*==============================================================================
  12.1.2 PROCUREMENT SPEND BY SUPPLIER
==============================================================================*/

SELECT
    po.supplier_id,
    po.currency_code,

    SUM(
        pol.ordered_quantity * pol.unit_price
    ) AS supplier_spend

FROM dbo.purchase_orders po
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id

GROUP BY
    po.supplier_id,
    po.currency_code

ORDER BY supplier_spend DESC;


/*==============================================================================
  12.1.3 UNFAVOURABLE PURCHASE PRICE VARIANCE

  PPV:
      actual unit price - contract/reference price

  Positive PPV = paid above reference price.
==============================================================================*/

SELECT
    pol.product_id,
    po.supplier_id,

    SUM(
        CASE
            WHEN pol.unit_price > sp.contract_unit_price
            THEN
                (pol.unit_price - sp.contract_unit_price)
                * pol.ordered_quantity
            ELSE 0
        END
    ) AS unfavourable_ppv

FROM dbo.purchase_order_lines pol
JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id
JOIN dbo.supplier_products sp
    ON po.supplier_id = sp.supplier_id
   AND pol.product_id = sp.product_id

GROUP BY
    pol.product_id,
    po.supplier_id

ORDER BY unfavourable_ppv DESC;


/*==============================================================================
  12.1.4 FAVOURABLE PRICE VARIANCE

  Important:
      This is not automatically "savings".

  It only means actual price < reference price.
==============================================================================*/

SELECT
    pol.product_id,

    SUM(
        CASE
            WHEN pol.unit_price < sp.contract_unit_price
            THEN
                (sp.contract_unit_price - pol.unit_price)
                * pol.ordered_quantity
            ELSE 0
        END
    ) AS favourable_price_variance

FROM dbo.purchase_order_lines pol
JOIN dbo.purchase_orders po
    ON pol.purchase_order_id = po.purchase_order_id
JOIN dbo.supplier_products sp
    ON po.supplier_id = sp.supplier_id
   AND pol.product_id = sp.product_id

GROUP BY pol.product_id

ORDER BY favourable_price_variance DESC;


/*==============================================================================
  12.1.5 NON-COMPLIANT PROCUREMENT VALUE

  Financial exposure from purchases made outside compliant conditions.
==============================================================================*/

SELECT
    po.currency_code,

    SUM(
        CASE
            WHEN pol.contract_compliant_flag = 0
            THEN pol.ordered_quantity * pol.unit_price
            ELSE 0
        END
    ) AS non_compliant_spend

FROM dbo.purchase_orders po
JOIN dbo.purchase_order_lines pol
    ON po.purchase_order_id = pol.purchase_order_id

GROUP BY po.currency_code;


/*==============================================================================
  12.1.6 SCRAP VALUE

  Direct operational cost proxy:
      scrap quantity × product standard cost
==============================================================================*/

SELECT
    po.product_id,

    SUM(po.scrap_quantity) AS scrap_qty,

    SUM(
        po.scrap_quantity
        * p.standard_cost_aud
    ) AS scrap_value_aud

FROM dbo.production_orders po
JOIN dbo.products p
    ON po.product_id = p.product_id

GROUP BY po.product_id

ORDER BY scrap_value_aud DESC;


/*==============================================================================
  12.1.7 TOTAL SCRAP VALUE
==============================================================================*/

SELECT
    SUM(
        po.scrap_quantity
        * p.standard_cost_aud
    ) AS total_scrap_value_aud

FROM dbo.production_orders po
JOIN dbo.products p
    ON po.product_id = p.product_id;


/*==============================================================================
  12.1.8 RETURN VALUE EXPOSURE

  Proxy:
      return quantity × standard cost

  This is not automatically the final accounting loss.
==============================================================================*/

SELECT
    r.product_id,

    SUM(r.return_quantity) AS returned_qty,

    SUM(
        r.return_quantity
        * p.standard_cost_aud
    ) AS return_value_exposure_aud

FROM dbo.returns r
JOIN dbo.products p
    ON r.product_id = p.product_id

GROUP BY r.product_id

ORDER BY return_value_exposure_aud DESC;


/*==============================================================================
  12.1.9 TOTAL FREIGHT COST

  Shipment grain only.
==============================================================================*/

SELECT
    SUM(freight_cost) AS total_freight_cost
FROM dbo.shipments;


/*==============================================================================
  12.1.10 FREIGHT COST BY CARRIER
==============================================================================*/

SELECT
    carrier_id,

    COUNT(*) AS shipments,
    SUM(freight_cost) AS freight_cost,
    AVG(freight_cost) AS avg_freight_per_shipment

FROM dbo.shipments

GROUP BY carrier_id

ORDER BY freight_cost DESC;


/*##############################################################################
  12.2 — WORKING-CAPITAL IMPACT
##############################################################################*/


/*==============================================================================
  12.2.1 INVENTORY VALUE

  Quantity held × standard cost
==============================================================================*/

SELECT
    i.product_id,

    AVG(i.quantity_on_hand * 1.0) AS avg_inventory_qty,
    p.standard_cost_aud,

    AVG(i.quantity_on_hand * 1.0)
        * p.standard_cost_aud AS avg_inventory_value_aud

FROM dbo.inventory_snapshots i
JOIN dbo.products p
    ON i.product_id = p.product_id

GROUP BY
    i.product_id,
    p.standard_cost_aud

ORDER BY avg_inventory_value_aud DESC;


/*==============================================================================
  12.2.2 TOTAL AVERAGE INVENTORY VALUE
==============================================================================*/

WITH InventoryValue AS
(
    SELECT
        i.product_id,

        AVG(i.quantity_on_hand * 1.0)
            * p.standard_cost_aud AS inventory_value_aud

    FROM dbo.inventory_snapshots i
    JOIN dbo.products p
        ON i.product_id = p.product_id

    GROUP BY
        i.product_id,
        p.standard_cost_aud
)

SELECT
    SUM(inventory_value_aud)
        AS total_avg_inventory_value_aud

FROM InventoryValue;


/*==============================================================================
  12.2.3 SLOW-MOVING INVENTORY VALUE

  Working definition:
      product has inventory
      but relatively low outbound movement.

  This is an exposure indicator, not guaranteed excess inventory.
==============================================================================*/

WITH Inventory AS
(
    SELECT
        i.product_id,
        AVG(i.quantity_on_hand * 1.0) AS avg_inventory_qty

    FROM dbo.inventory_snapshots i

    GROUP BY i.product_id
),

Movement AS
(
    SELECT
        product_id,

        SUM(
            CASE
                WHEN quantity < 0 THEN quantity * -1
                ELSE 0
            END
        ) AS outbound_qty

    FROM dbo.stock_movements

    GROUP BY product_id
)

SELECT
    i.product_id,
    i.avg_inventory_qty,
    m.outbound_qty,
    p.standard_cost_aud,

    i.avg_inventory_qty
        * p.standard_cost_aud AS inventory_value_aud

FROM Inventory i
LEFT JOIN Movement m
    ON i.product_id = m.product_id
JOIN dbo.products p
    ON i.product_id = p.product_id

WHERE
    CASE
        WHEN m.outbound_qty IS NULL THEN 0
        ELSE m.outbound_qty
    END < 100

ORDER BY inventory_value_aud DESC;


/*==============================================================================
  12.2.4 DEAD-STOCK VALUE EXPOSURE

  Inventory exists
  AND no outbound movement recorded.
==============================================================================*/

SELECT
    i.product_id,

    AVG(i.quantity_on_hand * 1.0) AS avg_inventory_qty,

    p.standard_cost_aud,

    AVG(i.quantity_on_hand * 1.0)
        * p.standard_cost_aud AS dead_stock_value_exposure_aud

FROM dbo.inventory_snapshots i
JOIN dbo.products p
    ON i.product_id = p.product_id

WHERE i.quantity_on_hand > 0

  AND NOT EXISTS
(
    SELECT 1

    FROM dbo.stock_movements sm

    WHERE sm.product_id = i.product_id
      AND sm.quantity < 0
)

GROUP BY
    i.product_id,
    p.standard_cost_aud

ORDER BY dead_stock_value_exposure_aud DESC;


/*==============================================================================
  12.2.5 OVER-FORECAST + INVENTORY EXPOSURE

  Possible working-capital chain:
      forecast > actual
          ↓
      excess supply
          ↓
      excess inventory
==============================================================================*/

WITH Actual AS
(
    SELECT
        product_id,
        SUM(quantity) AS actual_qty

    FROM dbo.customer_order_lines

    GROUP BY product_id
),

Forecast AS
(
    SELECT
        product_id,
        SUM(forecast_quantity) AS forecast_qty

    FROM dbo.demand_forecast

    GROUP BY product_id
),

Inventory AS
(
    SELECT
        product_id,
        AVG(quantity_on_hand * 1.0) AS avg_inventory_qty

    FROM dbo.inventory_snapshots

    GROUP BY product_id
)

SELECT
    i.product_id,
    f.forecast_qty,
    a.actual_qty,

    f.forecast_qty - a.actual_qty AS overforecast_qty,

    i.avg_inventory_qty,

    i.avg_inventory_qty
        * p.standard_cost_aud AS inventory_value_aud

FROM Inventory i
JOIN Forecast f
    ON i.product_id = f.product_id
JOIN Actual a
    ON i.product_id = a.product_id
JOIN dbo.products p
    ON i.product_id = p.product_id

WHERE f.forecast_qty > a.actual_qty

ORDER BY inventory_value_aud DESC;


/*##############################################################################
  12.3 — REVENUE / CUSTOMER IMPACT
##############################################################################*/


/*==============================================================================
  12.3.1 BACKORDER QUANTITY EXPOSURE

  Quantity ordered but not yet shipped.
==============================================================================*/

WITH Ordered AS
(
    SELECT
        customer_order_id,
        SUM(quantity) AS ordered_qty

    FROM dbo.customer_order_lines

    GROUP BY customer_order_id
),

Shipped AS
(
    SELECT
        customer_order_id,
        SUM(shipped_quantity) AS shipped_qty

    FROM dbo.shipment_lines

    GROUP BY customer_order_id
)

SELECT
    o.customer_order_id,

    CASE
        WHEN s.shipped_qty IS NULL
            THEN o.ordered_qty

        WHEN o.ordered_qty > s.shipped_qty
            THEN o.ordered_qty - s.shipped_qty

        ELSE 0
    END AS backorder_qty

FROM Ordered o
LEFT JOIN Shipped s
    ON o.customer_order_id = s.customer_order_id

ORDER BY backorder_qty DESC;


/*==============================================================================
  12.3.2 TOTAL BACKORDER QUANTITY
==============================================================================*/

WITH Ordered AS
(
    SELECT
        customer_order_id,
        SUM(quantity) AS ordered_qty

    FROM dbo.customer_order_lines

    GROUP BY customer_order_id
),

Shipped AS
(
    SELECT
        customer_order_id,
        SUM(shipped_quantity) AS shipped_qty

    FROM dbo.shipment_lines

    GROUP BY customer_order_id
)

SELECT
    SUM(
        CASE
            WHEN s.shipped_qty IS NULL
                THEN o.ordered_qty

            WHEN o.ordered_qty > s.shipped_qty
                THEN o.ordered_qty - s.shipped_qty

            ELSE 0
        END
    ) AS total_backorder_qty

FROM Ordered o
LEFT JOIN Shipped s
    ON o.customer_order_id = s.customer_order_id;


/*==============================================================================
  12.3.3 BACKORDER VALUE PROXY

  Only valid if customer order line has a selling price field.

  If unit_sale_price exists:
      backorder qty × selling price

  Sales price must not be derived where no selling-price field is available in the source data.
==============================================================================*/

/*
SELECT
    col.product_id,

    SUM(
        CASE
            WHEN col.quantity > sl.shipped_quantity
            THEN
                (col.quantity - sl.shipped_quantity)
                * col.unit_sale_price
            ELSE 0
        END
    ) AS backorder_value_aud

FROM dbo.customer_order_lines col
LEFT JOIN dbo.shipment_lines sl
    ON col.customer_order_id = sl.customer_order_id
   AND col.product_id = sl.product_id

GROUP BY col.product_id;
*/


/*==============================================================================
  12.3.4 CUSTOMER ORDERS AFFECTED BY LATE DELIVERY
==============================================================================*/

SELECT
    COUNT(DISTINCT customer_order_id)
        AS customer_orders_affected_by_lateness

FROM dbo.shipments

WHERE actual_delivery_date > promised_delivery_date;


/*==============================================================================
  12.3.5 CUSTOMER ORDERS AFFECTED BY RETURNS
==============================================================================*/

SELECT
    COUNT(DISTINCT customer_order_id)
        AS customer_orders_with_returns

FROM dbo.returns;


/*==============================================================================
  12.3.6 CUSTOMER ORDER IMPACT BY WAREHOUSE
==============================================================================*/

SELECT
    warehouse_id,

    COUNT(*) AS delivered_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_shipments

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL

GROUP BY warehouse_id

ORDER BY late_shipments DESC;


/*##############################################################################
  12.4 — SERVICE-LEVEL IMPACT
##############################################################################*/


/*==============================================================================
  12.4.1 LATE DELIVERY RATE
==============================================================================*/

SELECT
    COUNT(*) AS delivered_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS late_delivery_pct

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL;


/*==============================================================================
  12.4.2 AVERAGE DAYS LATE
==============================================================================*/

SELECT
    AVG(
        DATEDIFF(
            DAY,
            promised_delivery_date,
            actual_delivery_date
        ) * 1.0
    ) AS avg_days_late

FROM dbo.shipments

WHERE actual_delivery_date > promised_delivery_date;


/*==============================================================================
  12.4.3 FILL-RATE IMPACT
==============================================================================*/

WITH Ordered AS
(
    SELECT
        customer_order_id,
        SUM(quantity) AS ordered_qty

    FROM dbo.customer_order_lines

    GROUP BY customer_order_id
),

Shipped AS
(
    SELECT
        customer_order_id,
        SUM(shipped_quantity) AS shipped_qty

    FROM dbo.shipment_lines

    GROUP BY customer_order_id
)

SELECT
    SUM(o.ordered_qty) AS ordered_qty,

    SUM(
        CASE
            WHEN s.shipped_qty IS NULL THEN 0
            ELSE s.shipped_qty
        END
    ) AS shipped_qty,

    SUM(
        CASE
            WHEN s.shipped_qty IS NULL
                THEN o.ordered_qty

            WHEN o.ordered_qty > s.shipped_qty
                THEN o.ordered_qty - s.shipped_qty

            ELSE 0
        END
    ) AS unfulfilled_qty

FROM Ordered o
LEFT JOIN Shipped s
    ON o.customer_order_id = s.customer_order_id;


/*==============================================================================
  12.4.4 SLA BREACHES BY CARRIER
==============================================================================*/

SELECT
    carrier_id,

    COUNT(*) AS delivered_shipments,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS sla_breaches,

    SUM(
        CASE
            WHEN actual_delivery_date > promised_delivery_date
            THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS sla_breach_pct

FROM dbo.shipments

WHERE actual_delivery_date IS NOT NULL

GROUP BY carrier_id

ORDER BY sla_breach_pct DESC;


/*==============================================================================
  12.4.5 PERFECT-ORDER LOSS

  Orders failing full-shipment / no-return conditions.
==============================================================================*/

WITH Ordered AS
(
    SELECT
        customer_order_id,
        SUM(quantity) AS ordered_qty

    FROM dbo.customer_order_lines

    GROUP BY customer_order_id
),

Shipped AS
(
    SELECT
        customer_order_id,
        SUM(shipped_quantity) AS shipped_qty

    FROM dbo.shipment_lines

    GROUP BY customer_order_id
),

Returned AS
(
    SELECT
        customer_order_id,
        COUNT(*) AS return_events

    FROM dbo.returns

    GROUP BY customer_order_id
)

SELECT
    COUNT(*) AS total_orders,

    SUM(
        CASE
            WHEN s.shipped_qty >= o.ordered_qty
             AND r.return_events IS NULL
            THEN 1
            ELSE 0
        END
    ) AS potential_perfect_orders,

    SUM(
        CASE
            WHEN s.shipped_qty >= o.ordered_qty
             AND r.return_events IS NULL
            THEN 0
            ELSE 1
        END
    ) AS exception_orders

FROM Ordered o

LEFT JOIN Shipped s
    ON o.customer_order_id = s.customer_order_id

LEFT JOIN Returned r
    ON o.customer_order_id = r.customer_order_id;


/*##############################################################################
  12.5 — PRODUCTIVITY IMPACT
##############################################################################*/


/*==============================================================================
  12.5.1 WAREHOUSE PRODUCTIVITY
==============================================================================*/

SELECT
    warehouse_id,

    SUM(lines_picked) AS lines_picked,
    SUM(labour_hours) AS labour_hours,

    CASE
        WHEN SUM(labour_hours) > 0
        THEN
            SUM(lines_picked) * 1.0
            / SUM(labour_hours)
        ELSE NULL
    END AS lines_per_labour_hour

FROM dbo.warehouse_operations

GROUP BY warehouse_id

ORDER BY lines_per_labour_hour;


/*==============================================================================
  12.5.2 PICK-ERROR IMPACT

  Errors represent rework / productivity leakage.
==============================================================================*/

SELECT
    warehouse_id,

    SUM(pick_errors) AS pick_errors,

    SUM(lines_picked) AS lines_picked,

    CASE
        WHEN SUM(lines_picked) > 0

        THEN
            SUM(pick_errors) * 100.0
            / SUM(lines_picked)

        ELSE NULL
    END AS pick_error_pct

FROM dbo.warehouse_operations

GROUP BY warehouse_id

ORDER BY pick_errors DESC;


/*==============================================================================
  12.5.3 PRODUCTION SCRAP IMPACT
==============================================================================*/

SELECT
    product_id,

    SUM(actual_good_quantity) AS good_qty,
    SUM(scrap_quantity) AS scrap_qty,

    CASE
        WHEN SUM(actual_good_quantity + scrap_quantity) > 0

        THEN
            SUM(scrap_quantity) * 100.0
            / SUM(actual_good_quantity + scrap_quantity)

        ELSE NULL
    END AS lost_output_pct

FROM dbo.production_orders

GROUP BY product_id

ORDER BY lost_output_pct DESC;


/*==============================================================================
  12.5.4 DOWNTIME HOURS
==============================================================================*/

SELECT
    downtime_reason,

    SUM(duration_minutes) / 60.0
        AS downtime_hours

FROM dbo.downtime_events

GROUP BY downtime_reason

ORDER BY downtime_hours DESC;


/*==============================================================================
  12.5.5 TOTAL DOWNTIME HOURS
==============================================================================*/

SELECT
    SUM(duration_minutes) / 60.0
        AS total_downtime_hours

FROM dbo.downtime_events;


/*==============================================================================
  12.5.6 QUALITY REWORK / FAILURE EXPOSURE
==============================================================================*/

SELECT
    defect_type,

    SUM(defect_quantity) AS defect_qty

FROM dbo.quality_inspections

WHERE defect_type IS NOT NULL

GROUP BY defect_type

ORDER BY defect_qty DESC;


/*##############################################################################
  12.6 — CAPACITY IMPACT
##############################################################################*/


/*==============================================================================
  12.6.1 WAREHOUSE CAPACITY UTILISATION
==============================================================================*/

SELECT
    wo.warehouse_id,

    SUM(wo.units_processed) AS processed_units,

    w.daily_capacity,

    CASE
        WHEN w.daily_capacity > 0

        THEN
            SUM(wo.units_processed) * 100.0
            / w.daily_capacity

        ELSE NULL
    END AS capacity_utilisation_pct

FROM dbo.warehouse_operations wo
JOIN dbo.warehouses w
    ON wo.warehouse_id = w.warehouse_id

GROUP BY
    wo.warehouse_id,
    w.daily_capacity

ORDER BY capacity_utilisation_pct DESC;


/*==============================================================================
  12.6.2 PRODUCTION OUTPUT LOST TO SCRAP

  Physical capacity impact:
      units produced but not usable.
==============================================================================*/

SELECT
    product_id,

    SUM(scrap_quantity)
        AS output_units_lost_to_scrap

FROM dbo.production_orders

GROUP BY product_id

ORDER BY output_units_lost_to_scrap DESC;


/*==============================================================================
  12.6.3 DOWNTIME CAPACITY LOSS

  Shows downtime by production order.
==============================================================================*/

SELECT
    production_order_id,

    SUM(duration_minutes) AS downtime_minutes,

    SUM(duration_minutes) / 60.0
        AS downtime_hours

FROM dbo.downtime_events

GROUP BY production_order_id

ORDER BY downtime_minutes DESC;


/*==============================================================================
  12.6.4 MATERIAL SHORTAGE CAPACITY EXPOSURE

  Production orders where required component quantity
  exceeds available inventory.
==============================================================================*/

WITH Required AS
(
    SELECT
        po.production_order_id,
        po.warehouse_id,
        b.component_product_id,

        po.planned_quantity
            * b.quantity_per_parent AS required_qty

    FROM dbo.production_orders po
    JOIN dbo.bom b
        ON po.product_id = b.parent_product_id
),

Available AS
(
    SELECT
        warehouse_id,
        product_id,

        AVG(quantity_on_hand * 1.0)
            AS available_qty

    FROM dbo.inventory_snapshots

    GROUP BY
        warehouse_id,
        product_id
)

SELECT
    COUNT(DISTINCT r.production_order_id)
        AS production_orders_with_component_shortage

FROM Required r
LEFT JOIN Available a
    ON r.warehouse_id = a.warehouse_id
   AND r.component_product_id = a.product_id

WHERE
    a.available_qty IS NULL
    OR a.available_qty < r.required_qty;


/*##############################################################################
  12.7 — RISK IMPACT
##############################################################################*/


/*==============================================================================
  12.7.1 SINGLE-SOURCE EXPOSURE

  Number of products with only one supplier.
==============================================================================*/

SELECT
    COUNT(*) AS single_source_products

FROM
(
    SELECT
        product_id

    FROM dbo.supplier_products

    GROUP BY product_id

    HAVING COUNT(DISTINCT supplier_id) = 1
) x;


/*==============================================================================
  12.7.2 SINGLE-SOURCE + STOCKOUT EXPOSURE
==============================================================================*/

WITH Stockout AS
(
    SELECT DISTINCT
        product_id

    FROM dbo.inventory_snapshots

    WHERE quantity_on_hand <= 0
),

SupplierCount AS
(
    SELECT
        product_id,
        COUNT(DISTINCT supplier_id) AS supplier_count

    FROM dbo.supplier_products

    GROUP BY product_id
)

SELECT
    COUNT(*) AS single_source_stockout_products

FROM Stockout s
JOIN SupplierCount sc
    ON s.product_id = sc.product_id

WHERE sc.supplier_count = 1;


/*==============================================================================
  12.7.3 SUPPLIER DELIVERY RISK
==============================================================================*/

SELECT
    po.supplier_id,

    COUNT(*) AS receipts,

    SUM(
        CASE
            WHEN gr.receipt_date > po.expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) AS late_receipts,

    SUM(
        CASE
            WHEN gr.receipt_date > po.expected_delivery_date
            THEN 1
            ELSE 0
        END
    ) * 100.0 / COUNT(*) AS late_receipt_pct

FROM dbo.purchase_orders po
JOIN dbo.goods_receipts gr
    ON po.purchase_order_id = gr.purchase_order_id

GROUP BY po.supplier_id

ORDER BY late_receipt_pct DESC;


/*==============================================================================
  12.7.4 FORECAST RISK

  Number of products under-forecast.
==============================================================================*/

WITH Actual AS
(
    SELECT
        product_id,
        SUM(quantity) AS actual_qty

    FROM dbo.customer_order_lines

    GROUP BY product_id
),

Forecast AS
(
    SELECT
        product_id,
        SUM(forecast_quantity) AS forecast_qty

    FROM dbo.demand_forecast

    GROUP BY product_id
)

SELECT
    COUNT(*) AS underforecast_products

FROM Actual a
JOIN Forecast f
    ON a.product_id = f.product_id

WHERE a.actual_qty > f.forecast_qty;


/*==============================================================================
  12.7.5 QUALITY RISK
==============================================================================*/

SELECT
    product_id,

    SUM(defect_quantity) AS defect_qty,

    CASE
        WHEN SUM(inspected_quantity) > 0
        THEN
            SUM(defect_quantity) * 100.0
            / SUM(inspected_quantity)

        ELSE NULL
    END AS defect_rate_pct

FROM dbo.quality_inspections

GROUP BY product_id

ORDER BY defect_rate_pct DESC;


/*==============================================================================
  12.7.6 CUSTOMER-SERVICE RISK

  Products with both stockouts and returns.
==============================================================================*/

WITH Stockout AS
(
    SELECT DISTINCT
        product_id

    FROM dbo.inventory_snapshots

    WHERE quantity_on_hand <= 0
),

Returned AS
(
    SELECT
        product_id,
        SUM(return_quantity) AS return_qty

    FROM dbo.returns

    GROUP BY product_id
)

SELECT
    s.product_id,
    r.return_qty

FROM Stockout s
JOIN Returned r
    ON s.product_id = r.product_id

ORDER BY r.return_qty DESC;


/*==============================================================================
  12.7.7 OPERATIONAL RISK SUMMARY

  Keep separate event types.
==============================================================================*/

SELECT
    'Stockout Events' AS risk_type,
    COUNT(*) AS risk_count

FROM dbo.inventory_snapshots

WHERE quantity_on_hand <= 0

UNION ALL

SELECT
    'Late Shipments',
    COUNT(*)

FROM dbo.shipments

WHERE actual_delivery_date > promised_delivery_date

UNION ALL

SELECT
    'Quality Failures',
    COUNT(*)

FROM dbo.quality_inspections

WHERE inspection_result = 'Fail'

UNION ALL

SELECT
    'Returns',
    COUNT(*)

FROM dbo.returns

UNION ALL

SELECT
    'Downtime Events',
    COUNT(*)

FROM dbo.downtime_events;


/*##############################################################################
  12.8 — MATERIALITY RANKING
##############################################################################*/


/*==============================================================================
  12.8.1 FINANCIAL MATERIALITY — PRODUCT LEVEL

  Supported AUD-valued impacts can be compared:

      inventory value
      scrap value
      return value exposure

  These measures represent distinct types of exposure and should not be interpreted equivalently.

  Materiality ranking identifies the largest measurable exposure.
==============================================================================*/

WITH InventoryValue AS
(
    SELECT
        i.product_id,

        AVG(i.quantity_on_hand * 1.0)
            * p.standard_cost_aud AS inventory_value_aud

    FROM dbo.inventory_snapshots i
    JOIN dbo.products p
        ON i.product_id = p.product_id

    GROUP BY
        i.product_id,
        p.standard_cost_aud
),

ScrapValue AS
(
    SELECT
        po.product_id,

        SUM(
            po.scrap_quantity
            * p.standard_cost_aud
        ) AS scrap_value_aud

    FROM dbo.production_orders po
    JOIN dbo.products p
        ON po.product_id = p.product_id

    GROUP BY po.product_id
),

ReturnValue AS
(
    SELECT
        r.product_id,

        SUM(
            r.return_quantity
            * p.standard_cost_aud
        ) AS return_value_aud

    FROM dbo.returns r
    JOIN dbo.products p
        ON r.product_id = p.product_id

    GROUP BY r.product_id
)

SELECT
    p.product_id,

    CASE
        WHEN i.inventory_value_aud IS NULL THEN 0
        ELSE i.inventory_value_aud
    END AS inventory_value_aud,

    CASE
        WHEN s.scrap_value_aud IS NULL THEN 0
        ELSE s.scrap_value_aud
    END AS scrap_value_aud,

    CASE
        WHEN r.return_value_aud IS NULL THEN 0
        ELSE r.return_value_aud
    END AS return_value_aud

FROM dbo.products p

LEFT JOIN InventoryValue i
    ON p.product_id = i.product_id

LEFT JOIN ScrapValue s
    ON p.product_id = s.product_id

LEFT JOIN ReturnValue r
    ON p.product_id = r.product_id

ORDER BY
    CASE
        WHEN i.inventory_value_aud IS NULL THEN 0
        ELSE i.inventory_value_aud
    END
    +
    CASE
        WHEN s.scrap_value_aud IS NULL THEN 0
        ELSE s.scrap_value_aud
    END
    +
    CASE
        WHEN r.return_value_aud IS NULL THEN 0
        ELSE r.return_value_aud
    END DESC;


/*==============================================================================
  12.8.2 OPERATIONAL MATERIALITY — PRODUCT RISK PROFILE

  Count major problem domains.

  Heterogeneous quantities are not aggregated directly.
  Each exception is converted to a binary indicator for composite analysis.
==============================================================================*/

WITH Stockout AS
(
    SELECT DISTINCT product_id
    FROM dbo.inventory_snapshots
    WHERE quantity_on_hand <= 0
),

SingleSource AS
(
    SELECT
        product_id

    FROM dbo.supplier_products

    GROUP BY product_id

    HAVING COUNT(DISTINCT supplier_id) = 1
),

Quality AS
(
    SELECT
        product_id

    FROM dbo.quality_inspections

    GROUP BY product_id

    HAVING SUM(defect_quantity) > 0
),

Returned AS
(
    SELECT DISTINCT product_id
    FROM dbo.returns
)

SELECT
    p.product_id,

    CASE
        WHEN st.product_id IS NOT NULL THEN 1
        ELSE 0
    END AS stockout_flag,

    CASE
        WHEN ss.product_id IS NOT NULL THEN 1
        ELSE 0
    END AS single_source_flag,

    CASE
        WHEN q.product_id IS NOT NULL THEN 1
        ELSE 0
    END AS quality_flag,

    CASE
        WHEN r.product_id IS NOT NULL THEN 1
        ELSE 0
    END AS return_flag,

    CASE
        WHEN st.product_id IS NOT NULL THEN 1 ELSE 0
    END
    +
    CASE
        WHEN ss.product_id IS NOT NULL THEN 1 ELSE 0
    END
    +
    CASE
        WHEN q.product_id IS NOT NULL THEN 1 ELSE 0
    END
    +
    CASE
        WHEN r.product_id IS NOT NULL THEN 1 ELSE 0
    END AS active_risk_areas

FROM dbo.products p

LEFT JOIN Stockout st
    ON p.product_id = st.product_id

LEFT JOIN SingleSource ss
    ON p.product_id = ss.product_id

LEFT JOIN Quality q
    ON p.product_id = q.product_id

LEFT JOIN Returned r
    ON p.product_id = r.product_id

ORDER BY active_risk_areas DESC;


/*==============================================================================
  12.8.3 WAREHOUSE MATERIALITY

  Compare:
      stockouts
      pick errors
      late shipments
==============================================================================*/

WITH Stockout AS
(
    SELECT
        warehouse_id,
        COUNT(*) AS stockout_events

    FROM dbo.inventory_snapshots

    WHERE quantity_on_hand <= 0

    GROUP BY warehouse_id
),

Errors AS
(
    SELECT
        warehouse_id,
        SUM(pick_errors) AS pick_errors

    FROM dbo.warehouse_operations

    GROUP BY warehouse_id
),

Late AS
(
    SELECT
        warehouse_id,

        SUM(
            CASE
                WHEN actual_delivery_date > promised_delivery_date
                THEN 1 ELSE 0
            END
        ) AS late_shipments

    FROM dbo.shipments

    GROUP BY warehouse_id
)

SELECT
    w.warehouse_id,
    w.warehouse_name,

    CASE
        WHEN s.stockout_events IS NULL THEN 0
        ELSE s.stockout_events
    END AS stockout_events,

    CASE
        WHEN e.pick_errors IS NULL THEN 0
        ELSE e.pick_errors
    END AS pick_errors,

    CASE
        WHEN l.late_shipments IS NULL THEN 0
        ELSE l.late_shipments
    END AS late_shipments

FROM dbo.warehouses w

LEFT JOIN Stockout s
    ON w.warehouse_id = s.warehouse_id

LEFT JOIN Errors e
    ON w.warehouse_id = e.warehouse_id

LEFT JOIN Late l
    ON w.warehouse_id = l.warehouse_id

ORDER BY
    CASE WHEN s.stockout_events IS NULL THEN 0 ELSE s.stockout_events END
    +
    CASE WHEN e.pick_errors IS NULL THEN 0 ELSE e.pick_errors END
    +
    CASE WHEN l.late_shipments IS NULL THEN 0 ELSE l.late_shipments END
    DESC;


/*==============================================================================
  12.8.4 MANAGEMENT MATERIALITY VIEW

  Important:
      Financial impact and operational impact use different units.

  The following measures should not be aggregated directly:
      AUD + units + days + percentages.

  Instead rank within comparable categories.
==============================================================================*/


/*##############################################################################
  CHAPTER 12 — IMPACT INTERPRETATION RULES
##############################################################################*/

/*

  FINANCIAL IMPACT
  ----------------
  Strongest direct / proxy values:
      procurement spend
      unfavourable PPV
      non-compliant spend
      scrap value
      return value exposure
      freight cost


  WORKING CAPITAL
  ---------------
      inventory value
      slow-moving value
      dead-stock exposure
      overforecast + inventory


  CUSTOMER / REVENUE
  ------------------
      unfulfilled quantity
      backorders
      late orders
      returned orders

  Revenue impact should only be calculated if selling price / revenue fields
  genuinely exist in the dataset.


  SERVICE
  -------
      late delivery rate
      days late
      fill rate
      SLA breaches
      perfect-order exceptions


  PRODUCTIVITY
  ------------
      warehouse productivity
      pick errors
      scrap
      downtime
      defects


  CAPACITY
  --------
      warehouse utilisation
      scrap units
      downtime hours
      production orders constrained by materials


  RISK
  ----
      single-source products
      single-source + stockout
      supplier lateness
      forecast underestimation
      quality failures
      returns


  MATERIALITY
  -----------
  Rank problems using:
      scale
      value
      frequency
      severity
      business exposure

  A composite score should only be implemented after management approves the weighting methodology.
*/


/*##############################################################################
  CHAPTER 12 — COVERAGE AUDIT
##############################################################################*/

/*

  12.1 FINANCIAL IMPACT
  [X] procurement spend
  [X] supplier spend
  [X] unfavourable PPV
  [X] favourable price variance
  [X] non-compliant spend
  [X] scrap value
  [X] return value exposure
  [X] freight cost

  12.2 WORKING-CAPITAL IMPACT
  [X] inventory value
  [X] total inventory value
  [X] slow-moving inventory exposure
  [X] dead-stock value
  [X] overforecast + inventory exposure

  12.3 REVENUE / CUSTOMER IMPACT
  [X] backorder quantity
  [X] total backorder
  [X] late customer orders
  [X] returned customer orders
  [X] warehouse customer impact
  [LIMITATION] Revenue value needs selling-price field

  12.4 SERVICE-LEVEL IMPACT
  [X] late delivery %
  [X] average days late
  [X] fill-rate quantity impact
  [X] SLA breach
  [X] perfect-order exceptions

  12.5 PRODUCTIVITY IMPACT
  [X] warehouse productivity
  [X] pick-error impact
  [X] scrap impact
  [X] downtime
  [X] quality failure exposure

  12.6 CAPACITY IMPACT
  [X] warehouse utilisation
  [X] lost output to scrap
  [X] downtime capacity loss
  [X] material shortage exposure

  12.7 RISK IMPACT
  [X] single sourcing
  [X] single-source + stockout
  [X] supplier delivery risk
  [X] forecast risk
  [X] quality risk
  [X] customer-service risk
  [X] operational risk summary

  12.8 MATERIALITY
  [X] financial exposure ranking
  [X] operational risk profile
  [X] warehouse materiality
  [X] management ranking principle


  IMPLEMENTATION PROFILE:
      STANDARD ANALYTICAL SQL

  SQL TECHNIQUES APPLIED:
      Core retrieval: SELECT / WHERE / ORDER BY
      Aggregation: SUM / AVG / COUNT / GROUP BY
      Conditional logic: CASE
      Date analysis: DATEDIFF
      Relational analysis: JOINs
      Set operations: UNION ALL
      Relational validation: NOT EXISTS / subqueries
      Structured analysis: CTEs

  STANDARD SQL SERVER ANALYTICAL CONSTRUCTS APPLIED.


  CHAPTER 12 STATUS:
      COMPLETE — INTEGRATED BUSINESS-IMPACT VERSION
*/
