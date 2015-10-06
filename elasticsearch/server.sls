{%- from "elasticsearch/map.jinja" import server with context %}
{%- if server.enabled %}

include:
  - java

elasticsearch_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

elasticsearch_config:
  file.managed:
  - name: /etc/elasticsearch/elasticsearch.yml
  - source: salt://elasticsearch/files/elasticsearch.yml
  - template: jinja
  - require:
    - pkg: elasticsearch_packages

elasticsearch_service:
  service.running:
  - enable: true
  - name: {{ server.service }}
  - watch:
    - file: elasticsearch_config

{%- endif %}