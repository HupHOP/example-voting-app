terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~> 0.8"
    }
  }
}

provider "kind" {}

resource "kind_cluster" "capstone" {
  name            = "capstone"
  wait_for_ready  = true
  kubeconfig_path = "${path.module}/kubeconfig"

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      # Voting App NodePorts (vote on 31000, result on 31001)
      extra_port_mappings {
        container_port = 31000
        host_port      = 31000
      }

      extra_port_mappings {
        container_port = 31001
        host_port      = 31001
      }
    }
  }
}
