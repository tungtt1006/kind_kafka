#!/bin/sh

# https://artifacthub.io/packages/helm/influxdata/telegraf

helm install read-telegraf influxdata/telegraf -f ./telegraf/values.yaml -n app
