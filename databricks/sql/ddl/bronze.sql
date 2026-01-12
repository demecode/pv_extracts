CREATE TABLE IF NOT EXISTS tp_finance.bronze.sp_facility_monthly_snapshot (
  customer_id        STRING,
  contract_id        STRING,
  facility_id        STRING,
  month              DATE,
  currency           STRING,
  opening_balance    DECIMAL(18,2),
  drawn_this_month   DECIMAL(18,2),
  repaid_this_month  DECIMAL(18,2),
  closing_balance    DECIMAL(18,2),

  -- lineage / audit
  source_system      STRING,
  source_path        STRING,
  file_sha256        STRING,
  load_date          DATE,
  source_modified_ts TIMESTAMP,
  ingestion_run_id   STRING,
  load_ts            TIMESTAMP,
  record_hash        STRING
)
USING DELTA
LOCATION 'abfss://lakehouse@pvcstor.dfs.core.windows.net/bronze/sp_facility_monthly_snapshot';

CREATE TABLE IF NOT EXISTS tp_finance.bronze.lti_facility_transactions (
  customer_id        STRING,
  contract_id        STRING,
  facility_id        STRING,
  transaction_date   DATE,
  transaction_type   STRING,          -- DRAW/REPAY
  amount             DECIMAL(18,2),
  reference          STRING,
  currency           STRING,

  -- lineage / audit
  source_system      STRING,
  source_path        STRING,
  file_sha256        STRING,
  load_date          DATE,
  source_modified_ts TIMESTAMP,
  ingestion_run_id   STRING,
  load_ts            TIMESTAMP,
  record_hash        STRING
)
USING DELTA
LOCATION 'abfss://lakehouse@pvcstor.dfs.core.windows.net/bronze/lti_facility_transactions';


