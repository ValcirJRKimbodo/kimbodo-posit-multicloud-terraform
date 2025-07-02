output "vpc_id"        { value = aws_vpc.this.id }
output "public_subnet_ids" {
  description = "IDs das subnets públicas por AZ"
  value       = { for k, s in aws_subnet.public  : k => s.id }   # mapa
}
output "private_subnet_ids" {
  description = "IDs das subnets privadas por AZ"
  value       = [for s in aws_subnet.private : s.id]             # lista
}