WITH source AS (
    SELECT * FROM {{ source('novabuild', 'projects')}}
)

SELECT
    project_id,
    project_name,
    project_type,
    sponsor_id,
    broker_id,
    state,
    city,
    TRY_TO_DATE(start_date)              AS start_date,
    TRY_TO_DATE(projected_end_date)      AS projected_end_date,
    TRY_TO_DATE(actual_end_date)         AS actual_end_date,
    total_insured_value::NUMBER(15,2)    AS total_insured_value,
    contract_value::NUMBER(15,2)         AS contract_value,
    status                               AS project_status,
    wrap_type,
    TRY_TO_DATE(created_at)              AS created_at
FROM source