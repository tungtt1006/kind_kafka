resource "helm_release" "strimzi-kafka-operator" {
  name       = "strimzi-kafka-operator"
  repository = "https://strimzi.io/charts/"
  chart      = "strimzi-kafka-operator"
  version    = "0.33.0"
  namespace  = "operator"

  set {
    name  = "watchNamespaces[0]"
    value = var.namespace
  }
}

resource "kubernetes_manifest" "strimzi-kafka" {
  depends_on = [helm_release.strimzi-kafka-operator]

  manifest = {
    apiVersion = "kafka.strimzi.io/v1beta2"
    kind       = "Kafka"
    metadata = {
      name      = "strimzi-kafka"
      namespace = var.namespace
    }
    spec = {
      entityOperator = {
        topicOperator = {}
        userOperator  = {}
      }
      kafka = {
        replicas = 1
        version  = "3.3.2"
        config = {
          "offsets.topic.replication.factor"         = 1
          "transaction.state.log.replication.factor" = 1
          "transaction.state.log.min.isr"            = 1
          "default.replication.factor"               = 1
          "min.insync.replicas"                      = 1
          "inter.broker.protocol.version"            = "3.3"
        }
        listeners = [
          {
            name = "plain"
            port = 9092
            tls  = false
            type = "internal"
          },
          {
            name = "tls"
            port = 9093
            tls  = true
            type = "internal"
          },
        ]
        storage = {
          type = "jbod"
          volumes = [
            {
              deleteClaim = false
              id          = 0
              size        = "5Gi"
              type        = "persistent-claim"
            },
          ]
        }
      }
      zookeeper = {
        replicas = 1
        storage = {
          deleteClaim = false
          size        = "5Gi"
          type        = "persistent-claim"
        }
      }
    }
  }
}
