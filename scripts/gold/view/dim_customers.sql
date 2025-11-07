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
