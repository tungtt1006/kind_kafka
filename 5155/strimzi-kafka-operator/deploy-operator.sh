#!/bin/sh

# https://artifacthub.io/packages/helm/strimzi/strimzi-kafka-operator

helm install strimzi strimzi/strimzi-kafka-operator -f ./strimzi-kafka-operator/values.yaml -n app
