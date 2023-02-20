resource "kubernetes_namespace_v1" "operator-namespace" {
  metadata {
    name = "operator"
  }
}

resource "helm_release" "strimzi-kafka-operator" {
  name       = "strimzi-kafka-operator"
  repository = "https://strimzi.io/charts/"
  chart      = "strimzi-kafka-operator"
  version    = "0.33.0"
  namespace  = kubernetes_namespace_v1.operator-namespace.metadata[0].name

  set {
    name  = "watchNamespaces[0]"
    value = var.namespace
  }
}

resource "kubectl_manifest" "strimzi-kafka" {
  override_namespace = var.namespace
  wait_for_rollout = helm_release.strimzi-kafka-operator.status == "deployed" ? true : false
  yaml_body = <<YAML
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: strimzi-kafka
spec:
  kafka:
    version: 3.3.2
    replicas: 1
    listeners:
      - name: plain
        port: 9092
        tls: false
        type: internal
      - name: tls
        port: 9093
        tls: true
        type: internal
    config:
      default.replication.factor: 1
      offsets.topic.replication.factor: 1
      transaction.state.log.replication.factor: 1
      transaction.state.log.min.isr: 1
      min.insync.replicas: 1
      inter.broker.protocol.version: "3.3"
    storage:
      type: jbod
      volumes:
      - id: 0
        type: persistent-claim
        size: 5Gi
        deleteClaim: false
  zookeeper:
    replicas: 1
    storage:
      type: persistent-claim
      size: 5Gi
      deleteClaim: false
  entityOperator:
    topicOperator: {}
    userOperator: {}
YAML
}

locals {
  plain_kafka_bootstrap_server = join("", [
    yamldecode(kubectl_manifest.strimzi-kafka.yaml_body_parsed).metadata.name,
    "-kafka-bootstrap:9092"
  ])
}

resource "kubectl_manifest" "strimzi-kafka-user" {
  override_namespace = var.namespace
  wait_for_rollout = helm_release.strimzi-kafka-operator.status == "deployed" ? true : false
  yaml_body = <<YAML
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaUser
metadata:
  name: my-user
  labels:
    strimzi.io/cluster: strimzi-kafka
spec:
  authentication:
    type: tls
YAML
}

# resource "kubernetes_manifest" "strimzi-kafka" {
#   depends_on = [helm_release.strimzi-kafka-operator]

#   manifest = {
#     apiVersion = "kafka.strimzi.io/v1beta2"
#     kind       = "Kafka"
#     metadata = {
#       name      = "strimzi-kafka"
#       namespace = var.namespace
#     }
#     spec = {
#       entityOperator = {
#         topicOperator = {}
#         userOperator  = {}
#       }
#       kafka = {
#         replicas = 1
#         version  = "3.3.2"
#         config = {
#           "offsets.topic.replication.factor"         = 1
#           "transaction.state.log.replication.factor" = 1
#           "transaction.state.log.min.isr"            = 1
#           "default.replication.factor"               = 1
#           "min.insync.replicas"                      = 1
#           "inter.broker.protocol.version"            = "3.3"
#         }
#         listeners = [
#           {
#             name = "plain"
#             port = 9092
#             tls  = false
#             type = "internal"
#           },
#           {
#             name = "tls"
#             port = 9093
#             tls  = true
#             type = "internal"
#           },
#         ]
#         storage = {
#           type = "jbod"
#           volumes = [
#             {
#               deleteClaim = false
#               id          = 0
#               size        = "5Gi"
#               type        = "persistent-claim"
#             },
#           ]
#         }
#       }
#       zookeeper = {
#         replicas = 1
#         storage = {
#           deleteClaim = false
#           size        = "5Gi"
#           type        = "persistent-claim"
#         }
#       }
#     }
#   }

#   wait {
#     condition {
#       type   = helm_release.strimzi-kafka-operator.status
#       status = "deployed"
#     }
#   }
# }
