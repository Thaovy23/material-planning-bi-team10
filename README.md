# Material Purchase & Planning BI System (CompanyX)

An end-to-end **Business Intelligence + Data Warehouse** project that centralizes procurement, inventory, and supplier data from ERP/MRP tables into a **Star Schema**, supports **incremental + near real-time loading** via SSIS, and applies **forecasting + vendor-scoring models** to improve purchasing decisions.

---

## 1) Business context & problem

CompanyX manufactures precision bicycle components. Their purchasing/planning process suffered from:

- **Inventory imbalance:** overstock of low-demand items while stockouts occur for high-demand parts (e.g., bearings, crankarms).
- **Fragmented data** across departments (Purchasing/Planning/Production), causing poor visibility.
- **Heavy reliance on manual forecasting**, increasing error and failing to model seasonality/variability.
- **Lack of standardized supplier performance tracking**, leading to inconsistent lead times and unstable vendor management.

The decision gap can be summarized into two operational questions:

1. **When to order (timing)** — to prevent stockouts without inducing overstocking  
2. **Who to order from (vendor selection)** — to optimize cost + delivery performance  

---

## 2) Project objectives & success metrics

This project implements a data-driven **Material Purchase & Planning** system with goals:

- Automated **demand forecasting** to reduce imbalances caused by manual planning  
- **Centralized analytics (dashboard)** to break data silos and enable monitoring of Purchasing/Inventory/Supplier KPIs  
- **Formalized supplier tracking** using lead time + cost metrics to strengthen reliability  
- More **optimal purchasing strategy** balancing cost/quality/availability  

**Target success metrics:** +15% inventory turnover, ≥90% material availability, -20% procurement cycle time, and 5–10% annual spend reduction.

---

## 3) Data sources (ERP tables) & analytical domains

The dataset is extracted from the operational ERP platform and grouped into four domains:

### Supplier & procurement master data

- `Purchasing.Vendor`  
- `Purchasing.ProductVendor` (product–vendor bridge, pricing/lead time terms)  
- `Purchasing.ShipMethod`  

### Transactional purchasing data

- `Purchasing.PurchaseOrderHeader`  
- `Purchasing.PurchaseOrderDetail`  

### Product & structural data (BOM)

- `Production.Product`  
- `Production.BillOfMaterials` (maps finished goods → required components; enables inferred material demand signals)  

### Inventory data

- `Production.ProductInventory`  

---

## 4) Data Warehouse design (Star Schema)

The warehouse follows **dimensional modeling** with a **Star Schema** to support fast querying, flexible reporting, and time-series analysis.

### Core idea

- One central **Fact** table capturing measurable purchasing events (quantities, prices, totals).  
- Surrounding **Dimensions** providing descriptive context: product, vendor, shipping, date.  
- A **bridge table** for product–vendor commercial terms (lead time, negotiated price, order constraints).  

### Fact table: `FactMaterial`

- **Keys:** `ProductKey`, `VendorKey`, `ShipMethodKey`, `OrderDateKey`, `DueDateKey`, `ShipDateKey`  
- **Measures:** `OrderQty`, `ReceivedQty`, `RejectedQty`, `StockedQty`, `UnitPrice`, `LineTotal`, `SubTotal`, `TaxAmt`, `Freight`, `TotalDue`, `ModifiedDate`  

### Dimensions

- **`DimProduct`:** product catalog + planning parameters (`SafetyStockLevel`, `ReorderPoint`, `StandardCost`, current `Quantity`, active flag).  
- **`DimVendor`:** vendor master + performance indicators (`CreditRating`, `PreferredVendorStatus`).  
- **`DimShipMethod`:** shipping providers and costs (`ShipBase`, `ShipRate`).  
- **`DimDate`:** calendar + fiscal hierarchy + holiday/weekend flags (supports time slicing and forecasting).  

### Bridge table

- **`ProductVendor`:** links materials to suppliers; captures vendor-specific terms: `AverageLeadTime`, `StandardPrice`, `MinOrderQty`, `MaxOrderQty`, etc.  

---

## 5) ETL pipeline (SSIS): incremental + near real-time

The ETL pipeline is implemented using **SQL Server Integration Services (SSIS)** and supports:

- **Initial load**  
- **Incremental updates** using `ModifiedDate` and `LastLoadDate` variables  
- **Near real-time refresh** via scheduling  

### Extraction strategy highlights

- **DimProduct:** joins `Product`, `ProductSubcategory`, `ProductCategory`, `ProductInventory`; aggregates inventory quantity; derives `IsActive` from `SellEndDate`.  
- **DimVendor:** direct select from `Purchasing.Vendor`.  
- **DimShipMethod:** direct select from `Purchasing.ShipMethod`.  
- **DimDate:** generated in SSIS Script Component; builds `DateKey` and calendar/fiscal attributes.  
- **FactMaterial:** joins `PurchaseOrderHeader` + `PurchaseOrderDetail` (+ vendor link) to capture the full purchasing lifecycle.  

### Transformation & loading

- Cleansing, surrogate key management, dimensional conformance, historical tracking (SCD patterns), and performance optimization (caching/lookups).  
- **Surrogate key resolution:** `ProductID → ProductKey`, `BusinessEntityID → VendorKey`, `ShipMethodID → ShipMethodKey`, date values → `DateKey`.  
- **Incremental logic:** Conditional Split on `ModifiedDate > LastLoadDate`; Lookup for Insert vs Update.  
- **Scheduling:** SQL Server Agent Job runs the SSIS package (e.g., every 15–30 minutes) for near real-time sync.  

---

## 6) Analytics layer (Python / Colab)

Two models support purchasing decisions:

### 6.1 Demand forecasting (Prophet)

- **Goal:** forecast monthly demand quantity per product for the next six months.  
- **Implementation:** Python (Google Colab), Prophet; log-transform (`log1p`) and inverse (`expm1`); negative predictions clipped to zero.  
- **Output columns:** `ForecastMonth`, `PredictedDemandQty`, `LowerBound`, `UpperBound`.  

### 6.2 Vendor selection (Random Forest Regression)

- **Goal:** predict a composite vendor score to recommend the best supplier.  
- **Features:** `AverageCost` (avg of StandardPrice and LastReceiptCost), `AverageLeadTime`, `CreditRating` (1–5), `PreferredVendorStatus`, `ActiveFlag`.  
- Inactive vendors are excluded so recommendations consider only currently capable suppliers.  

---

## 7) BI dashboard (Power BI)

The BI system is implemented in **Power BI Desktop**:

- **DirectQuery** to SQL Server DW tables: `DimProduct`, `DimVendor`, `DimShipMethod`, `DimDate`, `ProductVendor`, `FactMaterial`.  
- **Forecast CSV** (`Forecast_ProductDemand.csv`) for predicted demand.  

### Inventory status logic

- **Safe:** `Quantity ≥ SafetyStockLevel`  
- **Warning:** `ReorderPoint < Quantity < SafetyStockLevel`  
- **Emergency:** `Quantity ≤ ReorderPoint`  

### Example dashboard components

- Inventory list slicer by product name  
- Historical order quantity trend  
- Predicted demand (6-month horizon from forecast CSV)  
- Suggested vendor table (e.g., from `BestVendors.csv`)  

---

## 8) Case study: preventing a stockout (Adjustable Race)

A documented use-case shows how the system shifts CompanyX from **reactive purchasing** to **proactive planning** by preventing a potential stockout for **Adjustable Race** components:

1. **Dashboard** flags inventory below reorder point → triggers action before crisis.  
2. **Prophet** analyzes monthly demand patterns and seasonality; accounts for usable inventory (rejected quantity logic).  
3. **Random Forest** evaluates active vendors (cost, lead time, credit rating, preferred status) to recommend the optimal supplier.  
4. **Final decision** combines forecast + lead-time buffer and timing analysis for order timing with safety margins and cost trade-offs.  

---

## 9) How to run (repo-agnostic checklist)

1. **Database setup** — Restore/create SQL Server databases (source + DW); create DW schema (dimensions, fact, bridge).  
2. **SSIS ETL** — Open SSIS solution in Visual Studio/SSDT; update connection managers; set `LastLoadDate_*` for incremental loads; run initial then incremental.  
3. **Scheduling** — Create SQL Server Agent Job to run the ETL package (e.g., every 15 minutes).  
4. **Analytics** — Run Prophet forecasting and Random Forest vendor scoring in Python/Colab; export forecast + best vendors to CSV.  
5. **Power BI** — Connect to DW (DirectQuery); load forecast CSVs; refresh and validate relationships.  

---

## Repository structure

```text
Team10/
├── README.md
├── Report/                          # Technical report (PDF)
└── System Resources/
    ├── BI Visualization/           # Power BI dashboard (.pbix)
    ├── Data Warehouse Design/      # DW design artifacts
    ├── ETL pineline/               # SSIS packages & config
    ├── Image ETL/                  # ETL screenshots
    └── ML/
        ├── Vendor Selection/       # Random Forest, vendorList, BestVendors
        └── Monthly Demand Forecast/ # Prophet, MonthlyProductDemand, forecast CSV
```

### Quick run (ML only)

```bash
pip install pandas scikit-learn prophet matplotlib
```

Then open and run:

- `System Resources/ML/Vendor Selection/Random_Forest_Regression.ipynb`  
- `System Resources/ML/Monthly Demand Forecast/Time_Series_Forecasting_(Prophet).ipynb`  

---

## Tech stack

| Layer        | Technologies                          |
|-------------|----------------------------------------|
| Data source | SQL Server (ERP/MRP tables)           |
| DW & ETL    | SQL Server, SSIS (incremental, near real-time) |
| Analytics   | Python, Pandas, Prophet, scikit-learn |
| BI          | Power BI Desktop (DirectQuery + CSV) |

---

## Contributors

- **Pham Duc Manh** (10422047)  
- **Nguyen Thao Vy** (10421067)  
- **Luong Tieu Cuong** (104220889)  
- **Nguyen Thien Nguyen** (10422059)  
- **Nguyen Hoang Yen Ngoc** (10422056)  
