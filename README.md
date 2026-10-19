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



Trigger Type: Schedule
Frequency: Daily
Time: 3:00 AM Eastern


# Azure Data Factory Incremental ETL Pipeline

## Project Overview

This project demonstrates a cloud-based ETL pipeline built with Azure Data Factory (ADF), SQL Server, and Azure Data Lake Storage Gen2 (ADLS Gen2).

The solution supports full and incremental data loading, watermark-based extraction, parameterized pipelines, dynamic Parquet file paths, scheduled execution, monitoring, and failure handling.

The project was developed as a hands-on Azure Data Engineering portfolio project.

## Architecture

![Azure ETL Architecture](docs/architecture.png)

**Core data flow:**

SQL Server → Azure Data Factory → ADLS Gen2 → Parquet

**Incremental processing:**

Get Old Watermark → Get New Watermark → Copy Incremental Data → Update Watermark

The watermark is updated only after the Copy Activity succeeds.

## Tech Stack

| Technology | Purpose |
|---|---|
| SQL Server | Source database and watermark control |
| Azure Data Factory | Data integration and orchestration |
| Self-hosted Integration Runtime | Connectivity to local SQL Server |
| ADLS Gen2 | Cloud data lake storage |
| Parquet | Columnar file format |
| Azure Managed Identity / RBAC | Storage access management |
| Snowflake | Separate foundational SQL and data loading exercises |
| GitHub | Source control and project documentation |

## Full Load Design

The full load pipeline extracts the source Customers table and writes the data into ADLS Gen2 in Parquet format.

The initial full load provides a baseline dataset for subsequent incremental processing.

## Incremental Load and Watermark Design

Incremental extraction uses the `updated_at` column and a SQL Server watermark control table.

The extraction window is:

```sql
WHERE updated_at > @OldWatermark
  AND updated_at <= @NewWatermark
```

The pipeline retrieves the previous watermark, calculates the current upper boundary, copies the corresponding records, and updates the watermark only after a successful copy.

## Parameterization and Dynamic File Paths

The pipeline supports reusable parameters such as:

- `schema_name`
- `table_name`
- `watermark_column`
- `watermark_key`
- `output_layer`
- `load_date`

Example output:

```text
bronze/customers/year=2026/month=10/day=18/customers_<RunId>.parquet
```

The output folder is generated dynamically without hardcoding the date in the dataset.

## Scheduling

The project includes a daily Azure Data Factory Schedule Trigger.

The intended execution time is 3:00 AM Eastern.

Scheduled runs require the Self-hosted Integration Runtime and source SQL Server to be available.

## Error Handling and Retry

The Copy Activity is configured with retry behavior for transient failures.

The watermark update depends on successful completion of the Copy Activity.

Failure handling is designed to preserve the previous watermark when the data copy fails.

## Monitoring and Logging

Azure Data Factory Pipeline Runs and Activity Runs are used to monitor:

- Execution status
- Run duration
- Rows read and copied
- Copy failures
- Error messages
- Pipeline Run IDs

Long-term diagnostic logging through Azure Monitor / Log Analytics is a possible future enhancement.

## Security Design

The design uses Azure identity and role-based access control where configured.

Sensitive credentials should be stored securely, such as in Azure Key Vault, rather than committed to GitHub.

Deployment-specific values and credentials are excluded or sanitized in published configuration files.

## End-to-End Testing

The testing plan covers:

| Test | Scenario |
|---|---|
| T01 | Full Load |
| T02 | Incremental Load |
| T03 | No New Data |
| T04 | SQL Connection Failure |
| T05 | ADLS Write Failure |
| T06 | Retry Policy |
| T07 | Rerun / Idempotency |
| T08 | Dynamic File Path |

Actual test outcomes, evidence, and any blocked scenarios are documented in [Test Results](docs/test_results.md).

## Screenshots

### ADF Incremental Pipeline

![ADF Pipeline](docs/pipeline_screenshot.png)

### ADLS Gen2 Output

![ADLS Output](docs/adls_screenshot.png)

### ADF Monitoring

![ADF Monitoring](docs/monitoring_screenshot.png)

## Setup and Deployment

1. Provision an Azure Data Factory instance and an ADLS Gen2 Storage Account.
2. Prepare SQL Server source tables using the scripts in `sql/`.
3. Create the watermark control table and stored procedure.
4. Configure the Self-hosted Integration Runtime.
5. Configure the SQL Server and ADLS Gen2 Linked Services.
6. Deploy or recreate the ADF Pipelines, Datasets, and Trigger using the exported definitions.
7. Supply environment-specific parameters and secure credentials.
8. Validate storage permissions and network connectivity.
9. Execute a full load.
10. Execute an incremental load and verify the watermark.
11. Review the test results before enabling scheduled execution.

**Deployment note:** Individual ADF object JSON definitions are provided for reference and version control. They are not necessarily a complete, one-click ARM deployment package.

## Known Limitations

- Copy Activity and watermark updates are not atomic.
- Reruns can create duplicate Parquet files when Run IDs are used in output filenames.
- An `updated_at` watermark may miss late-committed changes.
- Physical deletes are not automatically captured.
- Concurrent runs require additional coordination.
- Exactly-once processing is not guaranteed by the current design.

## Future Improvements

- SQL Server Change Tracking or CDC
- Idempotent batch loading
- Staging and commit patterns
- Delta Lake and MERGE
- Azure Monitor alerting
- CI/CD deployment automation
- Additional automated data quality tests
- Optional ADLS Gen2 to Snowflake integration

## Snowflake Fundamentals

The `snowflake/` folder contains introductory Snowflake SQL exercises covering:

- Databases and schemas
- Virtual Warehouses
- Tables and SQL queries
- Internal Stages
- CSV loading with COPY INTO
- Query History and Query Profile

These exercises are a separate learning module and do not imply that the Azure ETL pipeline currently loads data into Snowflake.

## Repository Structure

```text
adf/         Azure Data Factory definitions
sql/         SQL Server setup and validation scripts
snowflake/   Snowflake fundamentals
docs/        Architecture, screenshots, and test results
README.md    Project documentation
```
