{%- from "elasticsearch/map.jinja" import server with context %}
{%- if server.enabled %}

{%- if server.curator is defined %}
include:
  - elasticsearch.server.curator
{%- endif %}

elasticsearch_packages:
  pkg.installed:
  - pkgs: {{ server.pkgs }}

{%- if server.version <= "5.0.0" %}
elasticsearch_default:
  file.managed:
  - name: /etc/default/elasticsearch
  - source: salt://elasticsearch/files/elasticsearch
  - template: jinja
  - require:
    - pkg: elasticsearch_packages
{%- elif server.version >= "5.0.0" %}
elasticsearch_default:
  file.managed:
  - name: /etc/default/elasticsearch
  - source: salt://elasticsearch/files/elasticsearch-5
  - template: jinja
  - require:
    - pkg: elasticsearch_packages
{%- endif %}

elasticsearch_config:
  file.managed:
  - name: /etc/elasticsearch/elasticsearch.yml
  - source: salt://elasticsearch/files/elasticsearch.yml
  - template: jinja
  - require:
    - pkg: elasticsearch_packages

{%- if server.version >= "5.0.0" %}
elasticsearch_jvm_conf:
  file.managed:
  - name: /etc/elasticsearch/jvm.options
  - source: salt://elasticsearch/files/jvm.options
  - template: jinja
  - require:
    - pkg: elasticsearch_packages
{%- endif %}

{%- if server.version >= "5.0.0" %}
elasticsearch_logging:
  file.managed:
  - name: /etc/elasticsearch/log4j2.properties
  - source: salt://elasticsearch/files/log4j2.properties
  - template: jinja
  - require:
    - pkg: elasticsearch_packages
{%- else %}
elasticsearch_logging:
  file.managed:
  - name: /etc/elasticsearch/logging.yml
  - source: salt://elasticsearch/files/logging.yml
  - template: jinja
  - require:
    - pkg: elasticsearch_packages
{%- endif %}

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

elasticsearch_service:
  service.running:
  - enable: true
  - name: {{ server.service }}
  {%- if grains.get('noservices') %}
  - onlyif: /bin/false
  {%- endif %}
  - watch:
    - file: elasticsearch_config
    - file: elasticsearch_logging
    - file: elasticsearch_default

{%- endif %}
