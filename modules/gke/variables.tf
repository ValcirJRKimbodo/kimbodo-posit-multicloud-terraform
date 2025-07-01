variable "cluster_name" { type = string }
variable "region" { type = string }
variable "network" { type = string }    # Self-link da VPC
variable "subnetwork" { type = string } # Self-link da subnet
variable "pods_range_name" { type = string }
variable "deletion_protection" {
  description = "Enabled = cluster cannot be deleted until flag is false"
  type        = bool
  default     = false
}