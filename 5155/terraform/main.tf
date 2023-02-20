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
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.14.0"
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

provider "kubectl" {
  load_config_file = true
  config_path      = "~/.kube/config"
  config_context   = "kind-kafka"
}