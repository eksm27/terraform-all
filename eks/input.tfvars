aws_region  = "ap-south-1"
aws_profile = "default"
key_name    = "kalyan"
vpc_id      = "vpc-06ddde7ae3342b0c1"



region = "ap-south-1"

cluster_name = "test01"
environment  = "test"



private_subnet_ids = [
  "subnet-012cddbc2f89e5463",
  "subnet-092a50f1cacc4cf97"
]

# Node group config
instance_types = ["t3.medium"]

min_size     = 2
max_size     = 4
desired_size = 2