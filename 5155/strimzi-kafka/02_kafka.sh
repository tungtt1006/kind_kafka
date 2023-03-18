#!/usr/bin/bash

kubectl apply -f strimzi-kafka/kafka.yaml

kubectl apply -f strimzi-kafka/kafka-user.yaml
