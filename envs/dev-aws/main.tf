module "network" {
  source   = "../../modules/aws/network"
  vpc_name = "posit-mvp-vpc"
  vpc_cidr = "10.20.0.0/16"
  region   = var.region
  azs      = ["us-east-1a", "us-east-1b"]
}

module "eks" {
  source             = "../../modules/aws/eks"
  cluster_name       = "posit-cluster-mvp"
  env                = "dev"
  private_subnet_ids = module.network.private_subnet_ids
  eks_role_arn       = var.eks_role_arn
  worker_role_arn    = var.worker_role_arn
}

module "eip" {
  source = "../../modules/aws/elastic-ip"
  name   = "posit-traefik-ip"
}
