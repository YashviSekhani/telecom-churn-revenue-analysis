# Data Dictionary

This document describes the fact and dimension tables used in the analytics layer.

---

## Fact Tables

### fact_customer_churn
| Column Name | Description |
|------------|-------------|
| customer_id | Unique identifier for each customer |
| churn_value | Churn indicator (1 = churned, 0 = retained) |
| churn_score | Model-based churn risk score |
| monthly_charges | Monthly subscription charges |
| revenue_at_risk | Monthly revenue lost due to churn |
| cltv | Customer lifetime value |

---

## Dimension Tables

### dim_customer
| Column Name | Description |
|------------|-------------|
| customer_id | Unique customer identifier |
| gender | Customer gender |
| senior_citizen | Senior citizen flag |
| tenure_months | Customer tenure in months |
| tenure_group | Binned tenure category |

---

### dim_contract
| Column Name | Description |
|------------|-------------|
| customer_id | Unique customer identifier |
| contract_type | Contract duration/type |
| payment_method | Payment method |
| paperless_billing | Paperless billing flag |

---

### dim_services
| Column Name | Description |
|------------|-------------|
| customer_id | Unique customer identifier |
| internet_service | Type of internet service |
| streaming_tv | Streaming TV subscription |
| streaming_movies | Streaming movies subscription |
| tech_support | Technical support subscription |

---

### dim_location
| Column Name | Description |
|------------|-------------|
| customer_id | Unique customer identifier |
| city | Customer city |
| state | Customer state |
