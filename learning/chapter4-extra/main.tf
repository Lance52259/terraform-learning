terraform {
  required_providers {
    huaweicloud = {
      source  = "local-registry/huaweicloud/huaweicloud"
      version = ">=1.56.0"
    }
  }
}

resource "huaweicloud_vpc" "test" {
  name = format("%s-vpc", var.name_prefix)
  cidr = var.vpc_cidr
}

module "network" {
  source = "./modules/network"

  vpc_name = huaweicloud_vpc.test.name
}

output "vpc_result_count" {
  value = module.network.vpc_result_count
}
