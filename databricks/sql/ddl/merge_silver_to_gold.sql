MERGE INTO tp_finance.gold.fact_facility_monthly t
USING (
  SELECT
    customer_id, contract_id, facility_id, month, currency,
    drawn_this_month, repaid_this_month, net_movement,
    opening_balance, closing_balance,
    balance_source, balance_diff, is_mismatch, is_backfilled,
    load_ts
  FROM tp_finance.silver.contract_facility_monthly_canonical
) s
ON  t.customer_id = s.customer_id
AND t.contract_id = s.contract_id
AND t.facility_id = s.facility_id
AND t.month       = s.month
WHEN MATCHED THEN UPDATE SET *
WHEN NOT MATCHED THEN INSERT *;