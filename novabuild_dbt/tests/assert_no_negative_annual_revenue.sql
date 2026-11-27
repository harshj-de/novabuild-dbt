SELECT
    contractor_id,
    company_name,
    annual_revenue
FROM {{ref('dim_contractors')}}
WHERE annual_revenue < 0