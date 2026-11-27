{{ config(materialized='table') }}

WITH claims AS (
    SELECT * FROM {{ ref('stg_claims') }}
)

SELECT
    -- keys
    claim_id,
    claim_number,
    policy_id,
    program_id,
    project_id,
    carrier_id,

    -- dates
    loss_date,
    report_date,
    created_at,
    DATEDIFF(day, loss_date, report_date) AS report_lag_days,

    -- categories
    claim_type,
    coverage_line,
    claimant_type,
    claim_status,
    litigation,
    subrogation_potential,

    -- measures
    reserves,
    incurred_loss
FROM claims