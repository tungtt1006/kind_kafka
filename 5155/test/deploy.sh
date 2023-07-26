#!/bin/sh

helm upgrade cassandra bitnami/cassandra -i --version 10.0.0 -f cassandra.yaml
