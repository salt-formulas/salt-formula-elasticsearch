{%- from "elasticsearch/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

/etc/salt/minion.d/_elasticsearch.conf:
  file.managed:
  - source: salt://elasticsearch/files/_elasticsearch.conf
  - template: jinja
  - user: root
  - group: root

elasticsearch_client_packages:
  pkg.installed:
  - names: {{ client.pkgs }}

{%- endif %}
