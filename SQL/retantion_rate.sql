

WITH base AS (
    SELECT DISTINCT
        customer_id,
        DATEFROMPARTS(YEAR(purchase_date), MONTH(purchase_date), 1) AS purchase_month
    FROM ecom_data_ws_1604
),
first_purchase AS (
    SELECT
        customer_id,
        MIN(purchase_month) AS cohort_month
    FROM base
    GROUP BY customer_id
),
cohort_base AS (
    SELECT
        b.customer_id,
        f.cohort_month,
        b.purchase_month,
        DATEDIFF(MONTH, f.cohort_month, b.purchase_month) AS cohort_index
    FROM base b
    INNER JOIN first_purchase f
        ON b.customer_id = f.customer_id
),
active_by_cohort AS (
    SELECT
        cohort_month,
        cohort_index,
        COUNT(DISTINCT customer_id) AS active_customers
    FROM cohort_base
    GROUP BY
        cohort_month,
        cohort_index
),
cohort_size AS (
    SELECT
        cohort_month,
        active_customers AS cohort_size
    FROM active_by_cohort
    WHERE cohort_index = 0
)
SELECT
    a.cohort_month,
    a.cohort_index,
    c.cohort_size,
    a.active_customers,
    CAST(a.active_customers * 1.0 / c.cohort_size AS decimal(5,4)) AS retention_rate
FROM active_by_cohort a
INNER JOIN cohort_size c
    ON a.cohort_month = c.cohort_month
ORDER BY
    a.cohort_month,
    a.cohort_index;