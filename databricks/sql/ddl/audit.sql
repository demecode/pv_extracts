CREATE TABLE IF NOT EXISTS tp_finance.audit.parsed_files (
  source_system STRING,
  file_sha256   STRING,
  source_path   STRING,
  parsed_ts     TIMESTAMP,
  status        STRING,
  error         STRING
)
USING DELTA
LOCATION 'abfss://lakehouse@pvcstor.dfs.core.windows.net/audit/parsed_files';

CREATE TABLE IF NOT EXISTS tp_finance.raw.github_workbook_files (
  source_system       STRING,
  source_path         STRING,
  source_modified_ts  TIMESTAMP,
  load_date           DATE,
  load_ts             TIMESTAMP,
  file_sha256         STRING
)
USING DELTA
LOCATION 'abfss://lakehouse@pvcstor.dfs.core.windows.net/raw/github_workbook_files';

CREATE TABLE IF NOT EXISTS tp_finance.raw.github_sheet_rows (
  source_system       STRING,
  source_path         STRING,
  file_sha256         STRING,
  sheet_name          STRING,
  row_num             INT,
  row_json            STRING,
  load_date           DATE,
  source_modified_ts  TIMESTAMP,
  ingestion_run_id    STRING,
  load_ts             TIMESTAMP
)
USING DELTA
LOCATION 'abfss://lakehouse@pvcstor.dfs.core.windows.net/raw/github_sheet_rows';