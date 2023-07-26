#!/bin/sh

helm upgrade loki grafana/loki -i --version 4.10.0 -f loki.yaml
