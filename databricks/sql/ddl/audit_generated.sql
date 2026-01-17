CREATE TABLE IF NOT EXISTS tp_finance.audit.generated_documents (
  customer_id       STRING,
  contract_id       STRING,
  doc_type          STRING,
  period_start      DATE,
  period_end        DATE,
  output_path       STRING,
  file_sha256       STRING,
  status            STRING,
  error             STRING,
  generated_ts      TIMESTAMP
)
USING DELTA
LOCATION 'abfss://lakehouse@pvcstor.dfs.core.windows.net/audit/generated_documents';