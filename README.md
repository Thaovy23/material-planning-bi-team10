# Team10 - CTCS ML Project

Machine Learning mini-project for Supply Chain analytics, including:
- Vendor selection using Random Forest Regression
- Monthly product demand forecasting using Prophet

This repository is prepared for portfolio/CV submission.

## Project Structure

```text
System Resources/
  ML/
    Vendor Selection/
      Datamining.sql
      vendorList.csv
      Random_Forest_Regression.ipynb
      BestVendors.csv
    Monthly Demand Forecast/
      datamining1.sql
      MonthlyProductDemand.csv
      Time_Series_Forecasting_(Prophet).ipynb
      Forecast_ProductDemand.csv
```

## Problem Statements

### 1) Vendor Selection
- Goal: identify the most suitable vendor by balancing cost and supplier quality indicators.
- Input data: `vendorList.csv` generated from `Datamining.sql`.
- Main features: `CreditRating`, `PreferredVendorStatus`, `ActiveFlag`, `AverageLeadTime`, `StandardPrice`, `LastReceiptCost`, `AvgCost`.
- Output: ranked vendors / best-vendor candidates in `BestVendors.csv`.

### 2) Monthly Demand Forecast
- Goal: forecast product demand to support inventory planning.
- Input data: `MonthlyProductDemand.csv` generated from `datamining1.sql`.
- Model: Prophet time-series forecasting.
- Output: forecast results in `Forecast_ProductDemand.csv`.

## Tech Stack
- Python (Jupyter Notebook)
- Pandas
- scikit-learn (Random Forest)
- Prophet
- SQL

## How To Run

1. Open notebooks:
   - `System Resources/ML/Vendor Selection/Random_Forest_Regression.ipynb`
   - `System Resources/ML/Monthly Demand Forecast/Time_Series_Forecasting_(Prophet).ipynb`
2. Make sure datasets are in the same folder as each notebook.
3. Install required packages:

```bash
pip install pandas scikit-learn prophet matplotlib
```

4. Run all notebook cells in order.

## Key Deliverables
- SQL scripts for data extraction and feature preparation
- Clean CSV datasets for ML workflow
- Notebook-based model training and forecasting
- Exported prediction outputs for reporting

## Portfolio Notes (CV)
- End-to-end pipeline from SQL data extraction to ML prediction outputs
- Practical application of regression and time-series forecasting
- Focus on real-world supply chain decision support:
  - Vendor optimization
  - Demand planning

## Authors
- Team10

