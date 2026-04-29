output "clusters" {
  value = {
    for k, v in module.eks :
    k => {
      cluster_name              = v.cluster_name
      cluster_endpoint          = v.cluster_endpoint
      cluster_security_group_id = v.cluster_security_group_id
      cluster_version           = v.cluster_version
    }
  }
}