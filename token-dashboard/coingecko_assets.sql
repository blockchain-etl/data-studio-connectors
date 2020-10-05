SELECT * FROM
`crypto-public-data.aux.coingecko_assets` AS assets
WHERE contract_address = @token_address
