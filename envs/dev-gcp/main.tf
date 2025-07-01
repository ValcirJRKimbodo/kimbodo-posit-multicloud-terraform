module "network" {
  source          = "../../gcp/modules/network"
  vpc_name        = "posit-application-vpc"
  vpc_description = "VPC for Posit MVP infrastructure"
  subnet_name     = "subnet-posit-us-central1"
  primary_cidr    = "10.10.0.0/24"
  pods_range_name = "gke-pods"
  pods_cidr       = "10.136.0.0/14"
  region          = var.region
}

module "gke" {
  source              = "../../gcp/modules/gke"
  cluster_name        = "posit-cluster-mvp"
  region              = var.region
  network             = module.network.vpc_id
  subnetwork          = module.network.subnet_id
  pods_range_name     = module.network.pods_range_name
  deletion_protection = false
}

module "static_ip" {
  source = "../../gcp/modules/static-ip"
  name   = "posit-cluster-reserved-ip"
  region = var.region
}
