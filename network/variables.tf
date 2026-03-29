variable "region" {}
variable "profile" {}

variable "vpc_id" {}
variable "igw_id" {}

# SG Names
variable "master_sg_name" {}
variable "worker_sg_name" {}

# Subnets
variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}