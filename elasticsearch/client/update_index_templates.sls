{%- from "elasticsearch/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

include:
  - elasticsearch.client.service

{%- for index_name, index in client.get('index', {}).iteritems() %}
elasticsearch_index_template_upgrade_{{ index_name }}:

  {%- if index.get('enabled', False) %}

    {%- if index.definition is defined %}
      {% set definition = index.definition %}
    {%- endif %}
    {%- if index.template is defined %}
      {%- import_json index.template as definition %}
    {%- endif %}

    {%- if definition is defined %}
  module.run:
  - name: elasticsearch.index_template_create
  - m_name: {{ index_name }}
  - body: '{{ definition|json }}'
  - require:
    - pkg: elasticsearch_client_packages
    {%- endif %}

  {%- endif %}

{%- endfor %}
{%- endif %}
