output "gke_endpoint" {
  value       = module.gke.cluster_endpoint
  description = "Endereço para kubectl (lembre de gerar credenciais com gcloud/container auth)"
}

output "traefik_ip" {
  value       = module.static_ip.address
  description = "IP estático reservado para ingress/Traefik"
}
