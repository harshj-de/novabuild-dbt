{{
    config(
        materialized = 'incremental',
        incremental_strategy = 'merge',
        unique_key = 'verification_id',
        on_schema_change = 'fail'
    )
}}
WITH verifications AS (
    SELECT * FROM {{ ref('stg_coi_verifications') }}
)
SELECT
    verification_id,
    certificate_id,
    contractor_id,
    project_id,
    verification_date,
    verified_by,
    verification_result,
    gl_compliant,
    wc_compliant,
    auto_compliant,
    umbrella_compliant,
    deficiency_notes,
    review_time_minutes,
    follow_up_required,
    resolved_date,
    DATEDIFF(day, verification_date, resolved_date) AS days_to_resolve,
    created_at
FROM verifications
{% if is_incremental() %}
WHERE created_at > (SELECT MAX(created_at) FROM {{ this }})
{% endif %}