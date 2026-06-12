WITH survey_period AS (
    SELECT
        MIN(DATE(STR_TO_DATE(`event_time`, '%Y-%m-%d %H'))) AS survey_start_date,
        MAX(DATE(STR_TO_DATE(`event_time`, '%Y-%m-%d %H'))) AS survey_end_date,
        DATEDIFF(
            MAX(DATE(STR_TO_DATE(`event_time`, '%Y-%m-%d %H'))),
            MIN(DATE(STR_TO_DATE(`event_time`, '%Y-%m-%d %H')))
        ) + 1 AS survey_days
    FROM data_min
),

all_users AS (
    SELECT DISTINCT
        user_id
    FROM data_min
),

user_purchase_days AS (
    SELECT
        user_id,
        COUNT(DISTINCT DATE(STR_TO_DATE(`event_time`, '%Y-%m-%d %H'))) AS purchase_days,
        COUNT(*) AS purchase_count
    FROM data_min
    WHERE behavior_type = 4
    GROUP BY user_id
)

SELECT
    au.user_id,
    IFNULL(upd.purchase_days, 0) AS purchase_days,
    IFNULL(upd.purchase_count, 0) AS purchase_count,

    CASE
        WHEN IFNULL(upd.purchase_days, 0) = 0 THEN NULL
        ELSE ROUND(sp.survey_days / upd.purchase_days, 2)
    END AS avg_days_per_purchase_day,

    ROUND(IFNULL(upd.purchase_days, 0) / sp.survey_days, 4) AS purchase_day_frequency

FROM all_users au
LEFT JOIN user_purchase_days upd
    ON au.user_id = upd.user_id
CROSS JOIN survey_period sp
ORDER BY avg_days_per_purchase_day desc;
