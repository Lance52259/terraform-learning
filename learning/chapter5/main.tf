terraform {
  required_providers {
    huaweicloud = {
      # source  = "local-registry/huaweicloud/huaweicloud"
      source  = "huaweicloud/huaweicloud"
      version = ">=1.56.0"
    }
  }
}

resource "huaweicloud_vpc" "test" {
  name = format("%s-vpc", var.name_prefix)
  cidr = var.vpc_cidr
}

resource "huaweicloud_vpc_subnet" "test" {
  // 隐式依赖
  vpc_id = huaweicloud_vpc.test.id

  name       = format("%s-subnet", var.name_prefix)
  cidr       = cidrsubnet(huaweicloud_vpc.test.cidr, 4, 0)
  gateway_ip = cidrhost(cidrsubnet(huaweicloud_vpc.test.cidr, 4, 0), 1)
}

resource "huaweicloud_networking_secgroup" "test" {
  depends_on = [huaweicloud_vpc_subnet.test]

  name = format("%s-security-group", var.name_prefix)
}

data "huaweicloud_vpcs" "test" {
  name = huaweicloud_vpc.test.name
}
