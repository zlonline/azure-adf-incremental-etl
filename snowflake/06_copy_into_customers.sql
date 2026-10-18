-- Week 8 Day 6 | 06 Stage -> COPY INTO -> Table
-- Prerequisites: run 01,02,03,05 and upload customers.csv to internal stage.
-- Expected CSV: 5 data rows with columns matching CUSTOMERS table order.
-- If stage is empty, upload the file before executing COPY INTO.

USE WAREHOUSE DE_WH;
USE DATABASE DE_PROJECT;
USE SCHEMA BRONZE;

-- Step 1: Confirm staged file is present
LIST @DE_PROJECT.BRONZE.STG_CUSTOMERS;

-- Step 2: Check pre-load row count
SELECT COUNT(*) AS ROWS_BEFORE_LOAD
FROM DE_PROJECT.BRONZE.CUSTOMERS;

-- Step 3: Validate parsing/conversion (no data loaded)
COPY INTO DE_PROJECT.BRONZE.CUSTOMERS
FROM @DE_PROJECT.BRONZE.STG_CUSTOMERS
FILE_FORMAT = (FORMAT_NAME = DE_PROJECT.BRONZE.FF_CUSTOMERS_CSV)
VALIDATION_MODE = RETURN_ERRORS;

-- Step 4: Actual load
COPY INTO DE_PROJECT.BRONZE.CUSTOMERS
FROM @DE_PROJECT.BRONZE.STG_CUSTOMERS
FILE_FORMAT = (FORMAT_NAME = DE_PROJECT.BRONZE.FF_CUSTOMERS_CSV)
ON_ERROR = ABORT_STATEMENT;

-- Step 5: Verify
SELECT COUNT(*) AS ROWS_AFTER_LOAD
FROM DE_PROJECT.BRONZE.CUSTOMERS;
SELECT CUSTOMER_ID, NAME, EMAIL, CITY, UPDATED_AT
FROM DE_PROJECT.BRONZE.CUSTOMERS
ORDER BY CUSTOMER_ID;

-- Step 6 (optional): Run the same COPY INTO again to observe file-level
-- load tracking. Re-loading renamed/new files can still duplicate records.
-- COPY INTO DE_PROJECT.BRONZE.CUSTOMERS
-- FROM @DE_PROJECT.BRONZE.STG_CUSTOMERS
-- FILE_FORMAT = (FORMAT_NAME = DE_PROJECT.BRONZE.FF_CUSTOMERS_CSV)
-- ON_ERROR = ABORT_STATEMENT;

-- Notes: For a clean first run with only the sample CSV, expect 5 rows.
-- If you previously loaded files, counts may differ.
