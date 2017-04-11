{%- from "elasticsearch/map.jinja" import server with context %}
{%- if server.enabled %}

{%- if server.curator is defined %}
include:
  - elasticsearch.server.curator
{%- endif %}

elasticsearch_packages:
  pkg.installed:
  - names: {{ server.pkgs }}

elasticsearch_default:
  file.managed:
  - name: /etc/default/elasticsearch
  - source: salt://elasticsearch/files/elasticsearch
  - template: jinja
  - require:
    - pkg: elasticsearch_packages

elasticsearch_config:
  file.managed:
  - name: /etc/elasticsearch/elasticsearch.yml
  - source: salt://elasticsearch/files/elasticsearch.yml
  - template: jinja
  - require:
    - pkg: elasticsearch_packages

elasticsearch_logging:
  file.managed:
  - name: /etc/elasticsearch/logging.yml
  - source: salt://elasticsearch/files/logging.yml
  - template: jinja
  - require:
    - pkg: elasticsearch_packages

{%- if server.get('log', {}).logrotate|default(True) and not
       salt['file.file_exists' ]('/etc/logrotate.d/elasticsearch') %}
{#
  Create logrotate config only if it doesn't already exist to avoid conflict
  with logrotate formula or possibly package-shipped config
#}
elasticsearch_logrotate:
  file.managed:
  - name: /etc/logrotate.d/elasticsearch
  - source: salt://elasticsearch/files/logrotate.conf
  - template: jinja
{%- endif %}

{%- if not grains.get('noservices','false')%}

elasticsearch_service:
  service.running:
  - enable: true
  - name: {{ server.service }}
  - watch:
    - file: elasticsearch_config
    - file: elasticsearch_logging
    - file: elasticsearch_default

{%- endif %}

{%- endif %}
