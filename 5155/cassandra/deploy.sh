#!/bin/sh

# SELECT * FROM system_schema.keyspaces;

kubectl apply -f cassandra/cassandra-initdb.yaml

helm upgrade --install cassandra bitnami/cassandra -f cassandra/values.yaml
