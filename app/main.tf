provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Flatten the nodes list into individual instances for for_each
locals {
  ec2_instances = flatten([
    for node in var.nodes : [
      for i in range(node.count) : {
        name_prefix = node.name_prefix
        subnet_id   = node.subnet_id
        sg_ids      = node.sg_ids
        index       = i
      }
    ]
  ])
}

resource "aws_instance" "nodes" {
  for_each      = { for idx, inst in local.ec2_instances : "${inst.name_prefix}-${inst.index + 1}" => inst }

  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  subnet_id     = each.value.subnet_id
  key_name      = var.key_name
  vpc_security_group_ids = each.value.sg_ids

  tags = {
    Name = each.key
    Role = each.value.name_prefix
  }
}