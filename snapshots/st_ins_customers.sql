
{% snapshot st_ins_customers %}

{{
  config(
    target_schema='silver',
    strategy='check',
    check_cols='all',
    unique_key='cust_id',
    updated_at='last_updated',
    invalidate_hard_deletes=True,
    schema='silver',
    alias='st_ins_customers',
    file_format='delta',
    post_hook="{{update_statistics(this,'CustomersStatistics','cust_id')}}"
  )
}}


WITH ranked_source AS ( 

SELECT
        [cust_id],
        [Date_of_Birth],
        [Gender],
        [Contact_Number],
        [CustomerName],
        CAST(getdate() AS datetime2(6)) AS [last_updated],
        ROW_NUMBER() OVER (PARTITION BY [cust_id] ORDER BY [cust_id] DESC) AS [dbt_row_num]
    FROM {{ source('landing', 'cust') }}

/* DATA CLEANSING, FORMATTING, DEDUPLICATION */


) SELECT 
    * 
  FROM 
    ranked_source
  WHERE 
    [dbt_row_num] = 1

{% endsnapshot %}