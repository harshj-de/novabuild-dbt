WITH source AS (
    SELECT * FROM {{ source('novabuild', 'contractors')}}
)
SELECT
    contractor_id,
    trade, 
    state, 
    license_number, 
    contact_name,
    LOWER(TRIM(company_name)) AS company_name,
    employees_count,
    years_in_business,
    contact_email,
    contact_phone,
    annual_revenue :: NUMBER(15,2) AS annual_revenue,
    emr :: NUMBER(4,2) AS emr,
    tier,
    TRY_TO_DATE(created_at) AS created_at

FROM source