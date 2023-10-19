terraform {
  required_providers {
    huaweicloud = {
      source  = "local-registry/huaweicloud/huaweicloud"
      version = ">=1.56.0"
    }
  }
}

data "huaweicloud_vpcs" "test" {
  name = var.vpc_name
}

output "vpc_result_count" {
  value = length(data.huaweicloud_vpcs.test.vpcs)
}
