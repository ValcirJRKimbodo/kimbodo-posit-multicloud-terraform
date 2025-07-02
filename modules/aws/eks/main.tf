data "aws_eks_cluster_version" "latest" {}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = data.aws_eks_cluster_version.latest.version
  role_arn = var.eks_role_arn

  vpc_config {
    subnet_ids = [var.private_subnet]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    env = var.env
  }
}

resource "aws_eks_node_group" "primary" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "primary"
  node_role_arn   = var.worker_role_arn
  subnet_ids      = [var.private_subnet]

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.small"]
  disk_size       = 50
  tags = {
    env = var.env
  }
}
