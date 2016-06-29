{%- from "elasticsearch/map.jinja" import server with context %}

elasticsearch_curator_packages:
  pkg.installed:
  - names: {{ server.curator_pkgs }}

elasticsearch_curator_config:
  file.managed:
  - name: /etc/elasticsearch/curator.yml
  - source: salt://elasticsearch/files/curator.yml
  - group: elasticsearch
  - mode: 750
  - template: jinja
  - require:
    - pkg: elasticsearch_packages

elasticsearch_curator_action_config:
  file.managed:
  - name: /etc/elasticsearch/curator_actions.yml
  - source: salt://elasticsearch/files/curator_actions.yml
  - group: elasticsearch
  - mode: 750
  - template: jinja
  - require:
    - file: elasticsearch_curator_config

elasticsearch_curator_cron:
  cron.present:
    - name: "curator --config /etc/elasticsearch/curator.yml /etc/elasticsearch/curator_actions.yml >/dev/null"
    - user: elasticsearch
    - minute: random
    - hour: 1
