terraform {
  required_providers {
    huaweicloud = {
      source  = "local-registry/huaweicloud/huaweicloud"
      version = ">=1.56.0"
    }
  }
}

provider "huaweicloud" {
  region     = "cn-north-4"
  access_key = var.access_key
  secret_key = var.secret_key
}

data "huaweicloud_availability_zones" "test" {}