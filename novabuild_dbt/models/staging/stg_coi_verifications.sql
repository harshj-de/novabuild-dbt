WITH source AS (
    SELECT * FROM {{ source('novabuild', 'coi_verifications') }}
)
SELECT
    verification_id,
    certificate_id,
    contractor_id,
    project_id,
    TRY_TO_DATE(verification_date)       AS verification_date,
    verified_by,
    result                               AS verification_result,
    gl_compliant,
    wc_compliant,
    auto_compliant,
    umbrella_compliant,
    deficiency_notes,
    review_time_minutes::NUMBER(10,2)    AS review_time_minutes,
    follow_up_required,
    TRY_TO_DATE(resolved_date)           AS resolved_date,
    TRY_TO_DATE(created_at)              AS created_at
FROM source