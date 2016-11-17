
=============
Elasticsearch
=============

Elasticsearch provides a distributed, multitenant-capable full-text search engine with a HTTP web interface and schema-free JSON documents.

Sample pillars
==============

Single-node elasticsearch with clustering disabled:

.. code-block:: yaml

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

Cluster with manually defined members:

.. code-block:: yaml

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

Common definition for curator:

.. code-block:: yaml

    elasticsearch:
      server:
        curator:
          timeout: 900
          logfile: /var/log/elasticsearch/curator.log
          logformat: json
          actions:
            - action: delete_indices
              description: >-
                Delete indices older than 45 days (based on index name).
                Ignore the error if the filter does not result in an actionable
                list of indices (ignore_empty_list) and exit cleanly.
              options:
                ignore_empty_list: True
                continue_if_exception: False
                disable_action: False
              filters:
                - filtertype: pattern
                  kind: regex
                  value: '.*\-\d\d\d\d\.\d\d\.\d\d$'
                - filtertype: age
                  source: name
                  direction: older
                  timestring: '%Y.%m.%d'
                  unit: days
                  unit_count: 90
            - action: replicas
              description: >-
                Reduce the replica count to 0 for indices older than 30 days
                (based on index creation_date)
              options:
                count: 0
                wait_for_completion: False
                continue_if_exception: False
                disable_action: False
              filters:
                - filtertype: pattern
                  kind: regex
                  value: '.*\-\d\d\d\d\.\d\d\.\d\d$'
                - filtertype: age
                  source: creation_date
                  direction: older
                  unit: days
                  unit_count: 30
            - action: forcemerge
              description: >-
                forceMerge indices older than 2 days (based on index
                creation_date) to 2 segments per shard.  Delay 120 seconds
                between each forceMerge operation to allow the cluster to
                quiesce.
                This action will ignore indices already forceMerged to the same
                or fewer number of segments per shard, so the 'forcemerged'
                filter is unneeded.
              options:
                max_num_segments: 2
                delay: 120
                continue_if_exception: False
                disable_action: True
              filters:
                - filtertype: pattern
                  kind: regex
                  value: '.*\-\d\d\d\d\.\d\d\.\d\d$'
                - filtertype: age
                  source: creation_date
                  direction: older
                  unit: days
                  unit_count: 2

Client setup
------------

Client with host and port

.. code-block:: yaml

    elasticsearch:
      client:
        enabled: true
        server:
          host: elasticsearch.host
          port: 9200

Read more
=========


* https://www.elastic.co/
* http://alex.nederlof.com/blog/2012/11/19/installing-elasticsearch-with-jenkins-on-ubuntu/
* http://websightdesigns.com/wiki/Setting_up_Centralized_Event_Parsing_on_Ubuntu_12.04
* https://gist.github.com/wingdspur/2026107
