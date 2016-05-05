
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

Read more
=========


* https://www.elastic.co/
* http://alex.nederlof.com/blog/2012/11/19/installing-elasticsearch-with-jenkins-on-ubuntu/
* http://websightdesigns.com/wiki/Setting_up_Centralized_Event_Parsing_on_Ubuntu_12.04
* https://gist.github.com/wingdspur/2026107
