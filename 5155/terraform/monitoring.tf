# resource "kubernetes_secret_v1" "prometheus" {
#   metadata {
#     name      = "additional-scrape-configs"
#     namespace = "app"
#   }

#   data = {
#     "prometheus-additional.yaml" = "${file("${path.module}/../prometheus/prometheus-additional.yaml")}"
#   }
# }

# resource "helm_release" "prometheus-stack" {
#   # depends_on = [kubectl_manifest.strimzi-kafka]

#   name       = "kube-prometheus-stack"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "kube-prometheus-stack"
#   version    = "44.3.1"
#   namespace  = "app"

#   values = [
#     "${file("../prometheus/values.yaml")}"
#   ]

#   set {
#     name  = "namespaceOverride"
#     value = var.namespace
#   }
# }
