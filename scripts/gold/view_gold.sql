CREATE OR REPLACE PROCEDURE gold.view_gold()
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'Loading Gold layer...';

    RAISE NOTICE 'Dropping gold.dim_customers...';
    DROP VIEW IF EXISTS gold.dim_customers CASCADE;

    RAISE NOTICE 'Creating view gold.dim_customers...';
    CREATE VIEW gold.dim_customers AS
    SELECT
        row_number() over (order by crm.cst_id) as customer_key,
        crm.cst_id as customer_id,
        crm.cst_key as customer_number,
        crm.cst_firstname as firstname,
        crm.cst_lastname as lastname,
        loc.cntry as country,
        crm.cst_marital_status as marital_status,
        CASE WHEN crm.cst_gndr != 'n/a'
            THEN crm.cst_gndr
            ELSE COALESCE(cus.gen, 'n/a')
        END as gender,
        cus.bdate as birth_date,
        crm.cst_create_date as create_date
    FROM silver.crm_cust_info crm
        LEFT JOIN
    silver.erp_cust_az12 cus
    ON crm.cst_key = cus.cid
        LEFT JOIN
    silver.erp_loc_a101 loc
    ON crm.cst_key = loc.cid;

    RAISE NOTICE 'Dropping gold.dim_products...';
    DROP VIEW IF EXISTS gold.dim_products CASCADE;

    RAISE NOTICE 'Creating view gold.dim_products...';
    CREATE VIEW gold.dim_products AS
    SELECT
        row_number() over (order by prd_start_dt ,prd_key) as product_key,
        prd.prd_id as product_id,
        prd.prd_key as product_number,
        prd.prd_nm as product_name,
        prd.cat_id as category_id,
        cat.cat as category,
        cat.subcat as subcategory,
        cat.maintenance as maintenance,
        prd.prd_line as product_line,
        prd.prd_cost as cost,
        prd.prd_start_dt as start_date
    FROM silver.crm_prd_info prd
    LEFT JOIN silver.erp_px_cat_g1v2 cat
    ON prd.cat_id = cat.id
    WHERE prd_end_dt IS NULL;


    RAISE NOTICE 'Dropping gold.fact_sales...';
    DROP VIEW IF EXISTS gold.fact_sales CASCADE;

    RAISE NOTICE 'Creating view gold.fact_sales...';
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

    RAISE NOTICE 'Gold layer loaded successfully.';
END;
$$;

    
