WITH hourly_user_behavior AS (
    SELECT
        event_time,
        user_id,
        COUNT(*) AS num_behavior_type
    FROM data_min 
    GROUP BY
        event_time,
        user_id
),

hourly_user_rank AS (
    SELECT
        event_time,
        user_id,
        num_behavior_type,
        ROW_NUMBER() OVER (
            PARTITION BY event_time
            ORDER BY num_behavior_type DESC
        ) AS user_rank
    FROM hourly_user_behavior
)

SELECT
    event_time,
    user_id,
    num_behavior_type,
    user_rank
FROM hourly_user_rank
WHERE user_rank <= 5
ORDER BY
    event_time ASC,
    user_rank ASC;
