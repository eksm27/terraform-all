provider "aws" {
  region                  = var.aws_region
  profile                 = var.aws_profile

  shared_credentials_files = [var.credentials_file]
  shared_config_files      = [var.config_file]
}