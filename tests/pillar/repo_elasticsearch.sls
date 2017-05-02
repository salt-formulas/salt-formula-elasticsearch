linux:
  system:
    enabled: true
    repo:
      elasticsearch_repo:
        source: "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main"
        architectures: amd64
        key_url: "https://packages.elastic.co/GPG-KEY-elasticsearch"
      mirantis_openstack_repo:
        source: "deb http://mirror.fuel-infra.org/mcp-repos/1.0/{{ grains.get('oscodename') }} mitaka main"
        architectures: amd64
        key_url: "http://mirror.fuel-infra.org/mcp-repos/1.0/{{ grains.get('oscodename') }}/archive-mcp1.0.key"
