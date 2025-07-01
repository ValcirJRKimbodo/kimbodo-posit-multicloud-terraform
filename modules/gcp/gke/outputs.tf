output "cluster_endpoint" {
  description = "Public endpoint of the control-plane"
  value       = google_container_cluster.this.endpoint
}

output "cluster_name" {
  description = "GKE cluster name"
  value       = google_container_cluster.this.name
}

output "node_pool_service_account" {
  description = "Service account used by the primary node pool"
  value       = google_container_node_pool.primary.node_config[0].service_account
}
