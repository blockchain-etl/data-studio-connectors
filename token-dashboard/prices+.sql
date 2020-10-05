SELECT 
  CAST(transfers.block_timestamp AS DATE) AS timestamp,
  from_address, to_address, 
  tokens.symbol, tokens.name,
  SAFE_CAST(value AS NUMERIC)/POW(10,SAFE_CAST(decimals AS NUMERIC)) AS value,
  assets.id, assets.logo,
  prices.high, prices.low, prices.open, prices.close,
  SAFE_CAST(value AS NUMERIC)/POW(10,SAFE_CAST(decimals AS NUMERIC)) * prices.close AS usd_value
FROM
  `bigquery-public-data.crypto_ethereum.tokens` AS tokens,
  `crypto-public-data.aux.coingecko_assets` AS assets,
  `bigquery-public-data.crypto_ethereum.token_transfers` AS transfers
  LEFT JOIN
  `crypto-public-data.aux.coingecko_prices` AS prices
  ON (prices.id = assets.id AND CAST( transfers.block_timestamp AS DATE) = CAST(prices.timestamp AS DATE))
WHERE TRUE
  AND CAST(transfers.block_timestamp AS DATE) >= PARSE_DATE('%Y%m%d', @DS_START_DATE)
  AND CAST(transfers.block_timestamp AS DATE) <= PARSE_DATE('%Y%m%d', @DS_END_DATE)  
  AND tokens.address = @token_address
  AND tokens.address = transfers.token_address
  AND tokens.address = assets.contract_address
