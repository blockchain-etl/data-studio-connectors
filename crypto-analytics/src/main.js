const cc = DataStudioApp.createCommunityConnector();

// https://developers.google.com/datastudio/connector/reference#isadminuser
function isAdminUser() {
  // TODO: update. Set to true to ease initial debugging.
  return true;
}

const DEFAULT_CONTRACT_ADDRESS = "0x7be8076f4ea4a4ad08075c2508e481d6c946d12b";

// TODO: figure out how to programmatically get the user's project ID.
const DEFAULT_PROJECT_ID = "origin-214503";

const bqTypes = DataStudioApp.createCommunityConnector().BigQueryParameterType;

// https://developers.google.com/datastudio/connector/reference#getconfig
function getConfig(request) {
  const config = cc.getConfig();

  config
    .newInfo()
    .setId("cryptoAnalytics")
    .setText("Google Data Studio - Community crypto analytics connector");

  config
    .newTextInput()
    .setId("projectId")
    .setName("Enter your GCP project ID")
    .setHelpText("You can find your GCP project ID on your the GCP console")
    .setPlaceholder(DEFAULT_PROJECT_ID);

  config
    .newTextInput()
    .setId("contractAddress")
    .setName("Enter an Ethereum contact adddress")
    .setPlaceholder(DEFAULT_CONTRACT_ADDRESS)
    .setAllowOverride(true);

  // This forces a date range object to be provided for `getData()` requests.
  // https://developers.google.com/apps-script/reference/data-studio/config#setDateRangeRequired(Boolean)
  config.setDateRangeRequired(true);

  return config.build();
}

function getFields() {
  const fields = cc.getFields();
  const types = cc.FieldType;

  fields
    .newMetric()
    .setId("session_id")
    .setName("session_id")
    .setDescription("")
    .setType(types.TEXT);

  fields
    .newMetric()
    .setId("session_start_block_timestamp")
    .setName("session_start_block_timestamp")
    .setDescription("")
    .setType(types.YEAR_MONTH_DAY_SECOND)
    .setGroup('DATETIME');

  fields
    .newMetric()
    .setId("session_start_block_number")
    .setName("session_start_block_number")
    .setDescription("")
    .setType(types.NUMBER);

  fields
    .newMetric()
    .setId("session_end_block_timestamp")
    .setName("session_end_block_timestamp")
    .setDescription("")
    .setType(types.YEAR_MONTH_DAY_SECOND);

  fields
    .newMetric()
    .setId("session_end_block_number")
    .setName("session_end_block_number")
    .setDescription("")
    .setType(types.NUMBER);

  fields
    .newMetric()
    .setId("session_wallet_address")
    .setName("session_wallet_address")
    .setDescription("")
    .setType(types.TEXT);

  fields
    .newMetric()
    .setId("session_contract_address")
    .setName("session_contract_address")
    .setDescription("")
    .setType(types.TEXT);

  fields
    .newMetric()
    .setId("session_events_cnt")
    .setName("session_events_cnt")
    .setDescription("")
    .setType(types.NUMBER);

  fields
    .newMetric()
    .setId("session_duration_minutes")
    .setName("session_duration_minutes")
    .setDescription("")
    .setType(types.NUMBER);

  fields
    .newMetric()
    .setId("session_duration_blocks")
    .setName("session_duration_blocks")
    .setDescription("")
    .setType(types.NUMBER);

  fields
    .newMetric()
    .setId("first_session_start_block_timestamp")
    .setName("first_session_start_block_timestamp")
    .setDescription("")
    .setType(types.YEAR_MONTH_DAY_SECOND);

   fields
    .newMetric()
    .setId("first_session_start_block_number")
    .setName("first_session_start_block_number")
    .setDescription("")
    .setType(types.TEXT);

  fields
    .newMetric()
    .setId("next_session_start_block_timestamp")
    .setName("next_session_start_block_timestamp")
    .setDescription("")
    .setType(types.YEAR_MONTH_DAY_SECOND);

  fields
    .newMetric()
    .setId("next_session_start_block_number")
    .setName("next_session_start_block_number")
    .setDescription("")
    .setType(types.NUMBER);

  fields
    .newMetric()
    .setId("prev_session_start_block_timestamp")
    .setName("prev_session_start_block_timestamp")
    .setDescription("")
    .setType(types.YEAR_MONTH_DAY_SECOND);

  fields
    .newMetric()
    .setId("prev_session_start_block_number")
    .setName("prev_session_start_block_number")
    .setDescription("")
    .setType(types.NUMBER);

  fields
    .newDimension()
    .setId("is_new_user")
    .setName("is_new_user")
    .setDescription("")
    .setType(types.BOOLEAN);


  return fields;
}

// https://developers.google.com/datastudio/connector/reference#getschema
function getSchema(request) {
  const fields = getFields();
  return cc
    .newGetSchemaResponse()
    .setFields(fields)
    .build();
}

// https://developers.google.com/datastudio/connector/reference#getdata
const sqlString = `
  WITH first_sessions AS (
    SELECT * FROM (
      SELECT
        wallet_address       AS wallet_address,
        contract_address     AS contract_address,

        FIRST_VALUE(id) OVER (
          PARTITION BY wallet_address, contract_address
          ORDER BY start_block_timestamp ASC
        )
                             AS id,

        FIRST_VALUE(start_trace_id) OVER (
          PARTITION BY wallet_address, contract_address
          ORDER BY start_block_timestamp ASC
        )
                             AS start_trace_id,

        FIRST_VALUE(start_block_number) OVER (
          PARTITION BY wallet_address, contract_address
          ORDER BY start_block_timestamp ASC
        )
                             AS start_block_number,

        FIRST_VALUE(start_block_timestamp) OVER (
          PARTITION BY wallet_address, contract_address
          ORDER BY start_block_timestamp ASC
        )
                             AS start_block_timestamp,

        ROW_NUMBER() OVER (
          PARTITION BY wallet_address, contract_address
          ORDER BY start_block_timestamp ASC
        )
                             AS rn
      FROM
          bigquery-public-data.crypto_ethereum.sessions AS sessions
      WHERE
          contract_address = @contractAddress
    )
    WHERE
      rn = 1
  ),
  sessions AS (
    SELECT
      id                     AS id,
      start_trace_id         AS start_trace_id,
      start_block_number     AS start_block_number,
      start_block_timestamp  AS start_block_timestamp,
      wallet_address         AS wallet_address,
      contract_address       AS contract_address,

      LEAD(start_block_timestamp) OVER (
          PARTITION BY wallet_address, contract_address
          ORDER BY start_block_timestamp ASC
        )
                             AS next_session_start_block_timestamp,

      LEAD(start_block_number) OVER (
          PARTITION BY wallet_address, contract_address
          ORDER BY start_block_timestamp ASC
        )
                             AS next_session_start_block_number,

      LAG(start_block_timestamp) OVER (
          PARTITION BY wallet_address, contract_address
          ORDER BY start_block_timestamp ASC
        )
                             AS prev_session_start_block_timestamp,

      LAG(start_block_number) OVER (
          PARTITION BY wallet_address, contract_address
          ORDER BY start_block_timestamp ASC
        )
                             AS prev_session_start_block_number
    FROM
      bigquery-public-data.crypto_ethereum.sessions AS sessions
    WHERE
      contract_address = @contractAddress
      AND DATE(start_block_timestamp) >= @startDate
      AND DATE(start_block_timestamp) <= @endDate
  ),
  root_call_traces AS (
    SELECT
      trace_id         AS trace_id,
      from_address     AS wallet_address,
      to_address       AS contract_address,
      transaction_hash AS transaction_hash,
      block_timestamp  AS block_timestamp,
      block_hash       AS block_hash,
      block_number     AS block_number,
      value            AS value,
      gas              AS gas,
      gas_used         AS gas_used,
      trace_type       AS trace_type,
      call_type        AS call_type,
      error            AS error,
      status           AS status
    FROM
      bigquery-public-data.crypto_ethereum.traces AS traces
    WHERE
      -- TODO:  We haven't filtered errors. Might want a metric for these.
      trace_address IS NULL
      AND trace_type = 'call'
      AND to_address = @contractAddress
      AND DATE(block_timestamp) >= @startDate
      -- Includes traces from the following day so sessions beginning at the end of the date range have all events.
      AND DATE_SUB(DATE(block_timestamp), INTERVAL 1 DAY) <= @endDate
    ORDER BY
      wallet_address,
      block_timestamp ASC
  )
  SELECT
    sessions.id                                                      AS session_id,
    FORMAT_DATETIME("%Y%m%d%H%M%S", sessions.start_block_timestamp)  AS session_start_block_timestamp,
    sessions.start_block_number                                      AS session_start_block_number,
    FORMAT_DATETIME("%Y%m%d%H%M%S", MAX(traces.block_timestamp))     AS session_end_block_timestamp,
    MAX(traces.block_number)                                         AS session_end_block_number,
    sessions.wallet_address                                          AS session_wallet_address,
    sessions.contract_address                                        AS session_contract_address,
    COUNT(*)                                                         AS session_events_cnt,

    DATETIME_DIFF(MAX(traces.block_timestamp), MIN(traces.block_timestamp), MINUTE)
                                                                     AS session_duration_minutes,

    MAX(traces.block_number) - MIN(traces.block_number)              AS session_duration_blocks,

    FORMAT_DATETIME("%Y%m%d%H%M%S", first_sessions.start_block_timestamp)
                                                                     AS first_session_start_block_timestamp,

    first_sessions.start_block_number                                AS first_session_start_block_number,

    FORMAT_DATETIME("%Y%m%d%H%M%S", sessions.next_session_start_block_timestamp)
                                                                     AS next_session_start_block_timestamp,

    sessions.next_session_start_block_number                         AS next_session_start_block_number,

    FORMAT_DATETIME("%Y%m%d%H%M%S", sessions.prev_session_start_block_timestamp)
                                                                     AS prev_session_start_block_timestamp,

    sessions.prev_session_start_block_number                         AS prev_session_start_block_number,

    CASE
      WHEN sessions.id = first_sessions.id THEN TRUE
      ELSE FALSE
    END
                                                                     AS is_new_user
  FROM
    sessions
  LEFT JOIN
    root_call_traces AS traces
  ON
    traces.wallet_address = sessions.wallet_address
    AND traces.contract_address = sessions.contract_address
    AND traces.block_timestamp >= sessions.start_block_timestamp
    AND (
      traces.block_timestamp < sessions.next_session_start_block_timestamp
      OR sessions.next_session_start_block_timestamp IS NULL
    )
  LEFT JOIN
    first_sessions
  ON
    sessions.wallet_address = first_sessions.wallet_address
    AND sessions.contract_address = first_sessions.contract_address
  GROUP BY
    session_id,
    session_start_block_timestamp,
    session_start_block_number,
    session_wallet_address,
    session_contract_address,
    first_session_start_block_timestamp,
    first_session_start_block_number,
    next_session_start_block_timestamp,
    next_session_start_block_number,
    prev_session_start_block_timestamp,
    prev_session_start_block_number,
    is_new_user;
`;

function getData(request) {
  const startDate = request.dateRange.startDate;
  const endDate = request.dateRange.endDate;
  const contractAddress = request.configParams.contractAddress;
  if (!contractAddress) {
    cc.newUserError()
      .setDebugText("No contract address provided")
      .setText("No contract address provided")
      .throwException();
  }

  console.log(`REQUEST=${JSON.stringify(request)}`);
  let response;
  try {
    const authToken = ScriptApp.getOAuthToken();
    response = cc
      .newBigQueryConfig()
      .setAccessToken(authToken)
      .setUseStandardSql(true)
      .setBillingProjectId(request.configParams.projectId)
      .setQuery(sqlString)
      .addQueryParameter("contractAddress", bqTypes.STRING, contractAddress)
      .addQueryParameter('startDate', bqTypes.STRING, startDate)
      .addQueryParameter('endDate', bqTypes.STRING, endDate)
      .build();
  } catch (e) {
    cc.newUserError()
      .setDebugText("Error fetching data from API. Exception: " + e)
      .setText("Error fetching data from API.")
      .throwException();
  }
  console.log(`RESPONSE=${JSON.stringify(response)}`);
  return response;
}
