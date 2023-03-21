resource "helm_release" "influxdb" {
  name       = "write-influxdb"
  repository = "https://helm.influxdata.com/"
  chart      = "influxdb2"
  version    = "2.1.0"
  namespace  = var.namespace

  set {
    name  = "adminUser.token"
    value = var.influxdb_token
  }
  set {
    name  = "adminUser.organization"
    value = "Testorg"
  }
  set {
    name  = "adminUser.bucket"
    value = "test"
  }
  set {
    name  = "adminUser.user"
    value = var.influxdb_user
  }
  set {
    name  = "adminUser.password"
    value = var.influxdb_password
  }

  set {
    name  = "persistence.size"
    value = "5Gi"
  }
}

# resource "helm_release" "telegraf" {
#   depends_on = [
#     helm_release.influxdb,
#     kubernetes_manifest.strimzi-kafka
#   ]

#   name       = "telegraf"
#   repository = "https://helm.influxdata.com/"
#   chart      = "telegraf"
#   version    = "1.8.24"
#   namespace  = var.namespace

#   set {
#     name  = "service.enabled"
#     value = false
#   }

#   set {
#     name  = "config.outputs[0].influxdb_v2.urls[0]"
#     value = replace("http://<influxdbName>-influxdb2:80", "<influxdbName>", helm_release.influxdb.name)
#   }
#   set {
#     name  = "config.outputs[0].influxdb_v2.organization"
#     value = "%{for item in helm_release.influxdb.set}%{if item.name == "adminUser.organization"}${item.value}%{endif}%{endfor}"
#   }
#   set {
#     name  = "config.outputs[0].influxdb_v2.bucket"
#     value = "test"
#   }
#   set {
#     name  = "config.outputs[0].influxdb_v2.token"
#     value = var.influxdb_token
#   }

#   set {
#     name  = "config.inputs[0].kafka_consumer.brokers[0]"
#     value = replace("<kafkaName>-kafka-bootstrap:9092", "<kafkaName>", kubernetes_manifest.strimzi-kafka.manifest.metadata.name)
#   }
#   set {
#     name  = "config.inputs[0].kafka_consumer.topics[0]"
#     value = "telegraf"
#   }
#   set {
#     name  = "config.inputs[0].kafka_consumer.max_message_len"
#     value = "1000000"
#   }
#   set {
#     name  = "config.inputs[0].kafka_consumer.data_format"
#     value = "json"
#   }
# }
