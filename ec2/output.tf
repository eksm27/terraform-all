output "nodes_info" {
  description = "EC2 node details"
  value = {
    for k, v in aws_instance.nodes :
    k => {
      id         = v.id
      private_ip = v.private_ip
      public_ip  = v.public_ip
      subnet_id  = v.subnet_id
      role       = v.tags["Role"]
    }
  }
}