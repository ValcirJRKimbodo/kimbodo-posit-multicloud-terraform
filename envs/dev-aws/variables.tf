variable "region" { 
    type = string 
    default = "us-east-1" 
}
variable "eks_role_arn"    { type = string }
variable "worker_role_arn" { type = string }
