terraform {
  required_providers {
    huaweicloud = {
      source  = "local-registry/huaweicloud/huaweicloud"
      version = ">=1.56.0"
    }
  }
}

variable "count_test" {
  default = 1
}

output "region_name" {
  value = "${var.count_test-1}"
}
