{#-- Pass the table name, statistics name, and column name on which to create the statistic --#}
{#-- Pass the table name, statistics name, and column name on which to create the statistic --#}
{#-- Pass the table name, statistics name, and column name on which to create the statistic --#}
{% macro update_statistics(table_name, statistics_name, column_name) %}
    {#-- Check for full refresh flag and create statistics if table is being dropped --#}
    {#-- Otherwise, update statistic --#}
    {% if flags.FULL_REFRESH %}
        {% set query %}
            CREATE STATISTICS {{ statistics_name }} on {{ table_name }} ({{ column_name }}) WITH FULLSCAN;

{% endset %}
    {% else %}
        {% set query %}
            UPDATE STATISTICS {{ table_name }}({{ statistics_name }}) ;


{% endset %}
    {% endif %}

    {% do run_query(query) %}
    {% do log(query, info=True) %}
{% endmacro %}