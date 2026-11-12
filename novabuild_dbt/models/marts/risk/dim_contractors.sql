WITH contractors AS (
    SELECT * FROM {{ ref('stg_contractors') }}
)
SELECT
    contractor_id,
    company_name,
    trade,
    state,
    license_number,
    contact_name,
    employees_count,
    years_in_business,
    annual_revenue,
    emr,
    tier,
    created_at
FROM contractors