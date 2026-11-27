WITH contractors AS (
    SELECT contractor_id, tier, emr
    FROM {{ ref('dim_contractors') }}
),

as_of AS (
    SELECT MAX(incident_date) AS as_of_date
    FROM {{ ref('stg_safety_incidents') }}
),

incidents_12m AS (
    SELECT
        i.contractor_id,
        COUNT(*) AS incidents_last_12m
    FROM {{ ref('stg_safety_incidents') }} i
    CROSS JOIN as_of a
    WHERE i.incident_date > DATEADD(month, -12, a.as_of_date)
    GROUP BY i.contractor_id
),

coi AS (
    SELECT
        contractor_id,
        COUNT(verification_result) AS coi_checks,
        SUM(CASE WHEN verification_result IN ('Non-Compliant', 'Deficient') THEN 1 ELSE 0 END) AS coi_failures
    FROM {{ ref('fct_coi_verifications') }}
    GROUP BY contractor_id
)

SELECT
    c.contractor_id,
    c.tier,
    c.emr,
    COALESCE(i.incidents_last_12m, 0)          AS incidents_last_12m,
    COALESCE(k.coi_checks, 0)                               AS coi_checks,
    COALESCE(k.coi_failures, 0)                             AS coi_failures,
    ROUND(k.coi_failures / NULLIF(k.coi_checks, 0), 4)      AS coi_failure_rate
FROM contractors c
LEFT JOIN incidents_12m i ON c.contractor_id = i.contractor_id
LEFT JOIN coi k           ON c.contractor_id = k.contractor_id