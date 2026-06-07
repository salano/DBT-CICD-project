{{
  config(
        materialized = "view",
        schema='gold'
    )
}}

WITH claims AS (
  /*---------------------------------------------------------------------------
        1 Base Query: Retrieves core columns from silver.claims
        ---------------------------------------------------------------------------*/
  SELECT
    [claim_id],
    [policy_id],
    [claim_date],
    [claim_amount],
    [status],
    [deductible],
    [claim_reason],
    [is_fraud],
    [Zip_Code]
  FROM
    {{ ref('gt_ins_claims') }}
),
policies AS (
  /*---------------------------------------------------------------------------
        1 Base Query: Retrieves core columns from silver.policies
        ---------------------------------------------------------------------------*/
  SELECT
    [policy_id],
    [cust_id],
    [policy_type],
    [status] AS [policy_status],
    [start_date],
    [end_date],
    [coverage_amount],
    [annual_premium],
    [monthly_payment],
    [distribution_channel],
    [dbt_valid_to]
  FROM
    {{ ref('st_ins_policies') }}
),
customers AS (
  /*---------------------------------------------------------------------------
        1 Base Query: Retrieves core columns from silver.customers
        ---------------------------------------------------------------------------*/
  SELECT
    [cust_id],
    [Date_of_Birth],
    [Gender],
    [Contact_Number],
    [CustomerName],
    [dbt_valid_to]
  FROM
    {{ ref('st_ins_customers') }}
)
SELECT
  c.[claim_id],
  c.[claim_date],
  c.[claim_amount],
  c.[status],
  c.[deductible],
  c.[claim_reason],
  c.[is_fraud],
  c.[Zip_Code],
  p.[policy_id],
  p.[policy_type],
  p.[policy_status],
  p.[start_date],
  p.[end_date],
  p.[coverage_amount],
  p.[annual_premium],
  p.[monthly_payment],
  p.[distribution_channel],
  cu.[cust_id],
  cu.[Date_of_Birth],
  cu.[Gender],
  cu.[Contact_Number],
  cu.[CustomerName]
FROM
  customers AS cu
LEFT JOIN
  policies AS p
  ON cu.[cust_id] = p.[cust_id]
LEFT JOIN
  claims AS c
  ON p.[policy_id] = c.[policy_id]
WHERE
  p.[dbt_valid_to] IS NULL
  AND cu.[dbt_valid_to] IS NULL
