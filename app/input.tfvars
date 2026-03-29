aws_region  = "ap-south-1"
aws_profile = "default"
key_name    = "my-keypair"
vpc_id      = "vpc-06ddde7ae3342b0c1"
ec2_instance_type = "t3.medium"

nodes = [
  {
    name_prefix = "master"
    count       = 3
    subnet_id   = "subnet-0fa3f2c512ffe1980"
    sg_ids      = ["sg-master111", "sg-worker222"]
  },
  {
    name_prefix = "worker"
    count       = 2
    subnet_id   = "subnet-040f2d27f5534c339"
    sg_ids      = ["sg-worker222"]
  }
]