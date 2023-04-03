#!/usr/bin/bash

helm upgrade --install influxdb influxdata/influxdb2 -f influxdata/influxdb.yaml
