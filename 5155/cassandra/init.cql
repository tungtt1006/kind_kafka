    CREATE KEYSPACE quine WITH replication = {'class': 'SimpleStrategy', 'replication_factor': '1'};

    USE quine;

    CREATE TABLE domain_graph_nodes (
        dgn_id bigint PRIMARY KEY,
        data blob
    );

    CREATE TABLE domain_index_events (
        quine_id blob,
        timestamp bigint,
        data blob,
        dgn_id bigint,
        PRIMARY KEY (quine_id, timestamp)
    ) WITH CLUSTERING ORDER BY (timestamp ASC)
        AND compaction = {'class': 'org.apache.cassandra.db.compaction.TimeWindowCompactionStrategy'};

    CREATE TABLE journals (
        quine_id blob,
        timestamp bigint,
        data blob,
        PRIMARY KEY (quine_id, timestamp)
    ) WITH CLUSTERING ORDER BY (timestamp ASC)
        AND compaction = {'class': 'org.apache.cassandra.db.compaction.TimeWindowCompactionStrategy'};

    CREATE TABLE meta_data (
        key text PRIMARY KEY,
        value blob
    );

    CREATE TABLE snapshots (
        quine_id blob,
        timestamp bigint,
        multipart_index int,
        data blob,
        multipart_count int,
        PRIMARY KEY (quine_id, timestamp, multipart_index)
    ) WITH CLUSTERING ORDER BY (timestamp DESC, multipart_index ASC);

    CREATE TABLE standing_queries (
        query_id uuid PRIMARY KEY,
        queries blob
    );

    CREATE TABLE standing_query_states (
        quine_id blob,
        standing_query_id uuid,
        standing_query_part_id uuid,
        data blob,
        PRIMARY KEY (quine_id, standing_query_id, standing_query_part_id)
    ) WITH CLUSTERING ORDER BY (standing_query_id ASC, standing_query_part_id ASC);
