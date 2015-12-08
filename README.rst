
=============
Elasticsearch
=============

Elasticsearch provides a distributed, multitenant-capable full-text search engine with a HTTP web interface and schema-free JSON documents.

Sample pillars
==============

.. code-block:: yaml

    elasticsearch:
      server:
        enabled: true
        version: 1.0.1
        bind:
          address: 0.0.0.0
          port: 9200

Read more
=========


* https://www.elastic.co/
* http://alex.nederlof.com/blog/2012/11/19/installing-elasticsearch-with-jenkins-on-ubuntu/
* http://websightdesigns.com/wiki/Setting_up_Centralized_Event_Parsing_on_Ubuntu_12.04
* https://gist.github.com/wingdspur/2026107
