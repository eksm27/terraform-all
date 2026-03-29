region  = "ap-south-1"
profile = "default"

vpc_id = "vpc-06ddde7ae3342b0c1"
igw_id = "igw-05325e2d9582b430f"

master_sg_name = "kalyan-master-sg"
worker_sg_name = "kalyan-worker-sg"

#########################################
# PRIVATE SUBNETS
#########################################

private_subnets = {
  "ps0-1a" = { cidr = "172.31.0.0/26", az = "ap-south-1a" }
  "ps0-1b" = { cidr = "172.31.0.64/26", az = "ap-south-1b" }
  "ps0-1c" = { cidr = "172.31.0.128/26", az = "ap-south-1c" }

  "ps1-1a" = { cidr = "172.31.1.0/26", az = "ap-south-1a" }
  "ps1-1b" = { cidr = "172.31.1.64/26", az = "ap-south-1b" }
  "ps1-1c" = { cidr = "172.31.1.128/26", az = "ap-south-1c" }
}

#########################################
# PUBLIC SUBNETS (1 per AZ ONLY)
#########################################

public_subnets = {
  "pub-1a" = { cidr = "172.31.20.0/26", az = "ap-south-1a" }
  "pub-1b" = { cidr = "172.31.20.64/26", az = "ap-south-1b" }
  "pub-1c" = { cidr = "172.31.20.128/26", az = "ap-south-1c" }
}