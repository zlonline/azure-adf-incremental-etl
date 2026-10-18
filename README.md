# azure-adf-incremental-etl

## Incremental Load

The pipeline uses a watermark-based incremental
loading strategy.

1. Retrieve the old watermark from SQL Server.
2. Retrieve the new watermark from the source table.
3. Copy records where:
   Old Watermark < updated_at <= New Watermark.
4. Write incremental records to ADLS Gen2 in Parquet.
5. Update the watermark only after a successful copy.

If the Copy Activity fails, the watermark remains
unchanged, allowing the next run to retry the data.



## Reusable Pipeline Parameters

The incremental ingestion pipeline supports
multiple SQL Server source tables through
ADF Pipeline Parameters.

The pipeline dynamically generates the source
SQL query, destination folder path, and Parquet
file name without modifying the pipeline logic.

Example parameters:

schema_name = dbo
table_name = orders
watermark_column = updated_at
watermark_key = orders_pipeline

Example output:

bronze/orders/year=2026/month=10/day=14/
orders_<RunId>.parquet