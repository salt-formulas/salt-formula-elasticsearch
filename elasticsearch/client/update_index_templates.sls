{%- from "elasticsearch/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

include:
  - elasticsearch.client.service

{%- for index_name, index in client.get('index', {}).iteritems() %}
# TODO: "Replace with module.run when bug is fixed".
# Since bug in retry logic in salt (#49895) we need to use a workaround for now.
elasticsearch_check_cluster_status_before_index_template_upgrade_{{ index_name }}:
  cmd.run:
  - name: curl -sf {{ client.server.host }}:{{ client.server.port }}/_cat/health | awk '{print $4}' | grep green
  - retry:
      attempts: 5
      until: True
      interval: 10
      splay: 5

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
