SELECT tokens.address, tokens.name, tokens.symbol, 
DATETIME_DIFF(CAST(CURRENT_TIMESTAMP() AS DATETIME), CAST(MAX(tx.block_timestamp) AS DATETIME),DAY) AS last_seen_days_ago,
COUNT(DISTINCT(from_address)) AS unique_senders,
COUNT(DISTINCT(to_address)) AS unique_receivers,
COUNT(transaction_hash) AS transaction_count 
FROM 
`bigquery-public-data.crypto_ethereum.tokens` AS tokens,
`bigquery-public-data.crypto_ethereum.token_transfers` AS tx
WHERE tokens.address = tx.token_address
GROUP BY address, name, symbol 
