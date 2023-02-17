terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.17.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "kind-kafka"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-kafka"
}
