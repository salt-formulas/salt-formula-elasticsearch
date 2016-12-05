{%- from "elasticsearch/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

include:
  - elasticsearch.client.service

{%- for index_name, index in client.get('index', {}).iteritems() %}
elasticsearch_index_{{ index_name }}:
  {%- if index.get('enabled', False) %}
  elasticsearch_index_template.present:
  {%- import_json index.template as definition %}
  - name: {{ index_name }}
  - definition: '{{ definition|json }}'
  {%- else %}
  elasticsearch_index_template.absent:
  - name: {{ index_name }}
  {%- endif %}
  - require:
    - pkg: elasticsearch_client_packages
{%- endfor %}

{%- endif %}
