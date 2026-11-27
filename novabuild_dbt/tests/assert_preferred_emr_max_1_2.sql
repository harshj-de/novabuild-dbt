{{ config(warn_if='>0', error_if='>200') }}
SELECT
    contractor_id,
    company_name, 
    tier, 
    emr
FROM {{ ref('dim_contractors') }}
WHERE tier = 'Preferred' AND emr > 1.2