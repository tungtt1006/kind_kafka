resource "kubernetes_namespace_v1" "operator-namespace" {
  metadata {
    name = "operator"
  }
}