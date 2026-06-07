{{
  config(
        materialized = "view",
        schema='gold'
    )
}}

WITH base_query AS (
  /*---------------------------------------------------------------------------
        1) Base Query: Retrieves core columns from silver.policies
  ---------------------------------------------------------------------------*/
  SELECT
    [cust_id],
    [policy_id],
    [policy_type],
    [status] AS [policy_status],
    [start_date],
    [end_date],
    [coverage_amount],
    [annual_premium],
    [monthly_payment],
    [distribution_channel]
  FROM
    {{ ref('st_ins_policies') }}
  WHERE
    [dbt_valid_to] IS NULL

)
SELECT *
FROM
  base_query