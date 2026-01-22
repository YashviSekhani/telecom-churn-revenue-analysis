-- Customer Dimension
SELECT
    c.customer_id,
    c.gender,
    c.senior_citizen,
    c.has_partner,
    c.has_dependents,
    c.tenure_months,
    l.country,
    l.state,
    l.city,
    l.zip_code,
    l.latitude,
    l.longitude
INTO analytics.dim_customer
FROM staging.staging_customers c
LEFT JOIN staging.staging_location l
ON c.customer_id = l.customer_id;

ALTER TABLE analytics.dim_customer
ADD CONSTRAINT pk_dim_customer PRIMARY KEY (customer_id);


-- Contract Dimension
SELECT
    customer_id,
    contract_type,
    payment_method,
    paperless_billing
INTO analytics.dim_contract
FROM staging.staging_contracts;

ALTER TABLE analytics.dim_contract
ADD CONSTRAINT pk_dim_contract PRIMARY KEY (customer_id);


-- Services Dimension
SELECT
    customer_id,
    phone_service,
    internet_service,
    multiple_lines,
    online_security,
    online_backup,
    device_protection,
    tech_support,
    streaming_tv,
    streaming_movies
INTO analytics.dim_services
FROM staging.staging_services;

ALTER TABLE analytics.dim_services
ADD CONSTRAINT pk_dim_services PRIMARY KEY (customer_id);


-- Month Dimension (synthetic)
CREATE TABLE analytics.dim_month (
    month_id INT PRIMARY KEY,
    month_label VARCHAR(20)
);

INSERT INTO analytics.dim_month VALUES
(1, 'M-6'), (2, 'M-5'), (3, 'M-4'),
(4, 'M-3'), (5, 'M-2'), (6, 'M-1');