output "address" {
  description = "IPv4 address reservado"
  value       = google_compute_address.this.address
}