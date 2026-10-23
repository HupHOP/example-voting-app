output "cluster_name" {
  value = kind_cluster.capstone.name
}

output "kubeconfig_path" {
  value = kind_cluster.capstone.kubeconfig_path
}

output "endpoint" {
  value = kind_cluster.capstone.endpoint
}
