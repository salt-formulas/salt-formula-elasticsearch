{%- from "elasticsearch/map.jinja" import client with context %}
{%- if client.get('enabled', False) %}

elasticsearch_client_packages:
  pkg.installed:
  - names: {{ client.pkgs }}

{%- endif %}
