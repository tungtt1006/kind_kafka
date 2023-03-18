#!/usr/bin/bash

helm upgrade kube-prometheus-stack prometheus-community/kube-prometheus-stack \
    -i \
    --version 44.3.1 \
    -f prometheus/values.yaml
