#!/bin/sh

helm upgrade --install influxdb influxdata/influxdb2 -f influxdata/influxdb.yaml
