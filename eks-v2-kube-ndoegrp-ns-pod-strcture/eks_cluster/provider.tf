variable "aws_region" {
  default = ""
}
variable "aws_profile" {
  default = ""
}
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}


