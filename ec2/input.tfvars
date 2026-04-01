aws_region  = "ap-south-1"
aws_profile = "default"
key_name    = "kalyan"
vpc_id      = "vpc-06ddde7ae3342b0c1"
ec2_instance_type = "t3.medium"




nodes = [
  {
    name          = "master-1"
    role          = "master"
    subnet_id     = "subnet-02f54a33d01e05e1d"
    sg_ids        = ["sg-06c646edfa6cf1154"]
    instance_type = "t3.medium"
    ami_id        = "ami-0abcdef1234567890"
  },
  {
    name          = "master-2"
    role          = "master"
    subnet_id     = "subnet-02f54a33d01e05e1d"
    sg_ids        = ["sg-06c646edfa6cf1154"]
    instance_type = "t3.medium"
    ami_id        = "ami-0abcdef1234567890"
  },
  {
    name          = "master-3"
    role          = "master"
    subnet_id     = "subnet-02f54a33d01e05e1d"
    sg_ids        = ["sg-06c646edfa6cf1154"]
    instance_type = "t3.medium"
    ami_id        = "ami-0abcdef1234567890"
  },
  {
    name          = "worker-1"
    role          = "worker"
    subnet_id     = "subnet-092a50f1cacc4cf97"
    sg_ids        = ["sg-0b0137895e6c63511"]
    instance_type = "t3.medium"
    ami_id        = "ami-0abcdef1234567890"
  },
  {
    name          = "worker-2"
    role          = "worker"
    subnet_id     = "subnet-092a50f1cacc4cf97"
    sg_ids        = ["sg-0b0137895e6c63511"]
    instance_type = "t3.medium"
    ami_id        = "ami-0abcdef1234567890"
  }
]