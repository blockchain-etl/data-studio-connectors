WITH wanted AS (
SELECT 
  session_id, 
  ROW_NUMBER() OVER(PARTITION BY session_id ORDER BY block_timestamp) AS pos, 
  CASE WHEN tx.to_address = "0x698ff47b84837d3971118a369c570172ee7e54c2" THEN TRUE ELSE NULL END AS ok,
  tx.to_address
FROM `crypto-public-data.aux.materialized_sessions` AS sessions JOIN UNNEST(transactions) AS tx
WHERE TRUE
),
raw_referrers AS (
SELECT 
  wanted.session_id, wanted.ok, wanted.pos,
  CASE WHEN wanted.pos-1 > 0 THEN transactions[ORDINAL(wanted.pos-1)].to_address ELSE NULL END AS referrer
FROM
`crypto-public-data.aux.materialized_sessions` AS sessions, wanted
WHERE TRUE
  AND wanted.ok IS TRUE
  AND sessions.session_id = wanted.session_id
),
referrers AS (
SELECT DISTINCT session_id, FIRST_VALUE(referrer) OVER(PARTITION BY session_id ORDER BY pos) AS referrer
FROM raw_referrers
WHERE referrer IS NULL OR (referrer != "0x698ff47b84837d3971118a369c570172ee7e54c2")
ORDER BY session_id
)
SELECT referrer, COUNT(*) AS freq
FROM referrers
GROUP BY referrer
ORDER BY freq DESC
