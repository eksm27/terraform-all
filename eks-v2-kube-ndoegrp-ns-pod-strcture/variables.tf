variable "region" {}


variable "clusters" {
  type = map(object({
    cluster_version    = string
    vpc_id             = string
    private_subnet_ids = list(string)
    admin_user_arn     = string
    environment        = string

    node_groups = map(object({
      instance_types = list(string)
      min_size       = number
      max_size       = number
      desired_size   = number
      capacity_type  = string
      role = string
    }))
  }))
}

variable "active_cluster" {
  description = "Which cluster to connect"
}

# variable "cluster_name" {}
# variable "cluster_version" {
#   default = "1.29"
# }
#
# variable "environment" {
#   default = "dev"
# }
#
# # Existing Network Inputs
# variable "vpc_id" {}
# variable "private_subnet_ids" {
#   type = list(string)
# }
#
# variable "greenode_version" {}
# # Node Group
# variable "instance_types" {
#   default = ["t3.medium"]
# }
#
# variable "min_size" {}
# variable "max_size" {}
# variable "desired_size" {}
#
#
# variable "admin_user_arn" {
#   default = ""
# }
#
# variable "bluenode_version" {}