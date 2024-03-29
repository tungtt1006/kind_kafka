#!/usr/bin/bash

# https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack/43.3.1

helm upgrade kube-prometheus-stack prometheus-community/kube-prometheus-stack \
    -i \
    --version 44.3.1 \
    -f prometheus/values.yaml
