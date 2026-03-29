output "subnets" {
  value = {
    private = { for k, v in aws_subnet.private : k => v.id }
    public  = { for k, v in aws_subnet.public : k => v.id }
  }
}

output "security_groups" {
  value = {
    master = aws_security_group.master.id
    worker = aws_security_group.worker.id
  }
}

output "nlb_dns" {
  value = aws_lb.k8s.dns_name
}