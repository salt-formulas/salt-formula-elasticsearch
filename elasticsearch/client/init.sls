{%- from "elasticsearch/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

include:
  - elasticsearch.client.service

{%- for index_name, index in client.get('index', {}).iteritems() %}
elasticsearch_index_{{ index_name }}:

  {%- if index.get('enabled', False) %}
  {% set operation = 'create' %}

  {%- if index.definition is defined %}
  {% set definition = index.definition %}
  {%- endif %}

  {%- if index.template is defined %}
  {%- import_json index.template as definition %}
  {%- endif %}

  {%- if definition is defined %}
  elasticsearch_index_template.present:
  - name: {{ index_name }}
  - definition: '{{ definition|json }}'
  {%- else %}
  cmd.run:
  - name: echo "No definition specified for index {{ index_name }}"
  {%- endif %}

  {%- else %}

  {% set operation = 'delete' %}
  elasticsearch_index_template.absent:
  - name: {{ index_name }}
  {%- endif %}

  - require:
    - pkg: elasticsearch_client_packages

{%- if index.get('force_operation', False) %}
elasticsearch_index_{{ index_name }}_{{ operation }}:
  {% set curdate = None | strftime('%Y.%m.%d') %}
  module.run:
    - name: elasticsearch.index_{{ operation }}
    - index: {{ index_name }}-{{ curdate }}
{%- else %}
elasticsearch_index_{{ index_name }}_{{ operation }}:
  module.run:
    - name: elasticsearch.index_{{ operation }}
    - index: {{ index_name }}
{%- endif %}

{%- endfor %}

{%- endif %}
