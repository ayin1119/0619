WITH base AS (
    SELECT
        user_id,
        item_id,
        behavior_type,
        item_category,
        event_time,
        DATE_SUB(DATE(event_time), INTERVAL WEEKDAY(event_time) DAY) AS week_start_date
    FROM data_min
    WHERE event_time IS NOT NULL
)

SELECT
    b.week_start_date,
    DATE_ADD(b.week_start_date, INTERVAL 6 DAY) AS week_end_date,
    COUNT(DISTINCT b.user_id) AS active_users_in_week
FROM base b
GROUP BY b.week_start_date