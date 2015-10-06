
{% if pillar.elasticsearch.server is defined %}
include:
- elasticsearch.server
{% endif %}
