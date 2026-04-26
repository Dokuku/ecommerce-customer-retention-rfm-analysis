WITH raw_rfm AS (SELECT
	customer_id,
	DATEDIFF(DAY, MAX(purchase_date), (SELECT MAX(purchase_date) FROM ecom_data_ws_1604)) AS recency,
	COUNT(DISTINCT CAST(purchase_date AS DATE)) AS frequency,
	SUM(product_price * quantity) AS monetary
FROM 
	ecom_data_ws_1604
GROUP BY customer_id
),

rfm_segment AS (
	SELECT 
		*,
		5 - NTILE(4) OVER (ORDER BY recency) AS R,
		NTILE(4) OVER (ORDER BY frequency) AS F,
		NTILE(4) OVER (ORDER BY monetary) AS M,
		CAST(5 - NTILE(4) OVER (ORDER BY recency ASC) AS varchar(1)) +
			CAST(NTILE(4) OVER (ORDER BY frequency ASC) AS varchar(1)) +
			CAST(NTILE(4) OVER (ORDER BY monetary ASC) AS varchar(1)) AS rfm_code
	FROM 
		raw_rfm
)

SELECT 
	*,
	CASE
		WHEN R >= 3 AND F >= 3 AND M >= 3 THEN 'Champions'
		WHEN R >= 3 AND F >= 3 AND M < 3 THEN 'Loyal'
		WHEN R >= 3 AND F = 2 THEN 'Potential'
		WHEN R >= 3 AND F = 1 AND M >= 3 THEN 'Big Spenders'
		WHEN R <= 2 AND (F >= 3 OR M >= 3) THEN 'At Risk'
		ELSE 'Lost'
	END AS rfm_group
FROM rfm_segment