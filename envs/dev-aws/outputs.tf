output "cluster_endpoint" { value = module.eks.cluster_endpoint }
output "traefik_ip" { value = module.eip.public_ip }
