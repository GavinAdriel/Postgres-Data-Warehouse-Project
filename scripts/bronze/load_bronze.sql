CREATE PROCEDURE bronze.load_bronze()
    language plpgsql
AS
$$
BEGIN

TRUNCATE TABLE bronze.crm_cust_info;

COPY bronze.crm_cust_info
FROM '/sql-data-warehouse-project/datasets/crm/cust_info.csv'
WITH (
    FORMAT csv,
    HEADER true
);

TRUNCATE TABLE bronze.crm_prd_info;

COPY bronze.crm_prd_info
FROM '/sql-data-warehouse-project/datasets/crm/prd_info.csv'
WITH (
    FORMAT csv,
    HEADER true
);

TRUNCATE TABLE bronze.crm_sales_details;

COPY bronze.crm_sales_details
FROM '/sql-data-warehouse-project/datasets/crm/sales_details.csv'
WITH (
    FORMAT csv,
    HEADER true
);

TRUNCATE TABLE bronze.erp_cust_az12;

COPY bronze.erp_cust_az12
FROM '/sql-data-warehouse-project/datasets/erp/CUST_AZ12.csv'
WITH (
    FORMAT csv,
    HEADER true
);

TRUNCATE TABLE bronze.erp_loc_a101;

COPY bronze.erp_loc_a101
FROM '/sql-data-warehouse-project/datasets/erp/LOC_A101.csv'
WITH (
    FORMAT csv,
    HEADER true
);

TRUNCATE TABLE bronze.erp_px_cat_g1v2;

COPY bronze.erp_px_cat_g1v2
FROM '/sql-data-warehouse-project/datasets/erp/PX_CAT_G1V2.csv'
WITH (
    FORMAT csv,
    HEADER true
);

END;
$$;

