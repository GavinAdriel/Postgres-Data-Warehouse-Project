/*
===============================================================================
DDL Script: Create Bronze Tables
===============================================================================
Script Purpose:
    This script creates tables in the 'bronze' schema, dropping existing tables 
    if they already exist.
===============================================================================
*/

CREATE SCHEMA IF NOT EXISTS bronze;

-- 1. CRM Customer Info
DROP TABLE IF EXISTS bronze.crm_cust_info;
CREATE TABLE IF NOT EXISTS bronze.crm_cust_info (
    cst_id INTEGER,
    cst_key TEXT,
    cst_firstname TEXT,
    cst_lastname TEXT,
    cst_marital_status TEXT,
    cst_gndr TEXT,
    cst_create_date DATE
);

-- 2. CRM Product Info
DROP TABLE IF EXISTS bronze.crm_prd_info;
CREATE TABLE IF NOT EXISTS bronze.crm_prd_info (
    prd_id INTEGER,
    prd_key TEXT,
    prd_nm TEXT,
    prd_cost INTEGER,
    prd_line TEXT,
    prd_start_dt TIMESTAMP,
    prd_end_dt TIMESTAMP
);

-- 3. CRM Sales Details
DROP TABLE IF EXISTS bronze.crm_sales_details;
CREATE TABLE IF NOT EXISTS bronze.crm_sales_details (
    sls_ord_num TEXT,
    sls_prd_key TEXT,
    sls_cust_id INTEGER,
    sls_order_dt INTEGER,
    sls_ship_dt INTEGER,
    sls_due_dt INTEGER,
    sls_sales INTEGER,
    sls_quantity INTEGER,
    sls_price INTEGER
);

-- 4. ERP Customer AZ12
DROP TABLE IF EXISTS bronze.erp_cust_az12;
CREATE TABLE IF NOT EXISTS bronze.erp_cust_az12 (
    cid TEXT,
    bdate DATE,
    gen TEXT
);

-- 5. ERP Location A101
DROP TABLE IF EXISTS bronze.erp_loc_a101;
CREATE TABLE IF NOT EXISTS bronze.erp_loc_a101 (
    cid TEXT,
    cntry TEXT
);

-- 6. ERP PX Category G1V2
DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;
CREATE TABLE IF NOT EXISTS bronze.erp_px_cat_g1v2 (
    id TEXT,
    cat TEXT,
    subcat TEXT,
    maintenance TEXT
);
