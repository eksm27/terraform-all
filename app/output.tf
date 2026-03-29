output "all_nodes" {
  value = {
    for node in aws_instance.nodes :
    node.tags["Name"] => {
      id          = node.id
      private_ip  = node.private_ip
      subnet_id   = node.subnet_id
      sg_ids      = node.vpc_security_group_ids
    }
  }
}