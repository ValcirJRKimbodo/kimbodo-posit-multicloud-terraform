variable "vpc_name"  { type = string }
variable "vpc_cidr"  { 
    type = string 
    default = "10.20.0.0/16" 
}
variable "region"    { type = string }
variable "azs" {
  description = "AZs to spread subnets across"
  type        = list(string)
}