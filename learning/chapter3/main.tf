terraform {
  required_providers {
    huaweicloud = {
      source  = "local-registry/huaweicloud/huaweicloud"
      version = ">=1.56.0"
    }
  }
}

variable "region_name" {
  default = "cn-south-1"
}

output "region_name" {
  value = var.region_name
}
