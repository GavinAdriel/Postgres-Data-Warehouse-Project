INSERT INTO silver.crm_cust_info (
    cst_id, 
    cst_key, 
    cst_firstname, 
    cst_lastname, 
    cst_marital_status, 
    cst_gndr, 
    cst_create_date
)
WITH 
	filter AS (
		SELECT
			cst_id,
			cst_key,
			TRIM(cst_firstname) AS cst_firstname,
			TRIM(cst_lastname) AS cst_lastname,
			CASE UPPER(TRIM(cst_marital_status)) 
                WHEN 'M' THEN 'Married'
				WHEN 'S' THEN 'Single'
				ELSE 'n/a'
			END AS cst_marital_status,
			CASE UPPER(TRIM(cst_gndr)) 
                WHEN 'M' THEN 'Male'
				WHEN 'F' THEN 'Female'
				ELSE 'n/a'
			END AS cst_gndr,
			cst_create_date
		FROM(
			SELECT 
				*,
				row_number() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS rn
			FROM bronze.crm_cust_info
			) AS t
		WHERE rn = 1
	)

SELECT 
	*
FROM filter

