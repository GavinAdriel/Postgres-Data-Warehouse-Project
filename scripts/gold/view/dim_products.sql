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
WHERE prd_end_dt IS NULL
