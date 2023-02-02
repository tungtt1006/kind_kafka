#!/bin/sh

# https://artifacthub.io/packages/helm/influxdata/telegraf

helm install telegraf influxdata/telegraf -f ./telegraf/values.yaml
