WITH contractors AS (
    SELECT * FROM {{ ref('stg_contractors') }}
),
trades AS (
    SELECT * FROM {{ ref('contractor_trade_reference') }}
)
SELECT
    c.contractor_id,
    c.company_name,
    c.trade,
    c.state,
    c.license_number,
    c.contact_name,
    c.employees_count,
    c.years_in_business,
    c.annual_revenue,
    c.emr,
    c.tier,
    c.created_at,
    t.trade_code,
    t.trade_category,
    t.risk_class
FROM contractors c
LEFT JOIN trades t
    ON c.trade = t.trade