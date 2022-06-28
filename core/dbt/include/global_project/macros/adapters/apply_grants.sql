{% macro get_show_grant_sql(relation) %}
{{ return(adapter.dispatch("get_show_grant_sql", "dbt")(relation)) }}
{% endmacro %}

{% macro default__get_show_grant_sql(relation) %}
show grants on {{ relation.type }} {{ relation }}
{% endmacro %}

{% macro get_grant_sql(relation, grant_config) %}
{{ return(adapter.dispatch('get_grant_sql', 'dbt')(relation, grant_config)) }}
{% endmacro %}

{% macro default__get_grant_sql(relation, grant_config) %}
    {% for privilege in grant_config.keys() %}
     {{ log('privilege: ' ~ privilege) }}
        {% set grantees = grant_config[privilege] %}
        {% for grantee in grantees %}
            grant {{ privilege }} on {{ relation.type }} {{ relation }} to {{ grantee }};
        {% endfor %}
    {% endfor %}
{% endmacro %}

{% macro get_revoke_sql(relation, grant_config) %}
{{ return(adapter.dispatch("get_revoke_sql", "dbt")(relation, grant_config)) }}
{% endmacro %}

{% macro default__get_revoke_sql(relation, grant_config) %}
    {% for privilege in grant_config.keys() %}
        {% set grantees = grant_config[privilege] %}
        {% for grantee in grantees if grantee !=  target.user %}
            revoke {{ privilege }} on {{ relation.type }} {{ relation }} from {{ grantee }}
        {% endfor %}
    {% endfor %}
{% endmacro %}

{% macro apply_grants(relation, grant_config, should_revoke) %}
{{ return(adapter.dispatch("apply_grants", "dbt")(relation, grant_config, should_revoke=True)) }}
{% endmacro %}

{% macro default__apply_grants(relation, grant_config, should_revoke=True) %}
    {% if grant_config %}
        {% call statement('grants') %}
            {% if should_revoke %}
                {% set current_grants =  get_show_grant_sql(relation) %}
                {% set diff_grants = diff_of_two_dicts(grant_config, current_grants) %}
                {% set revoke_grants = get_revoke_sql(relation, diff_grants) %}
            {% endif %}
            {{ get_grant_sql(relation, grant_config) }}
        {% endcall %}
    {% endif %}
{% endmacro %}
