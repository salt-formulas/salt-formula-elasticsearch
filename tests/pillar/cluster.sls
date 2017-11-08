elasticsearch:
  server:
    enabled: true
    bind:
      address: 0.0.0.0
      port: 9200
    cluster:
      multicast: false
      members:
        - host: elastic01
          port: 9300
        - host: elastic02
          port: 9300
        - host: elastic03
          port: 9300
    index:
      shards: 5
      replicas: 1
    version: 2