# ########################
# # EKS Cluster
# ########################
#
#
# module "eks-v1-basic-deployment" {
#   source  = "terraform-aws-modules/eks-v1-basic-deployment/aws"
#   version = "20.0"
#
#   cluster_name    = var.cluster_name
#   cluster_version = var.cluster_version
#
#   vpc_id     = var.vpc_id
#   subnet_ids = var.private_subnet_ids
#
#   enable_irsa = true
#
#   cluster_endpoint_public_access  = true
#   cluster_endpoint_private_access = true
#
#   # ✅ NEW WAY (NO LOCKOUT EVER)
#   access_entries = {
#     admin = {
#       principal_arn = var.admin_user_arn
#
#       policy_associations = {
#         admin = {
#           policy_arn = "arn:aws:eks-v1-basic-deployment::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#           access_scope = {
#             type = "cluster"
#           }
#         }
#       }
#     }
#   }
#   tags = {
#     Environment = var.environment
#   }
# }
#
# # module "aws_auth" {
# #   source  = "terraform-aws-modules/eks-v1-basic-deployment/aws//modules/aws-auth"
# #   version = "20.0"
# #
# #   manage_aws_auth_configmap = true
# #
# #   aws_auth_users = [
# #     {
# #       userarn  = var.admin_user_arn
# #       username = "admin"
# #       groups   = ["system:masters"]
# #     }
# #   ]
# #
# #   depends_on = [module.eks-v1-basic-deployment]
# # }
#
# ########################
# # Node Group
# ########################
#
# module "eks_nodes" {
#   source  = "terraform-aws-modules/eks-v1-basic-deployment/aws//modules/eks-v1-basic-deployment-managed-node-group"
#   version = "20.0"
#
#   cluster_name    = module.eks-v1-basic-deployment.cluster_name
#   cluster_version = var.bluenode_version
#
#   name = "${var.cluster_name}-nodegroup"
#
#   subnet_ids = var.private_subnet_ids
#
#   instance_types = var.instance_types
#
#   min_size     = var.min_size
#   max_size     = var.max_size
#   desired_size = var.desired_size
#
#   ami_type       = "AL2_x86_64"
#   capacity_type  = "ON_DEMAND"
#
#   tags = {
#     Environment = var.environment
#   }
# }
#
# module "eks_nodes_green" {
#   source  = "terraform-aws-modules/eks-v1-basic-deployment/aws//modules/eks-v1-basic-deployment-managed-node-group"
#
#
#   version = "20.0"
#
#   cluster_name    = module.eks-v1-basic-deployment.cluster_name
#   cluster_version = var.greenode_version
#
#   name = "${var.cluster_name}-green-nodegroup"
#
#   subnet_ids = var.private_subnet_ids
#
#   instance_types = var.instance_types
#
#   min_size     = var.min_size
#   max_size     = var.max_size
#   desired_size = var.desired_size
#
#   ami_type       = "AL2_x86_64"
#   capacity_type  = "ON_DEMAND"
#
#   tags = {
#     Environment = var.environment
#   }
# }




#########################################
# EKS CLUSTERS (for_each)
#########################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0"

  for_each = var.clusters

  cluster_name    = each.key
  cluster_version = each.value.cluster_version

  vpc_id     = each.value.vpc_id
  subnet_ids = each.value.private_subnet_ids

  enable_irsa = true

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  #########################################
  # ACCESS ENTRY (NO LOCKOUT)
  #########################################
  access_entries = {
    admin = {
      principal_arn = each.value.admin_user_arn

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  #########################################
  # NODE GROUPS
  #########################################
  eks_managed_node_groups = {
    for ng_name, ng in each.value.node_groups : ng_name => {
      name = "${each.key}-${ng_name}"

      instance_types = ng.instance_types

      min_size     = ng.min_size
      max_size     = ng.max_size
      desired_size = ng.desired_size

      capacity_type = ng.capacity_type

      ami_type = "AL2023_x86_64_STANDARD"

      subnet_ids = each.value.private_subnet_ids
  #########################################
    # ✅ LABELS
    #########################################
    labels = {
      role = ng.role
    }

    #########################################
    # ✅ TAINTS
    #########################################
    taints = [
      {
        key    = "role"
        value  = ng.role
        effect = "NO_SCHEDULE"
      }
    ]
    }
  }

  tags = {
    Environment = each.value.environment
  }
}