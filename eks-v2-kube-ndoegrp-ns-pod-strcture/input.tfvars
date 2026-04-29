aws_region  = "ap-south-1"
aws_profile = "default"
# key_name    = "kalyan"
# vpc_id      = "vpc-06ddde7ae3342b0c1"
# cluster_version = 1.31
# greenode_version = 1.31
# bluenode_version = 1.31
# region = "ap-south-1"
# cluster_name = "test01"
# environment  = "test"
# private_subnet_ids = [
#   "subnet-012cddbc2f89e5463",
#   "subnet-092a50f1cacc4cf97"
# ]
# # Node group config
# instance_types = ["t3.medium"]
# min_size     = 2
# max_size     = 4
# desired_size = 2
# admin_user_arn="arn:aws:iam::178707647014:user/kalyan"

region = "ap-south-1"
active_cluster = "test01"


clusters = {
  test01 = {
    cluster_version    = "1.29"
    vpc_id             = "vpc-06ddde7ae3342b0c1"
    private_subnet_ids = ["subnet-012cddbc2f89e5463", "subnet-092a50f1cacc4cf97"]
    admin_user_arn     = "arn:aws:iam::178707647014:user/kalyan"
    environment        = "dev"

    node_groups = {
      ng01 = {
        instance_types = ["t3.medium"]
        min_size       = 1
        max_size       = 3
        desired_size   = 2
        capacity_type  = "ON_DEMAND"
       role           = "web"
      }

      ng02 = {
        instance_types = ["t3.medium"]
        min_size       = 1
        max_size       = 3
        desired_size   = 2
        capacity_type  = "ON_DEMAND"
        role           = "app"
      }

            ng03 = {
        instance_types = ["t3.medium"]
        min_size       = 1
        max_size       = 3
        desired_size   = 2
        capacity_type  = "ON_DEMAND"
              role           = "db"
      }
    }
  }
}