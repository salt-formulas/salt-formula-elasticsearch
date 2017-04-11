elasticsearch:
  server:
    enabled: true
    bind:
      address: 0.0.0.0
      port: 9200
    cluster:
      multicast: false
    index:
      shards: 1
      replicas: 0
