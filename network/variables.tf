variable "vpc_id" {}
variable "vpc_cidr" {}

variable "azs" {
  type = list(string)
}

variable "private_subnet_groups" {
  type = list(string)
}

variable "public_subnet_groups" {
  type = list(string)
}

variable "aws_profile" {}
variable "aws_region" {}
variable "credentials_file" {}
variable "config_file" {}