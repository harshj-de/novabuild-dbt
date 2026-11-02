WITH source AS (
    SELECT * FROM {{ source('novabuild', 'claims') }}
)
SELECT
    claim_id,
    claim_number,
    policy_id,
    program_id,
    project_id,
    carrier_id,
    TRY_TO_DATE(loss_date)            AS loss_date,
    TRY_TO_DATE(report_date)          AS report_date,
    claim_type,
    coverage_line,
    claimant_name,
    claimant_type,
    description,
    reserves::NUMBER(15,2)            AS reserves,
    incurred_loss::NUMBER(15,2)       AS incurred_loss,
    status                            AS claim_status,
    adjuster_name,
    litigation,
    subrogation_potential,
    TRY_TO_DATE(created_at)           AS created_at
FROM source