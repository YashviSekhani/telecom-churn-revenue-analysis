/* =====================================================
   ENRICHMENT LOGIC
   Business-derived features for analytics & BI
   ===================================================== */

-- 1. Enrich customer with tenure group
ALTER TABLE analytics.dim_customer
ADD tenure_group VARCHAR(20);

UPDATE analytics.dim_customer
SET tenure_group =
    CASE
        WHEN tenure_months < 6 THEN '0–6 months'
        WHEN tenure_months < 12 THEN '6–12 months'
        WHEN tenure_months < 24 THEN '1–2 years'
        ELSE '2+ years'
    END;


-- 2. Enrich churn fact with revenue at risk
-- (explicit enrichment instead of inline calc)

ALTER TABLE analytics.fact_customer_churn
ADD revenue_at_risk FLOAT;

UPDATE analytics.fact_customer_churn
SET revenue_at_risk =
    CASE
        WHEN churn_value = 1 THEN monthly_charges
        ELSE 0
    END;


-- 3. Synthetic month dimension already created earlier
-- This enrichment uses it to simulate behavioral signals

-- 4. Enriched inactivity flag (derived behavior)

-- Drop if re-running
IF OBJECT_ID('analytics.fact_inactivity', 'U') IS NOT NULL
    DROP TABLE analytics.fact_inactivity;

SELECT
    customer_id,
    AVG(data_used_gb) AS avg_data_last_2_months,
    CASE
        WHEN AVG(data_used_gb) < 2 THEN 1
        ELSE 0
    END AS is_inactive
INTO analytics.fact_inactivity
FROM analytics.fact_monthly_usage
WHERE month_id IN (5,6)
GROUP BY customer_id;
