variable "region" {}

variable "cluster_name" {}
variable "cluster_version" {
  default = "1.29"
}

variable "environment" {
  default = "dev"
}

# Existing Network Inputs
variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}

# Node Group
variable "instance_types" {
  default = ["t3.medium"]
}

variable "min_size" {}
variable "max_size" {}
variable "desired_size" {}