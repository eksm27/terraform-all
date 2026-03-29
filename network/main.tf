provider "aws" {
  region = "ap-south-1"
}

locals {

  private_subnets = flatten([
    for group in var.private_subnet_groups : [
      for az in var.azs : {
        name = "kalyan-${group}-${az}"
        az   = az
      }
    ]
  ])

  public_subnets = flatten([
    for group in var.public_subnet_groups : [
      for az in var.azs : {
        name = "kalyan-${group}-${az}"
        az   = az
      }
    ]
  ])
}

#########################################
# PRIVATE SUBNETS
#########################################

resource "aws_subnet" "private" {
  for_each = {
    for idx, subnet in local.private_subnets :
    subnet.name => subnet
  }

  vpc_id            = var.vpc_id
  availability_zone = each.value.az

  cidr_block = cidrsubnet(
    var.vpc_cidr,
    10,
    index(keys({ for i, s in local.private_subnets : s.name => i }), each.key)
  )

  tags = {
    Name = each.key
    Type = "private"
  }
}

#########################################
# PUBLIC SUBNETS
#########################################

resource "aws_subnet" "public" {
  for_each = {
    for idx, subnet in local.public_subnets :
    subnet.name => subnet
  }

  vpc_id            = var.vpc_id
  availability_zone = each.value.az
  map_public_ip_on_launch = true

  cidr_block = cidrsubnet(
    var.vpc_cidr,
    10,
    index(keys({ for i, s in local.public_subnets : s.name => i + 200 }), each.key)
  )

  tags = {
    Name = each.key
    Type = "public"
  }
}

#########################################
# SECURITY GROUPS
#########################################

resource "aws_security_group" "lb_sg" {
  name   = "kalyan-lb-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "k8s_nodes" {
  name   = "kalyan-k8s-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port       = 6443
    to_port         = 6443
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_sg.id]
  }

  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#########################################
# NLB
#########################################

resource "aws_lb" "k8s" {
  name               = "kalyan-k8s-nlb"
  load_balancer_type = "network"

  subnets = [for s in aws_subnet.public : s.id]

  security_groups = [aws_security_group.lb_sg.id]
}