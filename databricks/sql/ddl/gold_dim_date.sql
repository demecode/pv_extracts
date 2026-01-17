CREATE TABLE IF NOT EXISTS tp_finance.gold.dim_month (
  month       DATE,
  month_key   INT,
  year        INT,
  month_num   INT,
  month_name  STRING,
  year_month  STRING
)
USING DELTA
LOCATION 'abfss://lakehouse@pvcstor.dfs.core.windows.net/gold/dim_month';

INSERT OVERWRITE tp_finance.gold.dim_month
WITH bounds AS (
  SELECT min(month) AS min_m, max(month) AS max_m
  FROM tp_finance.gold.fact_facility_monthly
),
months AS (
  SELECT explode(sequence(min_m, max_m, interval 1 month)) AS month
  FROM bounds
)
SELECT
  month,
  CAST(date_format(month,'yyyyMM') AS INT) AS month_key,
  year(month) AS year,
  month(month) AS month_num,
  date_format(month,'MMMM') AS month_name,
  date_format(month,'yyyy-MM') AS year_month
FROM months;