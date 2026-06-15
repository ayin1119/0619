WITH all_users AS (
    SELECT DISTINCT
        user_id
    FROM data_min
),

user_category_purchase AS (
    SELECT
        user_id,
        item_category,
        COUNT(*) AS category_purchase_count
    FROM data_min
    WHERE behavior_type = 4
    GROUP BY
        user_id,
        item_category
),

user_purchase_total AS (
    SELECT
        user_id,
        SUM(category_purchase_count) AS total_purchase_count
    FROM user_category_purchase
    GROUP BY user_id
),

category_rank AS (
    SELECT
        ucp.user_id,
        ucp.item_category,
        ucp.category_purchase_count,
        upt.total_purchase_count,

        ROW_NUMBER() OVER (
            PARTITION BY ucp.user_id
            ORDER BY ucp.category_purchase_count DESC, ucp.item_category
        ) AS category_rn

    FROM user_category_purchase ucp
    JOIN user_purchase_total upt
        ON ucp.user_id = upt.user_id
),

user_concentration AS (
    SELECT
        au.user_id,

        cr.item_category AS top_category,

        IFNULL(cr.category_purchase_count, 0) AS top_category_purchase_count,

        IFNULL(upt.total_purchase_count, 0) AS total_purchase_count,

        CASE
            WHEN IFNULL(upt.total_purchase_count, 0) = 0 THEN 0
            ELSE ROUND(cr.category_purchase_count / upt.total_purchase_count, 4)
        END AS concentration_rate

    FROM all_users au
    LEFT JOIN user_purchase_total upt
        ON au.user_id = upt.user_id
    LEFT JOIN category_rank cr
        ON au.user_id = cr.user_id
        AND cr.category_rn = 1
),

user_rank AS (
    SELECT
        user_id,
        top_category,
        total_purchase_count,
        concentration_rate,

        ROW_NUMBER() OVER (
            ORDER BY concentration_rate DESC, total_purchase_count DESC, user_id
        ) AS user_rn,

        COUNT(*) OVER () AS total_users

    FROM user_concentration
)

SELECT
    user_id,

    CASE
        WHEN total_purchase_count > 0
             AND user_rn <= CEIL(total_users * 0.3)
        THEN 1
        ELSE 0
    END AS is_concentrated,

    CASE
        WHEN total_purchase_count > 0
             AND user_rn <= CEIL(total_users * 0.3)
        THEN top_category
        ELSE NULL
    END AS concentrated_category

FROM user_rank
ORDER BY
    is_concentrated DESC,
    user_id;