import pandas as pd

# =========================
# 1. LOAD DATASET
# =========================

file_path = r"C:\Users\yashv\OneDrive\Desktop\Data Analyst Project\archive\Telco_customer_churn.xlsx"

df = pd.read_excel(file_path)

print("Dataset loaded successfully")
print(f"Rows: {df.shape[0]}, Columns: {df.shape[1]}")

# =========================
# 2. STANDARDIZE COLUMN NAMES
# =========================

df.columns = (
    df.columns
      .str.strip()
      .str.lower()
      .str.replace(" ", "_")
)

print("\nStandardized column names:")
print(df.columns.tolist())

# =========================
# 3. CREATE RAW TABLES
# =========================

# ---- RAW CUSTOMERS (CRM) ----
raw_customers = df[[
    "customerid", "gender", "senior_citizen",
    "partner", "dependents", "tenure_months"
]].rename(columns={"customerid": "customer_id"})


# ---- RAW LOCATION ----
raw_location = df[[
    "customerid", "country", "state", "city",
    "zip_code", "latitude", "longitude"
]].rename(columns={"customerid": "customer_id"})


# ---- RAW SERVICES ----
raw_services = df[[
    "customerid", "phone_service", "multiple_lines",
    "internet_service", "online_security", "online_backup",
    "device_protection", "tech_support",
    "streaming_tv", "streaming_movies"
]].rename(columns={"customerid": "customer_id"})


# ---- RAW CONTRACTS / BILLING PROFILE ----
raw_contracts = df[[
    "customerid", "contract", "paperless_billing",
    "payment_method", "monthly_charges", "total_charges"
]].rename(columns={
    "customerid": "customer_id",
    "contract": "contract_type"
})


# ---- RAW CHURN & VALUE ----
raw_churn = df[[
    "customerid", "churn_label", "churn_value",
    "churn_score", "cltv", "churn_reason"
]].rename(columns={"customerid": "customer_id"})

print("\nRaw tables created")

# =========================
# 4. VALIDATION CHECKS
# =========================

# ---- Row count validation ----
assert len(df) == len(raw_customers)
assert len(df) == len(raw_location)
assert len(df) == len(raw_services)
assert len(df) == len(raw_contracts)
assert len(df) == len(raw_churn)

print("Row count validation passed")

# ---- Primary key uniqueness ----
tables = {
    "customers": raw_customers,
    "location": raw_location,
    "services": raw_services,
    "contracts": raw_contracts,
    "churn": raw_churn
}

for name, table in tables.items():
    assert table["customer_id"].is_unique, f"Duplicate customer_id in {name}"

print("Primary key uniqueness validation passed")

# ---- Null customer_id check ----
for name, table in tables.items():
    assert table["customer_id"].isnull().sum() == 0, f"Null customer_id in {name}"

print("Null customer_id validation passed")

# ---- Unique customer count consistency ----
original_count = df["customerid"].nunique()
for name, table in tables.items():
    assert table["customer_id"].nunique() == original_count, f"Customer mismatch in {name}"

print("Customer count consistency validation passed")

# =========================
# 5. EXPORT RAW CSV FILES
# =========================

raw_customers.to_csv("raw_customers.csv", index=False)
raw_location.to_csv("raw_location.csv", index=False)
raw_services.to_csv("raw_services.csv", index=False)
raw_contracts.to_csv("raw_contracts.csv", index=False)
raw_churn.to_csv("raw_churn.csv", index=False)

print("\nAll raw tables exported successfully")

# =========================
# 6. QUICK SANITY CHECK OUTPUT
# =========================

print("\nSample records:")
print(raw_customers.head(2))
print(raw_services.head(2))
print(raw_contracts.head(2))

print("\nSTEP 1 (DATASET SPLITTING) COMPLETED SUCCESSFULLY")