-- Overall churn rate
SELECT
    COUNT(*) AS total_customers,
    SUM(churn_value) AS churned_customers,
    ROUND(100.0 * SUM(churn_value) / COUNT(*), 2) AS churn_rate_pct
FROM analytics.fact_customer_churn;


-- Total revenue at risk
SELECT
    ROUND(SUM(revenue_at_risk), 2) AS total_revenue_at_risk
FROM analytics.fact_customer_churn;


-- Churn & revenue by contract type
SELECT
    d.contract_type,
    COUNT(*) AS customers,
    SUM(f.churn_value) AS churned_customers,
    ROUND(100.0 * SUM(f.churn_value) / COUNT(*), 2) AS churn_rate_pct,
    ROUND(SUM(f.revenue_at_risk), 2) AS revenue_at_risk
FROM analytics.fact_customer_churn f
JOIN analytics.dim_contract d
ON f.customer_id = d.customer_id
GROUP BY d.contract_type
ORDER BY churn_rate_pct DESC;


-- Revenue bucket churn analysis
WITH ranked_customers AS (
    SELECT
        customer_id,
        monthly_charges,
        churn_value,
        NTILE(5) OVER (ORDER BY monthly_charges DESC) AS revenue_bucket
    FROM analytics.fact_customer_churn
)
SELECT
    revenue_bucket,
    COUNT(*) AS customers,
    SUM(churn_value) AS churned_customers,
    ROUND(100.0 * SUM(churn_value) / COUNT(*), 2) AS churn_rate_pct
FROM ranked_customers
GROUP BY revenue_bucket
ORDER BY revenue_bucket;


-- Tenure churn analysis
SELECT
    CASE
        WHEN tenure_months < 6 THEN '0–6 months'
        WHEN tenure_months < 12 THEN '6–12 months'
        WHEN tenure_months < 24 THEN '1–2 years'
        ELSE '2+ years'
    END AS tenure_group,
    COUNT(*) AS customers,
    SUM(churn_value) AS churned_customers,
    ROUND(100.0 * SUM(churn_value) / COUNT(*), 2) AS churn_rate_pct
FROM analytics.fact_customer_churn f
JOIN analytics.dim_customer c
ON f.customer_id = c.customer_id
GROUP BY
    CASE
        WHEN tenure_months < 6 THEN '0–6 months'
        WHEN tenure_months < 12 THEN '6–12 months'
        WHEN tenure_months < 24 THEN '1–2 years'
        ELSE '2+ years'
    END
ORDER BY churn_rate_pct DESC;


-- Churn by internet service
SELECT
    s.internet_service,
    COUNT(*) AS customers,
    SUM(f.churn_value) AS churned_customers,
    ROUND(100.0 * SUM(f.churn_value) / COUNT(*), 2) AS churn_rate_pct
FROM analytics.fact_customer_churn f
JOIN analytics.dim_services s
ON f.customer_id = s.customer_id
GROUP BY s.internet_service
ORDER BY churn_rate_pct DESC;


-- Inactivity vs churn
SELECT
    i.is_inactive,
    COUNT(*) AS customers,
    SUM(f.churn_value) AS churned_customers,
    ROUND(100.0 * SUM(f.churn_value) / COUNT(*), 2) AS churn_rate_pct
FROM analytics.fact_customer_churn f
JOIN analytics.fact_inactivity i
ON f.customer_id = i.customer_id
WHERE i.is_inactive IS NOT NULL
GROUP BY i.is_inactive;