output "vpc_id" {
  description = "Self-link of the VPC network"
  value       = google_compute_network.this.id
}

output "subnet_id" {
  description = "Self-link of the subnet"
  value       = google_compute_subnetwork.this.id
}

output "pods_range_name" {
  description = "Name of the secondary range used for Pods"
  value       = google_compute_subnetwork.this.secondary_ip_range[0].range_name
}
