USE ecom_analys

SELECT
	customer_id,
	MIN(purchase_date) AS first_purchase,
	MAX(purchase_date) AS last_purchase,
	COUNT(*) AS total_purchase,
	SUM(product_price * quantity) AS total_revenue,
	CAST(SUM(product_price * quantity) AS decimal(18, 2))/ COUNT(purchase_date) AS avg_revenue_per_event,
	DATEDIFF(DAY, MAX(purchase_date), (SELECT MAX(purchase_date) FROM ecom_data_ws_1604)) AS recency,
	DATEDIFF(DAY, MIN(purchase_date), MAX(purchase_date)) AS customer_lifetime_days,
	CASE
		WHEN COUNT(purchase_date) > 1 THEN 1
		ELSE 0
	END AS repeat_flag
FROM 
	ecom_data_ws_1604
GROUP BY 
	customer_id