-- Customers
SELECT 
    customer_id,
    gender,
    senior_citizen,
    partner AS has_partner,
    dependents AS has_dependents,
    tenure_months
INTO staging.staging_customers
FROM raw.raw_customers;


-- Contracts
SELECT
    customer_id,
    contract_type,
    paperless_billing,
    payment_method,
    monthly_charges,
    total_charges
INTO staging.staging_contracts
FROM raw.raw_contracts;


-- Services
SELECT
    customer_id,
    CASE WHEN phone_service = 'Yes' THEN 1 ELSE 0 END AS phone_service,
    CASE WHEN multiple_lines = 'Yes' THEN 1 WHEN multiple_lines = 'No' THEN 0 ELSE NULL END AS multiple_lines,
    internet_service,
    CASE WHEN online_security = 'Yes' THEN 1 WHEN online_security = 'No' THEN 0 ELSE NULL END AS online_security,
    CASE WHEN online_backup = 'Yes' THEN 1 WHEN online_backup = 'No' THEN 0 ELSE NULL END AS online_backup,
    CASE WHEN device_protection = 'Yes' THEN 1 WHEN device_protection = 'No' THEN 0 ELSE NULL END AS device_protection,
    CASE WHEN tech_support = 'Yes' THEN 1 WHEN tech_support = 'No' THEN 0 ELSE NULL END AS tech_support,
    CASE WHEN streaming_tv = 'Yes' THEN 1 WHEN streaming_tv = 'No' THEN 0 ELSE NULL END AS streaming_tv,
    CASE WHEN streaming_movies = 'Yes' THEN 1 WHEN streaming_movies = 'No' THEN 0 ELSE NULL END AS streaming_movies
INTO staging.staging_services
FROM raw.raw_services;


-- Churn
SELECT
    customer_id,
    churn_label,
    churn_value,
    churn_score,
    cltv,
    churn_reason
INTO staging.staging_churn
FROM raw.raw_churn;


-- Location
SELECT
    customer_id,
    TRIM(country) AS country,
    TRIM(state) AS state,
    TRIM(city) AS city,
    TRIM(zip_code) AS zip_code,
    latitude,
    longitude
INTO staging.staging_location
FROM raw.raw_location;