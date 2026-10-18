-- Week 8 Day 6 | 05 CSV File Format + Internal Stage
-- Run 01-03 first. This file creates the stage; it does NOT upload files.

USE WAREHOUSE DE_WH;
USE DATABASE DE_PROJECT;
USE SCHEMA BRONZE;

CREATE OR REPLACE FILE FORMAT DE_PROJECT.BRONZE.FF_CUSTOMERS_CSV
  TYPE = CSV
  FIELD_DELIMITER = ','
  SKIP_HEADER = 1
  FIELD_OPTIONALLY_ENCLOSED_BY = '"'
  NULL_IF = ('NULL', '');

CREATE STAGE IF NOT EXISTS DE_PROJECT.BRONZE.STG_CUSTOMERS
  FILE_FORMAT = DE_PROJECT.BRONZE.FF_CUSTOMERS_CSV;

SHOW FILE FORMATS IN SCHEMA DE_PROJECT.BRONZE;
SHOW STAGES IN SCHEMA DE_PROJECT.BRONZE;

-- Upload customers.csv to @DE_PROJECT.BRONZE.STG_CUSTOMERS using a
-- supported Snowsight upload UI or SnowSQL/Snowflake CLI.
-- PUT is NOT supported in ordinary Snowsight SQL files/worksheets.
-- SnowSQL/CLI-only example (do not run here):
-- PUT file://C:/path/to/customers.csv @DE_PROJECT.BRONZE.STG_CUSTOMERS AUTO_COMPRESS=TRUE;

-- After uploading, verify:
LIST @DE_PROJECT.BRONZE.STG_CUSTOMERS;
