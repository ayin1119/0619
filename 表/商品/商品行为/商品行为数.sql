CREATE INDEX idx_item_category_behavior
ON data_min(item_id, item_category, behavior_type);
SELECT
	item_category,
    item_id,

    SUM(behavior_type = 1) AS total_views,
    SUM(behavior_type = 2) AS total_fav,
    SUM(behavior_type = 3) AS total_cart,
    SUM(behavior_type = 4) AS total_sales

FROM data_min FORCE INDEX(idx_item_category_behavior)
WHERE behavior_type IN (1, 2, 3, 4)
GROUP BY
	item_id,
	item_category
ORDER BY
    item_category, total_sales DESC