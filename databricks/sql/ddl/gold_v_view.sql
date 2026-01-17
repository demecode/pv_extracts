CREATE OR REPLACE VIEW tp_finance.gold.v_contract_statement_lines AS
SELECT
  customer_id,
  contract_id,
  facility_id,
  month,
  currency,
  opening_balance,
  drawn_this_month,
  repaid_this_month,
  closing_balance,
  balance_source,
  is_mismatch,
  balance_diff
FROM tp_finance.gold.fact_facility_monthly
ORDER BY customer_id, contract_id, facility_id, month;