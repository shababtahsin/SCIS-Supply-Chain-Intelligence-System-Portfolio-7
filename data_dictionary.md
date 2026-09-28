# SCIS Data Dictionary

> **Southern Cross Industrial Supply — Source Data Dictionary**  
> Covers the 25 CSV files used by the SQL Server / SSMS supply-chain analytics project.

---

## Scope and Conventions

This dictionary documents the **raw source-file structure** used by the SCIS project. Suggested SQL types are logical implementation types based on the supplied CSV values and business meaning; equivalent SQL Server types may be used in staging or final analytical tables.

- **PK** — primary key / intended unique identifier.
- **CK** — component of a composite business key.
- **FK** — foreign-key relationship to another source table.
- **Nullable** reflects the supplied raw CSV files, not a universal business rule.
- Rates and percentages stored as decimals use `0.95 = 95%`.
- Monetary fields explicitly suffixed `_aud` are Australian dollars; other prices inherit the transaction currency from the relevant header/master record.

---

## Dataset Overview

| Table | Rows | Columns | Grain | Business Key |
|---|---:|---:|---|---|
| `regions` | 4 | 4 | One row per region. | `region_id` |
| `warehouses` | 5 | 8 | One row per warehouse/site. | `warehouse_id` |
| `suppliers` | 60 | 7 | One row per supplier. | `supplier_id` |
| `products` | 150 | 10 | One row per product. | `product_id` |
| `supplier_products` | 399 | 7 | One row per supplier-product sourcing record. | `supplier_id, product_id` |
| `contracts` | 45 | 8 | One row per supplier contract. | `contract_id` |
| `bom` | 145 | 4 | One row per parent-product/component-product relationship. | `parent_product_id, component_product_id` |
| `fx_rates` | 312 | 3 | One row per rate date and currency. | `rate_date, currency` |
| `demand_forecast` | 5,400 | 5 | One row per month, warehouse, product and forecast version. | `forecast_month, warehouse_id, product_id, forecast_version` |
| `customer_orders` | 9,000 | 8 | One row per sales order. | `sales_order_id` |
| `customer_order_lines` | 27,073 | 6 | One row per sales-order line. | `sales_order_id, line_no` |
| `carriers` | 12 | 4 | One row per carrier. | `carrier_id` |
| `shipments` | 5,907 | 10 | One row per shipment. | `shipment_id` |
| `shipment_lines` | 17,735 | 5 | One row per shipment line. | `shipment_id, line_no` |
| `purchase_orders` | 6,500 | 8 | One row per purchase order. | `po_id` |
| `purchase_order_lines` | 22,737 | 7 | One row per PO line. | `po_id, line_no` |
| `goods_receipts` | 17,744 | 8 | One row per goods-receipt record. | `receipt_id` |
| `inventory_snapshots` | 42,900 | 8 | One row per snapshot date, warehouse and product. | `snapshot_date, warehouse_id, product_id` |
| `stock_movements` | 18,000 | 8 | One row per inventory movement. | `movement_id` |
| `production_orders` | 1,800 | 10 | One row per production order. | `production_order_id` |
| `production_events` | 6,361 | 7 | One row per production event. | `event_id` |
| `downtime_events` | 948 | 5 | One row per downtime event. | `downtime_id` |
| `quality_inspections` | 10,000 | 9 | One row per inspection. | `inspection_id` |
| `returns` | 1,039 | 8 | One row per return event. | `return_id` |
| `warehouse_operations` | 2,184 | 9 | One row per warehouse per operating date. | `warehouse_ops_id` |

**Total source rows: 196,460**

---

## Relationship Map

```text
regions → warehouses
warehouses → customer_orders / shipments / purchase_orders / inventory_snapshots / stock_movements / production_orders / warehouse_operations
suppliers → supplier_products / contracts / purchase_orders
products → supplier_products / BOM / forecasts / order lines / shipment lines / PO lines / receipts / inventory / production / returns
customer_orders → customer_order_lines → shipment_lines
customer_orders → shipments → shipment_lines / returns
purchase_orders → purchase_order_lines → goods_receipts
production_orders → production_events / downtime_events
goods_receipts OR production_events → quality_inspections
carriers → shipments
```

> The project intentionally validates these relationships before KPI calculation to detect orphan records and join multiplication.

---

## 1. `regions`

**Purpose:** Reference geography for operating regions.  
**Grain:** One row per region.  
**Business key:** `region_id`  
**Rows:** 4  
**Source note:** Master/reference table.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `region_id` | `VARCHAR(12)` | PK | No | Unique region identifier. |
| `region_name` | `VARCHAR(20)` | — | No | Business name of the operating region. |
| `country` | `VARCHAR(10)` | — | No | Country associated with the region. |
| `global_region` | `VARCHAR(10)` | — | No | Higher-level global geography. |

---

## 2. `warehouses`

**Purpose:** Warehouse and manufacturing-site master data.  
**Grain:** One row per warehouse/site.  
**Business key:** `warehouse_id`  
**Rows:** 5  
**Source note:** Includes four distribution centres and one manufacturing plant.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `warehouse_id` | `VARCHAR(12)` | PK | No | Unique warehouse/site identifier. |
| `warehouse_name` | `VARCHAR(20)` | — | No | Business name of the warehouse or site. |
| `region_id` | `VARCHAR(12)` | FK → regions.region_id | No | Unique region identifier. |
| `city` | `VARCHAR(10)` | — | No | City where the site is located. |
| `location_type` | `VARCHAR(20)` | — | No | Operational site type, such as Distribution Centre or Manufacturing Plant. |
| `capacity_units` | `INT` | — | No | Nominal storage/handling capacity expressed in units. |
| `daily_throughput_capacity` | `INT` | — | No | Nominal daily processing capacity in units/orders as defined by the source. |
| `status` | `VARCHAR(10)` | — | No | Current master/record status. |

---

## 3. `suppliers`

**Purpose:** Supplier master data and supplier risk attributes.  
**Grain:** One row per supplier.  
**Business key:** `supplier_id`  
**Rows:** 60  
**Source note:** Raw supplier names include whitespace/casing issues handled during transformation.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `supplier_id` | `VARCHAR(12)` | PK | No | Unique supplier identifier. |
| `supplier_name` | `VARCHAR(30)` | — | No | Supplier business name. |
| `country` | `VARCHAR(20)` | — | No | Country in which the supplier is based. |
| `supplier_category` | `VARCHAR(20)` | — | No | Supplier classification such as Preferred or Approved. |
| `risk_score` | `DECIMAL(18,4)` | — | No | Supplier risk score used for risk segmentation; higher/lower interpretation should follow the project business rule. |
| `payment_terms` | `VARCHAR(10)` | — | Yes | Commercial payment terms agreed with the supplier. |
| `status` | `VARCHAR(10)` | — | No | Current master/record status. |

---

## 4. `products`

**Purpose:** Product master data used across procurement, inventory, production and sales.  
**Grain:** One row per product.  
**Business key:** `product_id`  
**Rows:** 150  
**Source note:** Contains planning parameters such as reorder point, safety stock and standard lead time.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `product_id` | `VARCHAR(12)` | PK | No | Unique product identifier. |
| `product_name` | `VARCHAR(20)` | — | No | Product business name. |
| `category` | `VARCHAR(20)` | — | No | High-level product category. |
| `subcategory` | `VARCHAR(20)` | — | No | Detailed product subcategory. |
| `uom` | `VARCHAR(10)` | — | No | Unit of measure, e.g. EA, KG or L. |
| `standard_cost_aud` | `DECIMAL(18,2)` | — | Yes | Standard product cost in Australian dollars. |
| `reorder_point` | `INT` | — | No | Inventory level that triggers replenishment review. |
| `safety_stock` | `INT` | — | No | Target buffer stock held against uncertainty. |
| `standard_lead_time_days` | `INT` | — | No | Standard replenishment lead time in days. |
| `status` | `VARCHAR(20)` | — | No | Current master/record status. |

---

## 5. `supplier_products`

**Purpose:** Supplier-to-product sourcing relationships and commercial terms.  
**Grain:** One row per supplier-product sourcing record.  
**Business key:** `supplier_id, product_id`  
**Rows:** 399  
**Source note:** Raw source contains 12 exact duplicate rows; the pair is the intended business key after deduplication.

> **Raw-data QA:** 12 exact duplicate row(s) are present in the supplied CSV and should be handled during transformation/QA.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `supplier_id` | `VARCHAR(12)` | CK/FK → suppliers.supplier_id | No | Unique supplier identifier. |
| `product_id` | `VARCHAR(12)` | CK/FK → products.product_id | No | Unique product identifier. |
| `contract_unit_price` | `DECIMAL(18,2)` | — | No | Supplier-product contracted unit price in the stated currency. |
| `contract_lead_time_days` | `INT` | — | No | Contracted supplier lead time in days. |
| `moq` | `INT` | — | No | Minimum order quantity. |
| `currency` | `VARCHAR(10)` | — | No | ISO-style transaction/contract currency code. |
| `approved_flag` | `VARCHAR(10)` | — | No | Y/N indicator showing whether the supplier-product combination is approved. |

---

## 6. `contracts`

**Purpose:** Supplier contract headers and compliance targets.  
**Grain:** One row per supplier contract.  
**Business key:** `contract_id`  
**Rows:** 45  
**Source note:** Contract status and target compliance rates support procurement analysis.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `contract_id` | `VARCHAR(12)` | PK | No | Unique supplier contract identifier. |
| `supplier_id` | `VARCHAR(12)` | FK → suppliers.supplier_id | No | Unique supplier identifier. |
| `start_date` | `DATE` | — | No | Contract start date. |
| `end_date` | `DATE` | — | No | Contract expiry/end date. |
| `currency` | `VARCHAR(10)` | — | No | ISO-style transaction/contract currency code. |
| `payment_terms` | `VARCHAR(10)` | — | No | Commercial payment terms agreed with the supplier. |
| `target_compliance_rate` | `DECIMAL(10,4)` | — | No | Target contract-compliance rate stored as a decimal proportion. |
| `status` | `VARCHAR(10)` | — | No | Current master/record status. |

---

## 7. `bom`

**Purpose:** Bill of materials linking manufactured parent products to required components.  
**Grain:** One row per parent-product/component-product relationship.  
**Business key:** `parent_product_id, component_product_id`  
**Rows:** 145  
**Source note:** Used to model material requirements for manufactured products.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `parent_product_id` | `VARCHAR(12)` | CK/FK → products.product_id | No | Manufactured/parent product identifier in the bill of materials. |
| `component_product_id` | `VARCHAR(12)` | CK/FK → products.product_id | No | Component product identifier required by the parent product. |
| `quantity_per_parent` | `DECIMAL(18,4)` | — | No | Quantity of the component required to produce one parent unit. |
| `uom` | `VARCHAR(10)` | — | No | Unit of measure, e.g. EA, KG or L. |

---

## 8. `fx_rates`

**Purpose:** Foreign-exchange rates used to translate transaction currencies into AUD.  
**Grain:** One row per rate date and currency.  
**Business key:** `rate_date, currency`  
**Rows:** 312  
**Source note:** AUD per one unit of the source currency.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `rate_date` | `DATE` | CK | No | Date to which the FX rate applies. |
| `currency` | `VARCHAR(10)` | CK | No | ISO-style transaction/contract currency code. |
| `aud_per_currency` | `DECIMAL(10,4)` | — | No | AUD value of one unit of the stated foreign currency. |

---

## 9. `demand_forecast`

**Purpose:** Monthly product demand forecasts by site and forecast version.  
**Grain:** One row per month, warehouse, product and forecast version.  
**Business key:** `forecast_month, warehouse_id, product_id, forecast_version`  
**Rows:** 5,400  
**Source note:** Forecast versions should be analysed separately unless deliberately compared.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `forecast_month` | `DATE` | CK | No | Month represented by the forecast observation. |
| `warehouse_id` | `VARCHAR(12)` | CK/FK → warehouses.warehouse_id | No | Unique warehouse/site identifier. |
| `product_id` | `VARCHAR(12)` | CK/FK → products.product_id | No | Unique product identifier. |
| `forecast_qty` | `INT` | — | No | Forecast demand quantity. |
| `forecast_version` | `VARCHAR(10)` | CK | No | Forecast scenario/version such as Baseline or Consensus. |

---

## 10. `customer_orders`

**Purpose:** Customer sales-order header information.  
**Grain:** One row per sales order.  
**Business key:** `sales_order_id`  
**Rows:** 9,000  
**Source note:** Requested delivery date is nullable in the raw source.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `sales_order_id` | `VARCHAR(12)` | PK | No | Unique customer sales-order identifier. |
| `customer_id` | `VARCHAR(12)` | — | No | Customer identifier from the source system. |
| `customer_segment` | `VARCHAR(10)` | — | No | Customer segment/classification. |
| `warehouse_id` | `VARCHAR(12)` | FK → warehouses.warehouse_id | No | Unique warehouse/site identifier. |
| `order_date` | `DATE` | — | No | Date the customer order was placed. |
| `requested_delivery_date` | `DATE` | — | Yes | Customer-requested delivery date. |
| `order_status` | `VARCHAR(20)` | — | No | Current sales-order status. |
| `order_priority` | `VARCHAR(10)` | — | No | Business priority/classification of the order. |

---

## 11. `customer_order_lines`

**Purpose:** Product-level lines belonging to customer sales orders.  
**Grain:** One row per sales-order line.  
**Business key:** `sales_order_id, line_no`  
**Rows:** 27,073  
**Source note:** Raw source contains 20 exact duplicate rows; deduplicate before line-level aggregation.

> **Raw-data QA:** 20 exact duplicate row(s) are present in the supplied CSV and should be handled during transformation/QA.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `sales_order_id` | `VARCHAR(12)` | CK/FK → customer_orders.sales_order_id | No | Unique customer sales-order identifier. |
| `line_no` | `INT` | CK | No | Line number within the parent order/shipment. |
| `product_id` | `VARCHAR(12)` | FK → products.product_id | No | Unique product identifier. |
| `ordered_qty` | `INT` | — | No | Quantity ordered on the line. |
| `unit_sell_price_aud` | `DECIMAL(18,2)` | — | No | Sales price per unit in AUD before/subject to the recorded discount. |
| `discount_pct` | `DECIMAL(10,4)` | — | No | Discount percentage stored as a decimal proportion. |

---

## 12. `carriers`

**Purpose:** Carrier master data and target OTIF service levels.  
**Grain:** One row per carrier.  
**Business key:** `carrier_id`  
**Rows:** 12  
**Source note:** Used for logistics performance benchmarking.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `carrier_id` | `VARCHAR(12)` | PK | No | Unique carrier identifier. |
| `carrier_name` | `VARCHAR(30)` | — | No | Carrier business name. |
| `mode` | `VARCHAR(10)` | — | No | Transport mode associated with the carrier or shipment. |
| `target_otif_rate` | `DECIMAL(10,4)` | — | No | Target On-Time-In-Full rate stored as a decimal proportion. |

---

## 13. `shipments`

**Purpose:** Outbound shipment headers for delivered customer orders.  
**Grain:** One row per shipment.  
**Business key:** `shipment_id`  
**Rows:** 5,907  
**Source note:** Freight cost is stored at shipment grain and must not be multiplied by shipment-line joins.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `shipment_id` | `VARCHAR(12)` | PK | No | Unique outbound shipment identifier. |
| `sales_order_id` | `VARCHAR(12)` | FK → customer_orders.sales_order_id | No | Unique customer sales-order identifier. |
| `carrier_id` | `VARCHAR(12)` | FK → carriers.carrier_id | No | Unique carrier identifier. |
| `warehouse_id` | `VARCHAR(12)` | FK → warehouses.warehouse_id | No | Unique warehouse/site identifier. |
| `ship_date` | `DATE` | — | No | Date the shipment left the warehouse. |
| `actual_delivery_date` | `DATE` | — | No | Actual customer delivery date. |
| `requested_delivery_date` | `DATE` | — | No | Customer-requested delivery date. |
| `freight_cost_aud` | `DECIMAL(18,2)` | — | No | Freight cost recorded for the entire shipment in AUD. |
| `shipment_status` | `VARCHAR(10)` | — | No | Shipment lifecycle/status value. |
| `mode` | `VARCHAR(10)` | — | No | Transport mode associated with the carrier or shipment. |

---

## 14. `shipment_lines`

**Purpose:** Product quantities shipped within each outbound shipment.  
**Grain:** One row per shipment line.  
**Business key:** `shipment_id, line_no`  
**Rows:** 17,735  
**Source note:** Connects shipment headers back to sales-order lines and products.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `shipment_id` | `VARCHAR(12)` | CK/FK → shipments.shipment_id | No | Unique outbound shipment identifier. |
| `sales_order_id` | `VARCHAR(12)` | FK → customer_orders.sales_order_id | No | Unique customer sales-order identifier. |
| `line_no` | `INT` | CK | No | Line number within the parent order/shipment. |
| `product_id` | `VARCHAR(12)` | FK → products.product_id | No | Unique product identifier. |
| `shipped_qty` | `INT` | — | No | Quantity shipped on the shipment line. |

---

## 15. `purchase_orders`

**Purpose:** Purchase-order header information.  
**Grain:** One row per purchase order.  
**Business key:** `po_id`  
**Rows:** 6,500  
**Source note:** Contract ID is optional because not every PO is contract-linked.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `po_id` | `VARCHAR(12)` | PK | No | Unique purchase-order identifier. |
| `supplier_id` | `VARCHAR(12)` | FK → suppliers.supplier_id | No | Unique supplier identifier. |
| `warehouse_id` | `VARCHAR(12)` | FK → warehouses.warehouse_id | No | Unique warehouse/site identifier. |
| `po_date` | `DATE` | — | No | Purchase-order creation date. |
| `currency` | `VARCHAR(10)` | — | No | ISO-style transaction/contract currency code. |
| `po_status` | `VARCHAR(20)` | — | No | Purchase-order lifecycle/status value. |
| `contract_id` | `VARCHAR(12)` | FK → contracts.contract_id (nullable) | Yes | Unique supplier contract identifier. |
| `buyer` | `VARCHAR(10)` | — | No | Buyer/procurement owner responsible for the PO. |

---

## 16. `purchase_order_lines`

**Purpose:** Product-level lines on purchase orders.  
**Grain:** One row per PO line.  
**Business key:** `po_id, line_no`  
**Rows:** 22,737  
**Source note:** Unit price is denominated in the currency stored on the purchase-order header.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `po_id` | `VARCHAR(12)` | CK/FK → purchase_orders.po_id | No | Unique purchase-order identifier. |
| `line_no` | `INT` | CK | No | Line number within the parent order/shipment. |
| `product_id` | `VARCHAR(12)` | FK → products.product_id | No | Unique product identifier. |
| `ordered_qty` | `INT` | — | No | Quantity ordered on the line. |
| `unit_price` | `DECIMAL(18,2)` | — | Yes | Purchase price per unit in the PO currency. |
| `expected_delivery_date` | `DATE` | — | No | Expected supplier delivery date for the PO line. |
| `contract_compliant_flag` | `VARCHAR(10)` | — | No | Y/N indicator showing whether the line complied with applicable contract terms. |

---

## 17. `goods_receipts`

**Purpose:** Receiving transactions against purchase-order lines.  
**Grain:** One row per goods-receipt record.  
**Business key:** `receipt_id`  
**Rows:** 17,744  
**Source note:** Raw source contains 10 exact duplicate rows / duplicated receipt IDs; deduplicate during QA.

> **Raw-data QA:** 10 exact duplicate row(s) are present in the supplied CSV and should be handled during transformation/QA.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `receipt_id` | `VARCHAR(12)` | Intended PK; duplicates exist in raw source | No | Goods-receipt transaction identifier. |
| `po_id` | `VARCHAR(12)` | FK → purchase_orders.po_id | No | Unique purchase-order identifier. |
| `line_no` | `INT` | — | No | Line number within the parent order/shipment. |
| `product_id` | `VARCHAR(12)` | FK → products.product_id | No | Unique product identifier. |
| `receipt_date` | `DATE` | — | No | Date goods were received. |
| `received_qty` | `DECIMAL(18,2)` | — | Yes | Quantity physically received. |
| `rejected_qty` | `INT` | — | No | Quantity rejected at receipt. |
| `receipt_status` | `VARCHAR(10)` | — | No | Receiving status/classification. |

---

## 18. `inventory_snapshots`

**Purpose:** Periodic inventory-position snapshots by warehouse and product.  
**Grain:** One row per snapshot date, warehouse and product.  
**Business key:** `snapshot_date, warehouse_id, product_id`  
**Rows:** 42,900  
**Source note:** Raw source includes product code P9999, which is not present in the product master.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `snapshot_date` | `DATE` | CK | No | Date of the inventory snapshot. |
| `warehouse_id` | `VARCHAR(12)` | CK/FK → warehouses.warehouse_id | No | Unique warehouse/site identifier. |
| `product_id` | `VARCHAR(12)` | CK/FK → products.product_id | No | Unique product identifier. |
| `on_hand_qty` | `INT` | — | No | Physical on-hand inventory quantity. |
| `reserved_qty` | `INT` | — | No | Inventory quantity reserved/allocated to demand. |
| `inbound_qty` | `INT` | — | No | Inventory quantity expected inbound. |
| `last_movement_date` | `DATE` | — | No | Date of the most recent movement known at snapshot time. |
| `unit_cost_aud` | `DECIMAL(18,2)` | — | Yes | Inventory unit cost in AUD at snapshot time. |

---

## 19. `stock_movements`

**Purpose:** Signed inventory movements such as receipts, issues and transfers.  
**Grain:** One row per inventory movement.  
**Business key:** `movement_id`  
**Rows:** 18,000  
**Source note:** Negative quantity can be valid for outbound/issue movement types and should not be treated as an automatic error.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `movement_id` | `VARCHAR(12)` | PK | No | Unique stock-movement identifier. |
| `movement_date` | `DATE` | — | No | Date of the inventory movement. |
| `warehouse_id` | `VARCHAR(12)` | FK → warehouses.warehouse_id | No | Unique warehouse/site identifier. |
| `product_id` | `VARCHAR(12)` | FK → products.product_id | No | Unique product identifier. |
| `movement_type` | `VARCHAR(20)` | — | No | Movement classification such as transfer in/out, receipt or issue. |
| `quantity` | `INT` | — | No | Signed movement quantity; direction is represented by sign and movement type. |
| `reference_type` | `VARCHAR(20)` | — | No | Business-document/process type associated with the movement. |
| `reference_id` | `VARCHAR(12)` | — | No | Source/reference identifier associated with the movement. |

---

## 20. `production_orders`

**Purpose:** Manufacturing-order headers and planned/actual production quantities.  
**Grain:** One row per production order.  
**Business key:** `production_order_id`  
**Rows:** 1,800  
**Source note:** Production activity is concentrated at the manufacturing site.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `production_order_id` | `VARCHAR(12)` | PK | No | Unique manufacturing/production-order identifier. |
| `product_id` | `VARCHAR(12)` | FK → products.product_id | No | Unique product identifier. |
| `warehouse_id` | `VARCHAR(12)` | FK → warehouses.warehouse_id | No | Unique warehouse/site identifier. |
| `planned_start_date` | `DATE` | — | No | Planned production start date. |
| `actual_start_date` | `DATE` | — | No | Actual production start date. |
| `actual_finish_date` | `DATE` | — | No | Actual production completion date. |
| `planned_qty` | `INT` | — | No | Planned production quantity. |
| `actual_good_qty` | `INT` | — | No | Completed good-quality production quantity. |
| `scrap_qty` | `INT` | — | No | Quantity scrapped on the production order. |
| `status` | `VARCHAR(20)` | — | No | Current master/record status. |

---

## 21. `production_events`

**Purpose:** Operational production-step events linked to manufacturing orders.  
**Grain:** One row per production event.  
**Business key:** `event_id`  
**Rows:** 6,361  
**Source note:** Supports throughput, defects, runtime and process-step analysis.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `event_id` | `VARCHAR(12)` | PK | No | Unique production-event identifier. |
| `production_order_id` | `VARCHAR(12)` | FK → production_orders.production_order_id | No | Unique manufacturing/production-order identifier. |
| `event_date` | `DATE` | — | No | Date of the production event. |
| `process_step` | `VARCHAR(10)` | — | No | Manufacturing process step recorded for the event. |
| `processed_qty` | `INT` | — | No | Quantity processed during the event. |
| `defect_qty` | `INT` | — | No | Quantity identified as defective. |
| `runtime_minutes` | `INT` | — | No | Runtime duration in minutes. |

---

## 22. `downtime_events`

**Purpose:** Recorded production downtime events.  
**Grain:** One row per downtime event.  
**Business key:** `downtime_id`  
**Rows:** 948  
**Source note:** Supports downtime-frequency, duration and cause analysis.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `downtime_id` | `VARCHAR(12)` | PK | No | Unique downtime-event identifier. |
| `production_order_id` | `VARCHAR(12)` | FK → production_orders.production_order_id | No | Unique manufacturing/production-order identifier. |
| `event_date` | `DATE` | — | No | Date of the production event. |
| `downtime_reason` | `VARCHAR(20)` | — | No | Recorded reason/category for the downtime event. |
| `downtime_minutes` | `INT` | — | No | Downtime duration in minutes. |

---

## 23. `quality_inspections`

**Purpose:** Quality-inspection outcomes for supplier receipts and production.  
**Grain:** One row per inspection.  
**Business key:** `inspection_id`  
**Rows:** 10,000  
**Source note:** For Production inspections, product_id is null and product context is obtained through the referenced production event/order.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `inspection_id` | `VARCHAR(12)` | PK | No | Unique quality-inspection identifier. |
| `source_type` | `VARCHAR(20)` | — | No | Origin of the inspection, e.g. Supplier Receipt or Production. |
| `source_id` | `VARCHAR(12)` | Conditional FK → goods_receipts.receipt_id or production_events.event_id | No | Identifier of the inspected source record; references a goods receipt or production event depending on source_type. |
| `product_id` | `VARCHAR(12)` | FK → products.product_id (nullable) | Yes | Unique product identifier. |
| `inspection_date` | `DATE` | — | No | Date the inspection was performed. |
| `inspected_qty` | `INT` | — | No | Quantity inspected. |
| `defect_qty` | `INT` | — | No | Quantity identified as defective. |
| `inspection_result` | `VARCHAR(20)` | — | No | Inspection outcome such as Pass, Conditional or Fail. |
| `defect_type` | `VARCHAR(10)` | — | No | Recorded defect category. |

---

## 24. `returns`

**Purpose:** Customer return events linked to orders, shipments and products.  
**Grain:** One row per return event.  
**Business key:** `return_id`  
**Rows:** 1,039  
**Source note:** Supports return-rate, reason and disposition analysis.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `return_id` | `VARCHAR(12)` | PK | No | Unique customer-return identifier. |
| `sales_order_id` | `VARCHAR(12)` | FK → customer_orders.sales_order_id | No | Unique customer sales-order identifier. |
| `shipment_id` | `VARCHAR(12)` | FK → shipments.shipment_id | No | Unique outbound shipment identifier. |
| `product_id` | `VARCHAR(12)` | FK → products.product_id | No | Unique product identifier. |
| `return_date` | `DATE` | — | No | Date the return was recorded. |
| `return_qty` | `INT` | — | No | Quantity returned. |
| `return_reason` | `VARCHAR(30)` | — | No | Reason supplied for the return. |
| `disposition` | `VARCHAR(10)` | — | No | Planned handling/disposition of the returned goods. |

---

## 25. `warehouse_operations`

**Purpose:** Daily warehouse productivity and picking-quality metrics.  
**Grain:** One row per warehouse per operating date.  
**Business key:** `warehouse_ops_id`  
**Rows:** 2,184  
**Source note:** Supports labour productivity, throughput and pick-error analysis.

| Column | Suggested SQL Type | Key / Relationship | Nullable in Raw? | Business Definition |
|---|---|---|:---:|---|
| `warehouse_ops_id` | `VARCHAR(12)` | PK | No | Unique warehouse-operations record identifier. |
| `operation_date` | `DATE` | — | No | Operating date represented by the record. |
| `warehouse_id` | `VARCHAR(12)` | FK → warehouses.warehouse_id | No | Unique warehouse/site identifier. |
| `orders_processed` | `INT` | — | No | Number of customer orders processed. |
| `lines_picked` | `INT` | — | No | Number of order lines picked. |
| `lines_packed` | `INT` | — | No | Number of order lines packed. |
| `labour_hours` | `DECIMAL(18,4)` | — | No | Total labour hours recorded for the day/site. |
| `workers` | `INT` | — | No | Number of workers recorded. |
| `pick_errors` | `INT` | — | No | Number of picking errors recorded. |

---

## Raw-Data Quality Notes

These observations are documented because they directly affect ETL and reconciliation logic in the SCIS SQL project:

- `customer_order_lines` contains **20 exact duplicate rows**.
- `supplier_products` contains **12 exact duplicate rows**.
- `goods_receipts` contains **10 exact duplicate rows**, producing duplicated `receipt_id` values in the raw file.
- `inventory_snapshots` contains product code **`P9999`**, which does not exist in the supplied `products` master table.
- `customer_orders.requested_delivery_date` contains **6 null values**.
- `goods_receipts.received_qty` contains **6 null values**.
- `inventory_snapshots.unit_cost_aud` contains **10 null values**.
- `products.standard_cost_aud` contains **5 null values**.
- `purchase_order_lines.unit_price` contains **8 null values**.
- `purchase_orders.contract_id` is legitimately nullable because many POs are not linked to a contract.
- `quality_inspections.product_id` is null for production-sourced inspections; product context is obtained through the production relationship.
- `stock_movements.quantity` is signed; negative values can represent legitimate outbound/transfer activity.

---

## Analytical Grain Rules

1. **Do not sum shipment-level freight after joining to `shipment_lines`** unless freight is first protected at shipment grain.
2. **Do not treat repeated PO or sales-order IDs in line tables as duplicates**; header-to-line relationships are one-to-many.
3. **Deduplicate the three raw files containing exact duplicate records before aggregation** or explicitly account for them in reconciliation.
4. **Keep forecast versions separate** when measuring forecast error unless the business question explicitly compares versions.
5. **Respect transaction currency** for procurement values; convert with `fx_rates` before combining unlike currencies.
6. **Treat `source_id` in `quality_inspections` conditionally** based on `source_type` rather than joining it blindly to one table.
7. **Validate master-data relationships** before calculating KPIs, especially the `P9999` inventory exception.

---

## Repository Placement

Recommended path:

```text
SCIS-Supply-Chain-Intelligence-System/
├── README.md
├── SCIS_Supply_Chain_Analysis.sql
├── data/
└── docs/
    └── data_dictionary.md
```

---

*Prepared from the supplied SCIS source CSV files and aligned to the project’s SQL Server analytical workflow.*
