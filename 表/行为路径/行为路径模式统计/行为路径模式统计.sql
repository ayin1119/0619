SELECT
    behavior_path,
    COUNT(*) AS path_count
FROM (
    SELECT
        user_id,
        item_id,
        GROUP_CONCAT(
            behavior_type
            ORDER BY first_time
            SEPARATOR '->'
        ) AS behavior_path
    FROM (
        SELECT
            user_id,
            item_id,
            behavior_type,
            MIN(event_time) AS first_time
        FROM data_min
        GROUP BY
            user_id,
            item_id,
            behavior_type
    ) a
    GROUP BY
        user_id,
        item_id
) b
WHERE behavior_path LIKE '1->%4'
   OR behavior_path = '1->4'
GROUP BY
    behavior_path
ORDER BY
    path_count DESC;