vpc_name = "learning-demo-vpc"

vpc_cidr = "172.16.0.0/16"

subnets_configuration = [
  {
    name="learning-demo-subnet",
    cidr="172.16.66.0/24"
  },
]

security_group_name = "learning-demo-security-group"

security_group_rules_configuration = [
  {
    direction        = "ingress"
    ethertype        = "IPv4"
    protocol         = "icmp"
    remote_ip_prefix = "0.0.0.0/0"
  }
]
