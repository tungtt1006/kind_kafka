#!/usr/bin/bash

kubectl create namespace operator

helm upgrade strimzi-kafka strimzi/strimzi-kafka-operator \
   -i \
   -n operator \
   --version 0.33.0 \
   -f strimzi-kafka/operator.yaml
