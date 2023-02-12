#!/bin/sh

kubectl apply -f cassandra/config.yaml

kubectl apply -f cassandra/config-initdb.yaml

helm upgrade --install cassandra bitnami/cassandra -f cassandra/values.yaml
