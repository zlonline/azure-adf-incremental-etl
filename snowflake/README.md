# Snowflake Fundamentals

This module demonstrates basic Snowflake
data warehouse concepts and SQL operations.

## Concepts Covered

- Database
- Schema
- Virtual Warehouse
- Table
- Internal Stage
- COPY INTO
- Query History
- Query Profile

## Hands-on Implementation

1. Created the DE_PROJECT database.
2. Created Bronze, Silver, and Gold schemas.
3. Configured an XSMALL Virtual Warehouse.
4. Created a Customers table.
5. Practiced Snowflake SQL queries.
6. Uploaded a CSV file to an Internal Stage.
7. Loaded data using COPY INTO.
8. Validated row counts and query results.

## Future Integration

Azure SQL Server / ADF
    ↓
ADLS Gen2 Parquet
    ↓
Snowflake External Stage
    ↓
COPY INTO
    ↓
Snowflake Tables

## Notes

The external Azure Storage integration is
an optional future enhancement.