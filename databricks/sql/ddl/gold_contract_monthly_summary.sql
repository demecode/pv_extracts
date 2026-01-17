-- CREATE TABLE IF NOT EXISTS tp_finance.gold.fact_contract_monthly_summary (
--   customer_id        STRING,
--   contract_id        STRING,
--   month              DATE,
--   currency           STRING,

--   total_drawn        DECIMAL(18,2),
--   total_repaid       DECIMAL(18,2),
--   net_movement       DECIMAL(18,2),
--   closing_balance    DECIMAL(18,2),

--   facilities         INT,
--   mismatched_rows    INT,

--   load_ts            TIMESTAMP
-- )
-- USING DELTA
-- LOCATION 'abfss://lakehouse@pvcstor.dfs.core.windows.net/gold/fact_contract_monthly_summary';


-- MERGE INTO tp_finance.gold.fact_contract_monthly_summary t
-- USING (
--   SELECT
--     customer_id,
--     contract_id,
--     month,
--     currency,
--     CAST(SUM(drawn_this_month) AS DECIMAL(18,2))  AS total_drawn,
--     CAST(SUM(repaid_this_month) AS DECIMAL(18,2)) AS total_repaid,
--     CAST(SUM(net_movement) AS DECIMAL(18,2))      AS net_movement,
--     CAST(SUM(closing_balance) AS DECIMAL(18,2))   AS closing_balance,
--     COUNT(DISTINCT facility_id)                   AS facilities,
--     SUM(CASE WHEN is_mismatch THEN 1 ELSE 0 END)  AS mismatched_rows,
--     MAX(load_ts)                                   AS load_ts
--   FROM tp_finance.gold.fact_facility_monthly
--   GROUP BY customer_id, contract_id, month, currency
-- ) s
-- ON  t.customer_id = s.customer_id
-- AND t.contract_id = s.contract_id
-- AND t.month       = s.month
-- WHEN MATCHED THEN UPDATE SET *
-- WHEN NOT MATCHED THEN INSERT *;

-- TRUNCATE TABLE tp_finance.gold.fact_contract_monthly_summary;

INSERT INTO tp_finance.gold.fact_contract_monthly_summary
SELECT
  customer_id,
  contract_id,
  month,
  MAX(currency) AS currency,
  CAST(SUM(drawn_this_month) AS DECIMAL(18,2))  AS total_drawn,
  CAST(SUM(repaid_this_month) AS DECIMAL(18,2)) AS total_repaid,
  CAST(SUM(net_movement) AS DECIMAL(18,2))      AS net_movement,
  CAST(SUM(closing_balance) AS DECIMAL(18,2))   AS closing_balance,
  COUNT(DISTINCT facility_id)                   AS facilities,
  SUM(CASE WHEN is_mismatch THEN 1 ELSE 0 END)  AS mismatched_rows,
  MAX(load_ts)                                  AS load_ts
FROM tp_finance.gold.fact_facility_monthly
GROUP BY customer_id, contract_id, month;