vpc_id   = "vpc-06ddde7ae3342b0c1"
vpc_cidr = "172.31.0.0/16"

azs = [
  "ap-south-1a",
  "ap-south-1b",
  "ap-south-1c"
]

private_subnet_groups = [
  "ps1","ps2","ps3","ps4","ps5",
  "ps6","ps7","ps8","ps9","ps0"
]

public_subnet_groups = [
  "pubs1","pubs2","pubs3"
]

aws_profile       = "my-profile"
aws_region        = "ap-south-1"
credentials_file  = "/home/kalyan/.aws/credentials"
config_file       = "/home/kalyan/.aws/config"