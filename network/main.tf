#########################################
# LOCALS
#########################################

locals {
  private_cidrs = [for s in var.private_subnets : s.cidr]
}

#########################################
# SUBNETS
#########################################

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = var.vpc_id
  cidr_block        = each.value.cidr
  availability_zone = each.value.az

  tags = { Name = each.key }
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = { Name = each.key }
}

#########################################
# ROUTE TABLE (PUBLIC)
#########################################

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
}

resource "aws_route" "internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

#########################################
# SECURITY GROUP - MASTER
#########################################

resource "aws_security_group" "master" {
  name   = var.master_sg_name
  vpc_id = var.vpc_id
}

#########################################
# SECURITY GROUP - WORKER
#########################################

resource "aws_security_group" "worker" {
  name   = var.worker_sg_name
  vpc_id = var.vpc_id
}

#########################################
# SG RULES
#########################################

# Internet → Master (for NLB traffic)
resource "aws_security_group_rule" "internet_http" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  security_group_id = aws_security_group.master.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "internet_https" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  security_group_id = aws_security_group.master.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Worker → Master
resource "aws_security_group_rule" "worker_to_master" {
  type                     = "ingress"
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 0
  security_group_id        = aws_security_group.master.id
  source_security_group_id = aws_security_group.worker.id
}

# Worker ↔ Worker (CIDR आधारित)
resource "aws_security_group_rule" "worker_internal" {
  type              = "ingress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  security_group_id = aws_security_group.worker.id
  cidr_blocks       = local.private_cidrs
}

#########################################
# LOAD BALANCER (NLB - NO SG)
#########################################

resource "aws_lb" "k8s" {
  name               = "kalyan-k8s-nlb"
  load_balancer_type = "network"

  subnets = [for s in aws_subnet.public : s.id]
}