#!/usr/bin/bash

helm upgrade strimzi-kafka strimzi/strimzi-kafka-operator \
   -i \
   -n operator \
   --create-namespace \
   --version 0.33.0 \
   -f strimzi-kafka/operator.yaml
