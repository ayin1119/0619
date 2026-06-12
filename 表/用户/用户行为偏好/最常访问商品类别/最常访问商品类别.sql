WITH user_category_behavior AS (
    SELECT
        user_id,
        item_category,
        COUNT(*) AS category_behavior_count
    FROM data_min
    WHERE item_category IS NOT NULL
      AND event_time IS NOT NULL
    GROUP BY
        user_id,
        item_category
),

user_total_behavior AS (
    SELECT
        user_id,
        COUNT(*) AS total_behavior_count
    FROM data_min
    WHERE event_time IS NOT NULL
    GROUP BY user_id
),

ranked_category AS (
    SELECT
        ucb.user_id,
        ucb.item_category,
        ucb.category_behavior_count,
        utb.total_behavior_count,
        ROW_NUMBER() OVER (
            PARTITION BY ucb.user_id
            ORDER BY ucb.category_behavior_count DESC
        ) AS rn
    FROM user_category_behavior ucb
    JOIN user_total_behavior utb
        ON ucb.user_id = utb.user_id
)

SELECT
    item_category AS most_visited_category,
    user_id,
    category_behavior_count,
    total_behavior_count
FROM ranked_category
WHERE rn = 1
ORDER BY item_category,total_behavior_count desc;