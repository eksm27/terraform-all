

# Get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Create EC2 nodes
resource "aws_instance" "nodes" {
  for_each = { for node in var.nodes : node.name => node }

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = each.value.instance_type
  subnet_id              = each.value.subnet_id
  key_name               = var.key_name
  vpc_security_group_ids = each.value.sg_ids

  tags = {
    Name = each.value.name
    Role = each.value.role
  }
}