{{
  config(
    materialized='incremental',
    unique_key='claim_id',
    schema='gold',
    on_schema_change='append_new_columns',
    post_hook="{{update_statistics(this,'ClaimsStatistics','claim_id')}}"
  )
}}

WITH silver_table AS (

  SELECT
    [claim_id],
    [policy_id],
    [claim_date],
    [claim_amount],
    [status],
    [gender],
    [deductible],
    [claim_reason],
    [is_fraud],
    [Zip_Code],
    CAST(GETDATE() AS DATETIME2(6)) AS [last_updated]
  FROM
    {{ source('landing', 'claims') }}

) SELECT *
FROM
  silver_table

{% if is_incremental() and not flags.EMPTY %}
  WHERE claim_date > (SELECT COALESCE(MAX(claim_date), '1900-01-01 00:00:00') FROM {{ this }})

{% endif %}