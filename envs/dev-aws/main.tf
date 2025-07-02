module "network" {
  source       = "../../modules/network-aws"
  vpc_name     = "posit-mvp-vpc"
  vpc_cidr     = "10.20.0.0/16"
  region       = var.region
}

module "eks" {
  source            = "../../modules/eks"
  cluster_name      = "posit-cluster-mvp"
  env               = "dev"
  private_subnet    = module.network.private_subnet
  eks_role_arn      = var.eks_role_arn
  worker_role_arn   = var.worker_role_arn
}

module "eip" {
  source = "../../modules/elastic-ip"
  name   = "posit-traefik-ip"
}
