elasticsearch:
  server:
    enabled: true
    bind:
      address: 0.0.0.0
      port: 9200
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