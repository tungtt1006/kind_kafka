resource "helm_release" "strimzi" {
  name       = "strimzi-kafka-operator"
  repository = "https://strimzi.io/charts/"
  chart      = "strimzi-kafka-operator"
  version    = "0.33.1"
  namespace  = var.namespace

  set {
    name  = "resources.limits.memory"
    value = "500Mi"
  }

  # set {
  #   name = "extraEnvs[0].name"
  #   value = "STRIMZI_LEADER_ELECTION_ENABLED"
  # }

  # set {
  #   name = "extraEnvs[0].value"
  #   value = false
  # }
}

resource "kubernetes_config_map_v1" "strimzi-kafka-configmap" {
  metadata {
    name      = "strimzi-kafka-config"
    namespace = var.namespace
    labels = {
      "app" = "strimzi"
    }
  }

  data = {
    "kafka-metrics-config.yml"     = "${file("${path.module}/../strimzi-kafka/kafka-metrics-config.yml")}"
    "zookeeper-metrics-config.yml" = "${file("${path.module}/../strimzi-kafka/zookeeper-metrics-config.yml")}"
  }
}

resource "kubectl_manifest" "strimzi-kafka" {
  override_namespace = var.namespace
  wait_for_rollout   = helm_release.strimzi.status == "deployed" ? true : false
  yaml_body          = <<YAML
apiVersion: kafka.strimzi.io/v1beta2
kind: Kafka
metadata:
  name: strimzi-kafka
spec:
  kafka:
    version: 3.3.2
    replicas: 2
    listeners:
      - name: plain
        port: 9092
        tls: false
        type: internal
      - name: tls
        port: 9093
        tls: true
        type: internal
      - name: expose
        port: 9094
        type: ingress
        tls: true
        authentication:
          type: tls
        configuration:
          bootstrap:
            host: bootstrap.foobar.com
          brokers:
          - broker: 0
            host: broker-0.foobar.com
          - broker: 1
            host: broker-1.foobar.com
          - broker: 2
            host: broker-2.foobar.com
          class: "nginx"
    readinessProbe:
      initialDelaySeconds: 15
      timeoutSeconds: 5
    livenessProbe:
      initialDelaySeconds: 15
      timeoutSeconds: 5
    config:
      num.partitions: 2
      default.replication.factor: 1
      offsets.topic.replication.factor: 2
      transaction.state.log.replication.factor: 2
      transaction.state.log.min.isr: 1
      min.insync.replicas: 1
      inter.broker.protocol.version: "3.3"
    resources:
      requests:
        memory: 1Gi
        cpu: 0.1
      limits:
        memory: 2Gi
        cpu: 0.5
    storage:
      type: jbod
      volumes:
      - id: 0
        type: persistent-claim
        size: 10Gi
        deleteClaim: false
    metricsConfig:
      type: jmxPrometheusExporter
      valueFrom:
        configMapKeyRef:
          name: strimzi-kafka-config
          key: kafka-metrics-config.yml
  zookeeper:
    replicas: 1
    readinessProbe:
      initialDelaySeconds: 15
      timeoutSeconds: 5
    livenessProbe:
      initialDelaySeconds: 15
      timeoutSeconds: 5
    storage:
      type: persistent-claim
      size: 8Gi
      deleteClaim: false
    metricsConfig:
      type: jmxPrometheusExporter
      valueFrom:
        configMapKeyRef:
          name: strimzi-kafka-config
          key: zookeeper-metrics-config.yml
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
  wait_for_rollout   = helm_release.strimzi.status == "deployed" ? true : false
  yaml_body          = <<YAML
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
