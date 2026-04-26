USE ecom_analys

SELECT 
	customer_id,
	purchase_date,
	FORMAT(purchase_date, 'yyyy-MM') AS month_purchase_date,
	product_category,
	gender,
	customer_age,
	product_price,
	quantity,
	(product_price * quantity) AS revenue
FROM 
	ecom_data_ws_1604