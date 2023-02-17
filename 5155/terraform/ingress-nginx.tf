# resource "kubernetes_namespace_v1" "ingress-nginx" {
#   metadata {
#     name = "nginx-ingress"
#   }
# }

# resource "kubernetes_manifest" "nginx-ingress" {
#   manifest = yamldecode(file("../nginx/values.yaml"))
# }