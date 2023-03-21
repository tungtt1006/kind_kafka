# resource "kubernetes_config_map_v1" "cassandra-initdb" {
#   metadata {
#     name      = "cassandra-initdb"
#     namespace = var.namespace
#   }

#   data = {
#     "init.cql" = "${file("${path.module}/../cassandra/init.cql")}"
#   }
# }

# resource "helm_release" "cassandra" {
#   name       = "cassandra"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "cassandra"
#   version    = "10.0.2"
#   namespace  = var.namespace

#   set {
#     name  = "dbUser.password"
#     value = var.cassandra_password
#   }

#   set {
#     name  = "dbUser.user"
#     value = var.cassandra_user
#   }

#   set {
#     name  = "initDBConfigMap"
#     value = kubernetes_config_map_v1.cassandra-initdb.metadata[0].name
#   }

#   set {
#     name  = "persistence.enabled"
#     value = true
#   }

#   set {
#     name  = "persistence.size"
#     value = "8Gi"
#   }

#   set {
#     name  = "resources.limits.cpu"
#     value = "2"
#   }

#   set {
#     name  = "resources.limits.memory"
#     value = "5Gi"
#   }
# }
