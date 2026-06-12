ALTER TABLE data_min
ADD INDEX idx_behavior_item_time (
    behavior_type,
    item_category,
    item_id,
    event_time
);
SELECT
    item_category,
    item_id,

    COUNT(DISTINCT LEFT(event_time, 10)) AS purchase_days,
    COUNT(*) AS purchase_count,

    31 AS total_days,

    ROUND(
        COUNT(DISTINCT LEFT(event_time, 10)) / 31,
        4
    ) AS purchase_heat

FROM data_min
WHERE behavior_type = 4
GROUP BY
    item_category,
    item_id
ORDER BY
    item_category,
    purchase_heat DESC,
    purchase_count DESC