# Material Purchase & Planning BI System (CompanyX)

End-to-end **BI + Data Warehouse + ML** project for material purchasing and planning:

- **DW & ETL:** SQL Server + SSIS (incremental, near real-time)  
- **Analytics:** Prophet (demand forecasting) + Random Forest (vendor scoring)  
- **BI:** Power BI dashboard for inventory, spend, and supplier performance  

---

## 1) Visual overview

### a) System architecture

![System architecture](images/system-architecture.png)

- Data sources: AdventureWorks sample OLTP database  
- ETL: SSIS → Data Warehouse (Star Schema)  
- Analytics: Python (Prophet, Random Forest) exporting CSV outputs  
- BI: Power BI reading from DW + forecast CSVs  

### b) Star Schema (DW)

![Star schema](images/star-schema.png)

- Fact: `FactMaterial` (OrderQty, ReceivedQty, Cost, TotalDue, etc.)  
- Dimensions: `DimProduct`, `DimVendor`, `DimDate`, `DimShipMethod`  
- Bridge: `ProductVendor` (price, lead time, min/max order, and other terms)  

### c) Power BI dashboard

![Power BI Dashboard](images/bi-dashboard.png)

- Inventory status (Safe / Warning / Emergency)  
- Historical purchases and 6‑month demand forecast  
- Recommended vendors based on cost, lead time, and rating  

---

## 2) What this project demonstrates (for CV)

- **Data engineering:** Star Schema design, incremental SSIS ETL, near real-time job scheduling.  
- **Data science:** time-series demand forecasting with Prophet, vendor scoring with Random Forest.  
- **BI & storytelling:** Power BI dashboard for purchasing, inventory health, and supplier performance.  

---

## 3) Quick start

### ML notebooks

```bash
pip install pandas scikit-learn prophet matplotlib
```

Run in order:

- `System Resources/ML/Vendor Selection/Random_Forest_Regression.ipynb`  
- `System Resources/ML/Monthly Demand Forecast/Time_Series_Forecasting_(Prophet).ipynb`  

### Power BI

- Open `System Resources/BI Visualization/MPP_BI Dashboard.pbix`  
- Update SQL Server / Data Warehouse connections if needed  

---

## 4) Repository structure (short)

```text
Team10/
├── README.md
├── Report/                      # Technical report (PDF)
├── images/                      # Architecture, schema, dashboard screenshots
└── System Resources/
    ├── BI Visualization/        # Power BI file (.pbix)
    ├── Data Warehouse Design/   # DW design artifacts
    ├── ETL pineline/            # SSIS packages & config
    └── ML/                      # Prophet + Random Forest + CSV
```

---

## 5) Contributors

- **Pham Duc Manh** (10422047@student.vgu.edu.vn)  
- **Nguyen Thao Vy** (10421067@student.vgu.edu.vn)  
- **Luong Tieu Cuong** (104220889@student.vgu.edu.vn)  
- **Nguyen Thien Nguyen** (10422059@student.vgu.edu.vn)  
- **Nguyen Hoang Yen Ngoc** (10422056@student.vgu.edu.vn)  
