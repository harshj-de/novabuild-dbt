WITH source AS (
    SELECT * FROM {{ source('novabuild', 'safety_incidents') }}
)
SELECT
    incident_id,
    project_id,
    contractor_id,
    enrollment_id,
    TRY_TO_DATE(incident_date)   AS incident_date,
    incident_type,
    severity,
    injured_count,
    fatality_count,
    lost_days,
    description,
    root_cause,
    osha_recordable,
    osha_reported,
    corrective_action,
    TRY_TO_DATE(closed_date)     AS closed_date,
    TRY_TO_DATE(created_at)      AS created_at
FROM source