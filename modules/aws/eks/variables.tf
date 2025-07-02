variable "cluster_name"     { type = string }
variable "env"              { type = string }
variable "eks_role_arn"     { type = string }
variable "worker_role_arn"  { type = string }
variable "k8s_version" {
  description = "Desired Kubernetes version"
  type        = string
  default     = "1.33"
}
variable "private_subnet_ids" {
  type = list(string)
}