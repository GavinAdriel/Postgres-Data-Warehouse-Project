CREATE VIEW gold.fact_sales AS
SELECT
    s.sls_ord_num as order_number,
    prd.product_key as product_key,
    cus.customer_key as customer_key,
    s.sls_order_dt as order_date,
    s.sls_ship_dt as shipping_date,
    s.sls_due_dt as due_date,
    s.sls_price as price,
    s.sls_quantity as quantity,
    s.sls_sales as sales_amount
FROM silver.crm_sales_details s
LEFT JOIN gold.dim_products prd
ON s.sls_prd_key = prd.product_number
LEFT JOIN gold.dim_customers cus
ON s.sls_cust_id = cus.customer_id;