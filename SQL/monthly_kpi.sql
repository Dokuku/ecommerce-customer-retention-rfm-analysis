USE ecom_analys

SELECT
	FORMAT(purchase_date, 'yyyy-MM') AS month_purchase_date,
	COUNT(purchase_date) AS total_events,
	COUNT(DISTINCT customer_id) AS total_unique_customers,
	SUM(quantity * product_price) AS total_revenue,
	SUM(quantity * product_price) / COUNT(DISTINCT customer_id) AS revenue_per_customer
FROM 
	ecom_data_ws_1604
GROUP BY 
	FORMAT(purchase_date, 'yyyy-MM')
ORDER BY 
	FORMAT(purchase_date, 'yyyy-MM');