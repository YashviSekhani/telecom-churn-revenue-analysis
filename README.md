# 📊 Telecom Customer Churn & Revenue Leakage Analysis


## Overview
Customer churn is a major revenue risk for telecom companies, often driven by contract structure, customer tenure, and service behavior.  
This project analyzes customer churn patterns, quantifies revenue at risk, and identifies actionable retention opportunities using an end-to-end analytics pipeline.

The project is designed to mirror a real-world analytics workflow, from raw data ingestion to executive-level dashboards.


## Business Problem
Telecom companies lose significant recurring revenue due to customer churn, but often lack clarity on:

- What factors are driving churn
- Which customer segments contribute most to revenue loss
- Where retention efforts should be prioritized

The objective of this project is to:
- Identify key churn drivers
- Quantify monthly revenue at risk
- Highlight high-impact customer segments and regions
- Provide data-driven recommendations for retention strategies


## Data Architecture
The project follows a layered data architecture similar to a production data warehouse:

- **Raw Layer**
  - Original dataset split into logical raw tables
  - Minimal transformation

- **Staging Layer**
  - Data cleaning, normalization, and type standardization
  - Business-friendly column naming

- **Analytics Layer**
  - Fact and dimension tables modeled using a star schema
  - Optimized for analytical queries and BI consumption

This separation ensures data quality, scalability, and clear analytical logic.


## ETL Process
The ETL pipeline is implemented using a combination of Python and SQL:

1. **Extraction**
   - Source dataset ingested and split into logical raw tables using Python

2. **Transformation**
   - Data cleaned and standardized in the staging layer using SQL
   - Business features engineered (tenure groups, CLTV buckets, inactivity flags)

3. **Load**
   - Curated fact and dimension tables loaded into the analytics layer
   - Analytics tables consumed directly by Power BI dashboards


## Dashboards
The Power BI report consists of four analytical views:

1. **Executive Overview**
   - Overall churn rate and revenue at risk
   - High-level business health metrics

2. **Churn Drivers**
   - Churn analysis by contract type, tenure, and payment method

3. **Revenue Leakage**
   - Revenue impact of churn across contract types and CLTV segments

4. **Regional Revenue Impact**
   - Identification of regions contributing most to revenue loss


## Tools & Technologies
- **Python (pandas)** – Data ingestion and preparation
- **SQL Server** – Data modeling, transformations, and analysis
- **Power BI** – Interactive dashboards and insights


## Repository Structure

telecom-churn-revenue-analysis/
├── sql/
│   ├── raw/
│   ├── staging/
│   ├── analytics/
│   └── analysis/
├── etl/
├── docs/
├── powerbi/
└── screenshots/





