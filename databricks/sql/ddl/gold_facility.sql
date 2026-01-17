CREATE TABLE IF NOT EXISTS tp_finance.gold.fact_facility_monthly (
  customer_id        STRING,
  contract_id        STRING,
  facility_id        STRING,
  month              DATE,
  currency           STRING,

  drawn_this_month   DECIMAL(18,2),
  repaid_this_month  DECIMAL(18,2),
  net_movement       DECIMAL(18,2),

  opening_balance    DECIMAL(18,2),
  closing_balance    DECIMAL(18,2),

  balance_source     STRING,
  balance_diff       DECIMAL(18,2),
  is_mismatch        BOOLEAN,
  is_backfilled      BOOLEAN,

  load_ts            TIMESTAMP
)
USING DELTA
LOCATION 'abfss://lakehouse@pvcstor.dfs.core.windows.net/gold/fact_facility_monthly';