
{%- if pillar.elasticsearch is defined %}
include:
{%- if pillar.elasticsearch.server is defined %}
- elasticsearch.server
{%- endif %}
{%- if pillar.elasticsearch.client is defined %}
- elasticsearch.client
{%- endif %}
{%- endif %}
