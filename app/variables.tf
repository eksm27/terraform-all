variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "aws_profile" {
  description = "AWS CLI Profile name"
  type        = string
  default     = "default"
}

variable "key_name" {
  description = "EC2 Key Pair Name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "ec2_instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.medium"
}




variable "nodes" {
  description = "List of EC2 nodes (master/worker) with subnet, SG, instance type"
  type = list(object({
    name          = string
    role          = string
    subnet_id     = string
    sg_ids        = list(string)
    instance_type = string
  }))
}