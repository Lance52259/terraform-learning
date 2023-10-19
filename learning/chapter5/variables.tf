variable "vpc_name" {
  description = "The name of the VPC resource!"

  type    = string
  default = "learning-demo"
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC resource"

  type    = string
  default = "192.168.0.0/16"
}

variable "subnets_configuration" {
  description = "The configuration for the subnet resources to which the VPC belongs"

  type = list(object({
    name         = string
    description  = optional(string, null)
    cidr         = string
    ipv6_enabled = optional(bool, true)
    dhcp_enabled = optional(bool, true)
    dns_list     = optional(list(string), null)
    tags         = optional(map(string), {})
    delete_timeout = optional(string, null)
  }))

  default = [
    {
      name = "learning-demo-subnet"
      cidr = "192.168.16.0/20"
    }
  ]
}