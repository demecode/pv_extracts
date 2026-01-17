CREATE TABLE IF NOT EXISTS tp_finance.silver.contract_facility_monthly_canonical (
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

  -- audit columns from both sources
  lti_opening_balance   DECIMAL(18,2),
  lti_closing_balance   DECIMAL(18,2),
  hist_opening_balance  DECIMAL(18,2),
  hist_closing_balance  DECIMAL(18,2),

  balance_source     STRING,   -- LTI_TX or HIST_SNAPSHOT
  balance_diff       DECIMAL(18,2),
  is_mismatch        BOOLEAN,
  is_backfilled      BOOLEAN,

  load_ts            TIMESTAMP
)
USING DELTA
LOCATION 'abfss://lakehouse@pvcstor.dfs.core.windows.net/silver/contract_facility_monthly_canonical';