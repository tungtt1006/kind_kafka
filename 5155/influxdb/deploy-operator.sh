#!/bin/sh

helm install influxdb influxdata/influxdb2 -f ./influxdb/values.yaml
