
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

Setup shared repository for snapshots:

.. code-block:: bash

    elasticsearch:
      server:
        snapshot:
          reponame:
            path: /var/lib/glusterfs/repo
            compress: true

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
          master_only: true
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

Client with host and port:

.. code-block:: yaml

    elasticsearch:
      client:
        enabled: true
        server:
          host: elasticsearch.host
          port: 9200

Client where you download an index template that is stored in the directory
*files/*:

.. code-block:: yaml

    elasticsearch:
      client:
        enabled: true
        server:
          host: elasticsearch.host
          port: 9200
        index:
          my_index:
            enabled: true
            template: elasticsearch/files/my_index_template.json

Client where you download an index template from the metadata definition and force index creation:

.. code-block:: yaml

    elasticsearch:
      client:
        enabled: true
        server:
          host: elasticsearch.host
          port: 9200
        index:
          my_index:
            enabled: true
            force_operation: true
            definition:
              template: notifications
              settings:
                number_of_shards: 5
                number_of_replicas: 1
              mappings:
                notification:
                  properties:
                    applicationId:
                      type: long
                    content:
                      type: text
                      fields:
                        keyword:
                          type: keyword
                          ignore_above: 256

Upgrade operations
------------------

Default elasticsearch client state can only create index temlates. To update exisiting ones according to pillar dedicated state should be run explicitly:

.. code-block:: bash

    salt -C 'I@elasticsearch:client' state.sls elasticsearch.client.update_index_templates

Read more
=========


* https://www.elastic.co/
* http://alex.nederlof.com/blog/2012/11/19/installing-elasticsearch-with-jenkins-on-ubuntu/
* http://websightdesigns.com/wiki/Setting_up_Centralized_Event_Parsing_on_Ubuntu_12.04
* https://gist.github.com/wingdspur/2026107

Documentation and Bugs
======================

To learn how to install and update salt-formulas, consult the documentation
available online at:

    http://salt-formulas.readthedocs.io/

In the unfortunate event that bugs are discovered, they should be reported to
the appropriate issue tracker. Use Github issue tracker for specific salt
formula:

    https://github.com/salt-formulas/salt-formula-elasticsearch/issues

For feature requests, bug reports or blueprints affecting entire ecosystem,
use Launchpad salt-formulas project:

    https://launchpad.net/salt-formulas

You can also join salt-formulas-users team and subscribe to mailing list:

    https://launchpad.net/~salt-formulas-users

Developers wishing to work on the salt-formulas projects should always base
their work on master branch and submit pull request against specific formula.

    https://github.com/salt-formulas/salt-formula-elasticsearch

Any questions or feedback is always welcome so feel free to join our IRC
channel:

    #salt-formulas @ irc.freenode.net
