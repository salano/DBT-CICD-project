{% snapshot st_ins_policies %}

{{
  config(
    target_schema='silver',
    strategy='check',
    check_cols='all',
    unique_key='policy_id',
    updated_at='last_updated',
    invalidate_hard_deletes=True,
    schema='silver',
    alias='st_ins_policies',
    file_format='delta',
    post_hook="{{update_statistics(this,'PoliciesStatistics','policy_id')}}"
  )
}}


WITH ranked_source AS ( 

SELECT
        [policy_id],
        [cust_id],
        [policy_type],
        [status],
        [start_date],
        [end_date],
        [coverage_amount],
        [annual_premium],
        [monthly_payment],
        [distribution_channel],
        CAST(getdate() AS datetime2(6)) AS [last_updated],
        ROW_NUMBER() OVER (PARTITION BY [policy_id] ORDER BY [policy_id] DESC) AS [dbt_row_num]
    FROM {{ source('landing', 'pol') }}

/* DATA CLEANSING, FORMATTING, DEDUPLICATION */


) SELECT 
    * 
  FROM 
    ranked_source
  WHERE 
    [dbt_row_num] = 1

{% endsnapshot %}