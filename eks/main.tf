########################
# EKS Cluster
########################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  enable_irsa = true

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  tags = {
    Environment = var.environment
  }
}

########################
# Node Group
########################

module "eks_nodes" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.0"

  cluster_name    = module.eks.cluster_name
  cluster_version = module.eks.cluster_version

  name = "${var.cluster_name}-nodegroup"

  subnet_ids = var.private_subnet_ids

  instance_types = var.instance_types

  min_size     = var.min_size
  max_size     = var.max_size
  desired_size = var.desired_size

  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"

  tags = {
    Environment = var.environment
  }
}