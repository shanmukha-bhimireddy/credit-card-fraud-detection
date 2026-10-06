-- Exploratory SQL for the credit card fraud dataset (run with DuckDB)
-- duckdb -c ".read sql/fraud_eda.sql"

CREATE OR REPLACE VIEW tx AS
SELECT *, CAST(FLOOR(Time / 3600) % 24 AS INTEGER) AS hour_of_day
FROM read_csv_auto('data/creditcard.csv');

-- 1. Overall volume and fraud rate
SELECT COUNT(*)                         AS transactions,
       SUM(Class)                       AS fraud_cases,
       ROUND(100.0 * AVG(Class), 3)     AS fraud_rate_pct,
       ROUND(SUM(Amount), 2)            AS total_amount,
       ROUND(SUM(Amount * Class), 2)    AS fraud_amount
FROM tx;

-- 2. Fraud rate by hour of day (when should monitoring be strongest?)
SELECT hour_of_day,
       COUNT(*)                         AS transactions,
       SUM(Class)                       AS fraud_cases,
       ROUND(100.0 * AVG(Class), 3)     AS fraud_rate_pct
FROM tx
GROUP BY hour_of_day
ORDER BY fraud_rate_pct DESC;

-- 3. Fraud by transaction amount band
SELECT CASE WHEN Amount = 0      THEN '0. $0 (card test)'
            WHEN Amount < 10     THEN '1. <$10'
            WHEN Amount < 100    THEN '2. $10-99'
            WHEN Amount < 500    THEN '3. $100-499'
            ELSE                      '4. $500+' END AS amount_band,
       COUNT(*)                         AS transactions,
       SUM(Class)                       AS fraud_cases,
       ROUND(100.0 * AVG(Class), 3)     AS fraud_rate_pct,
       ROUND(SUM(Amount * Class), 2)    AS fraud_amount
FROM tx
GROUP BY amount_band
ORDER BY amount_band;

-- 4. Average amount: fraud vs legitimate
SELECT Class,
       ROUND(AVG(Amount), 2)            AS avg_amount,
       ROUND(MEDIAN(Amount), 2)         AS median_amount,
       ROUND(MAX(Amount), 2)            AS max_amount
FROM tx
GROUP BY Class;
