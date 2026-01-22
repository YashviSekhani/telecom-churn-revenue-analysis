-- Customer Churn Fact
SELECT
    c.customer_id,
    ch.churn_value,
    ch.churn_label,
    ch.churn_score,
    ch.cltv,
    ct.monthly_charges,
    (ct.monthly_charges * ch.churn_value) AS revenue_at_risk
INTO analytics.fact_customer_churn
FROM staging.staging_customers c
JOIN staging.staging_churn ch ON c.customer_id = ch.customer_id
JOIN staging.staging_contracts ct ON c.customer_id = ct.customer_id;

ALTER TABLE analytics.fact_customer_churn
ADD CONSTRAINT pk_fact_customer_churn PRIMARY KEY (customer_id);


-- Monthly Usage Fact (synthetic)
SELECT
    s.customer_id,
    m.month_id,
    CASE 
        WHEN s.internet_service = 'No' THEN NULL
        WHEN ch.churn_value = 1 AND m.month_id >= 5
            THEN ROUND(RAND(CHECKSUM(NEWID())) * 5, 2)
        ELSE ROUND(10 + RAND(CHECKSUM(NEWID())) * 30, 2)
    END AS data_used_gb,
    CASE 
        WHEN s.phone_service = 0 THEN NULL
        WHEN ch.churn_value = 1 AND m.month_id >= 5
            THEN ROUND(RAND(CHECKSUM(NEWID())) * 50, 0)
        ELSE ROUND(100 + RAND(CHECKSUM(NEWID())) * 400, 0)
    END AS call_minutes
INTO analytics.fact_monthly_usage
FROM analytics.dim_services s
CROSS JOIN analytics.dim_month m
JOIN analytics.fact_customer_churn ch
ON s.customer_id = ch.customer_id;


-- Inactivity Fact
SELECT
    customer_id,
    AVG(data_used_gb) AS avg_data_last_2_months,
    CASE WHEN AVG(data_used_gb) < 2 THEN 1 ELSE 0 END AS is_inactive
INTO analytics.fact_inactivity
FROM analytics.fact_monthly_usage
WHERE month_id IN (5,6)
GROUP BY customer_id;