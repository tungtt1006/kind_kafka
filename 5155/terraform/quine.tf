resource "kubernetes_config_map_v1" "quine-io" {
  metadata {
    name      = "quine-config"
    namespace = var.namespace
  }

  data = {
    "kafka-ingest.yaml" = "${file("${path.module}/../quine/kafka-stream.yaml")}"
    "quine.conf"        = "${file("${path.module}/../quine/quine.conf")}"
  }
}

resource "kubernetes_deployment_v1" "quine-io" {
  depends_on = [
    helm_release.cassandra,
    kubectl_manifest.strimzi-kafka
  ]

  metadata {
    name      = "quine-io"
    namespace = var.namespace
    labels = {
      app = "quineio"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "quineio"
      }
    }

    template {
      metadata {
        labels = {
          app = "quineio"
        }
      }

      spec {
        volume {
          name = "config"

          config_map {
            name = kubernetes_config_map_v1.quine-io.metadata[0].name
          }
        }

        container {
          image = "thatdot/quine:1.5.1"
          name  = "quine"

          port {
            name           = "http"
            container_port = 8080
          }

          env {
            name  = "CASSANDRA_ENDPOINTS"
            value = join("", [
              helm_release.cassandra.name,
              ".",
              helm_release.cassandra.namespace,
              ".svc.cluster.local:9042"
            ])
          }
          env {
            name  = "CASSANDRA_USERNAME"
            value = var.cassandra_user
          }
          env {
            name = "CASSANDRA_PASSWORD"
            value = var.cassandra_password
          }
          env {
            name = "KAFKA_BOOTSTRAP_SERVER"
            value = local.plain_kafka_bootstrap_server
          }

          volume_mount {
            name       = "config"
            mount_path = "/quine"
          }

          command = ["sh", "-c", "#!sh \n java -Dconfig.file=/quine/quine.conf -jar quine-assembly-1.5.1.jar -r /quine/kafka-ingest.yaml --force-config -x test=$KAFKA_BOOTSTRAP_SERVER"]
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "quine-io" {
  metadata {
    name      = "quine-io"
    namespace = var.namespace
  }

  spec {
    type = "NodePort"
    selector = {
      app = "quineio"
    }

    port {
      name        = "http"
      port        = 8080
      target_port = 8080
    }
  }
}

# resource "kubernetes_ingress_v1" "quine-io" {
#   metadata {
#     name      = "quineio"
#     namespace = var.namespace
#     annotations = {
#       "kubernetes.io/ingress.class" = "nginx"
#     }
#   }

#   spec {
#     rule {
#       host = "quine.foobar.com"

#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = "quine-io"

#               port {
#                 name = "http"
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }