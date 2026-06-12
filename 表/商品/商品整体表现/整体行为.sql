SELECT
    SUM(CASE 
            WHEN behavior_type = 1 THEN 1 
            ELSE 0 
        END) AS total_views,
	SUM(CASE 
            WHEN behavior_type = 2 THEN 1 
            ELSE 0 
        END) AS total_fav,
	SUM(CASE 
            WHEN behavior_type = 3 THEN 1 
            ELSE 0 
        END) AS total_cart,
    SUM(CASE 
            WHEN behavior_type = 4 THEN 1 
            ELSE 0 
        END) AS total_sales

FROM data_min;