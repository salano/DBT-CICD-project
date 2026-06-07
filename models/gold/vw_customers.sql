{{
  config(
        materialized = "view",
        schema='gold'
    )
}}

WITH base_query AS (
  /*---------------------------------------------------------------------------
        1) Base Query: Retrieves core columns from gold.claims, gold.customers and gold.policies
        ---------------------------------------------------------------------------*/
  SELECT
    [cust_id],
    [Date_of_Birth],
    [Gender],
    [Contact_Number],
    [CustomerName]
  FROM
    {{ ref('st_ins_customers') }}
)
SELECT *
FROM
  base_query