WITH session_hits AS (
  SELECT
    session_id, 
    COUNT(session_id) AS transaction_count,
    MIN(block_timestamp) AS start_time, 
    MAX(block_timestamp) AS end_time, 
    UNIX_SECONDS(MAX(block_timestamp)) - UNIX_SECONDS(MIN(block_timestamp)) AS duration
  FROM `crypto-public-data.aux.ethereum_sessions` 
  GROUP BY session_id
  HAVING COUNT(session_id) < 1000
)
SELECT 
  sessions.session_id,
  traces.from_address,
  start_time,
  end_time,
  duration,
  transaction_count,
  ARRAY_AGG(STRUCT<block_timestamp TIMESTAMP, transaction_hash STRING, to_address STRING>(
    traces.block_timestamp,traces.transaction_hash,traces.to_address) ORDER BY traces.block_timestamp
  ) AS transactions,
  ARRAY_AGG(DISTINCT traces.to_address IGNORE NULLS) AS to_address_set
FROM 
  `bigquery-public-data.crypto_ethereum.traces` AS traces, 
  `crypto-public-data.aux.ethereum_sessions` AS sessions,
  session_hits
WHERE TRUE
  AND sessions.address = traces.from_address
  AND sessions.block_timestamp = traces.block_timestamp
  AND sessions.session_id = session_hits.session_id
GROUP BY session_id, from_address, start_time, end_time, duration, transaction_count
